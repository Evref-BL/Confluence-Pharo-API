Class {
	#name : #ConfluencePharoAPI,
	#superclass : #Object,
	#instVars : [
		'znClient',
		'port',
		'endpoint',
		'user',
		'basePath',
		'https',
		'apiToken',
		'bearerToken',
		'rawData',
		'generalReader',
		'writer'
	],
	#category : #ConfluencePharoAPI
}

{ #category : #accessing }
ConfluencePharoAPI >> apiToken [

	^ apiToken
]

{ #category : #accessing }
ConfluencePharoAPI >> apiToken: anObject [

	apiToken := anObject
]

{ #category : #accessing }
ConfluencePharoAPI >> basePath [

	^ basePath
]

{ #category : #accessing }
ConfluencePharoAPI >> basePath: anObject [

	basePath := anObject
]

{ #category : #accessing }
ConfluencePharoAPI >> beHttp [

	https := false
]

{ #category : #accessing }
ConfluencePharoAPI >> beHttps [

	https := true
]

{ #category : #accessing }
ConfluencePharoAPI >> bearerToken [

	^ bearerToken
]

{ #category : #accessing }
ConfluencePharoAPI >> bearerToken: anObject [

	bearerToken := anObject
]

{ #category : #'api - children' }
ConfluencePharoAPI >> childrenOfPage: pageID [

	self prepareZnClient.
	znClient path:
		self basePath , '/pages/' , pageID printString , '/children'.
	self rawData ifFalse: [
		znClient contentReader: [ :entity |
			generalReader
				on: entity contents readStream;
				nextAs: ConfluencePharoPage ] ].
	^ znClient get
]

{ #category : #'api - page' }
ConfluencePharoAPI >> createPage: title inSpace: spaceID withParentId: aParentID andBody: aConfluencePharoPageBodyWrite [

	self prepareZnClient.
	znClient path: self basePath , '/pages'.
	self rawData ifFalse: [
		znClient contentReader: [ :entity |
			generalReader
				on: entity contents readStream;
				nextAs: ConfluencePharoPage ] ].
	znClient contentWriter: [ :data |
		ZnEntity json: (String streamContents: [ :str |
				 writer
					 on: str;
					 nextPut: data ]) ].
	znClient contents: {
			(#title -> title).
			(#spaceId -> spaceID).
			(#parentId -> aParentID).
			(#body -> aConfluencePharoPageBodyWrite) } asDictionary.
	^ znClient post
]

{ #category : #'api - page' }
ConfluencePharoAPI >> downloadPage: aPageIDOrConfluencePage asPDFIn: aFileReference [

	| pageId reference firstAnwser secondAnwser startTaskID ajsTaskID locationOfPDF startLocation endLocation |
	pageId := (aPageIDOrConfluencePage isKindOf: ConfluencePharoPage)
		          ifTrue: [ aPageIDOrConfluencePage id ]
		          ifFalse: [ aPageIDOrConfluencePage ].
	reference := aFileReference asFileReference.
	self prepareZnClient.
	znClient
		accept: ZnMimeType applicationJson;
		contentReader: [ :entity |  ];
		contentWriter: [ :data |  ].
	znClient path: '/wiki/spaces/flyingpdf/pdfpageexport.action'.
	znClient headerAt: 'X-Atlassian-Token' put: 'no-check'.
	znClient queryAt: 'pageId' put: pageId.
	"trigger"
	firstAnwser := znClient
		               get;
		               response.
	"Get triggered taskID"
	startTaskID := (firstAnwser entity string findString:
		                '<meta name="ajs-taskId" content="')
	               + '<meta name="ajs-taskId" content="' size.
	ajsTaskID := firstAnwser entity string
		             copyFrom: startTaskID
		             to: startTaskID + 8.
	"extract task status"
	self prepareZnClient.
	znClient
		accept: ZnMimeType applicationXml;
		contentReader: [ :entity |  ];
		contentWriter: [ :data |  ].
	znClient path: '/wiki/runningtaskxml.action'.
	znClient headerAt: 'X-Atlassian-Token' put: 'no-check'.
	znClient queryAt: 'taskId' put: ajsTaskID. "how to get this taskID?"
	"trigger"
	secondAnwser := znClient
		                get;
		                response.
	"wait for pdf generation"
	[
	secondAnwser entity string includesSubstring:
		'<isComplete>true</isComplete>' ] whileFalse: [
		secondAnwser := znClient
			                get;
			                response.
		0.5 second wait ].


	startLocation := (secondAnwser entity string findString:
		                  'href=&quot;') + 'href=&quot;' size.
	endLocation := (secondAnwser entity string findString: '&quot;&gt;')
	               - 1.
	locationOfPDF := secondAnwser entity string
		                 copyFrom: startLocation
		                 to: endLocation.

	self prepareZnClient.
	znClient
		accept: ZnMimeType applicationPdf;
		contentReader: [ :entity |  ];
		contentWriter: [ :data |  ].
	znClient path: locationOfPDF.
	znClient get.
	aFileReference binaryWriteStreamDo: [ :writeStream |
		writeStream nextPutAll: znClient entity bytes ]
]

{ #category : #accessing }
ConfluencePharoAPI >> endpoint [

	^ endpoint
]

{ #category : #accessing }
ConfluencePharoAPI >> endpoint: anObject [

	endpoint := anObject
]

{ #category : #accessing }
ConfluencePharoAPI >> generalReader [

	^ generalReader
]

{ #category : #accessing }
ConfluencePharoAPI >> generalReader: anObject [

	generalReader := anObject
]

{ #category : #'helper - pages' }
ConfluencePharoAPI >> getAllPagesOfSpaceId: aSpaceId [

	| pages tmp itemByPage |
	itemByPage := 25.
	pages := OrderedCollection new.
	tmp := self getPagesFromCursor: nil spaceId: { aSpaceId }.

	pages addAll: tmp results.
	[ tmp results size = itemByPage and: [ tmp _links next isNotNil ] ]
		whileTrue: [
			tmp := self
				       getPagesFromCursor:
				       ((tmp _links base , tmp _links next) asZnUrl queryAt:
					        #cursor)
				       spaceId: { aSpaceId }.
			pages addAll: tmp results ].
	^ pages
]

{ #category : #'api - attachement' }
ConfluencePharoAPI >> getAttachement: attachementURl [

	self prepareZnClient.
	znClient accept: ZnMimeType imagePng.
	znClient contentReader: [ :entity | entity bytes ].
	^ znClient get: attachementURl
]

{ #category : #'api - blog post' }
ConfluencePharoAPI >> getBlogPost: id bodyFormat: theBodyFormat [

	self prepareZnClient.
	znClient path: self basePath , '/blogposts/' , id printString.
	theBodyFormat ifNotNil: [ :bodyFormat |
		znClient queryAt: #'body-format' put: theBodyFormat ].
	self rawData ifFalse: [
		znClient contentReader: [ :entity |
			generalReader
				on: entity contents readStream;
				nextAs: ConfluencePharoBlogPost ] ].
	^ znClient get
]

{ #category : #'api - blog post' }
ConfluencePharoAPI >> getBlogPostAttachments: id [

	self prepareZnClient.
	znClient path:
		self basePath , '/blogposts/' , id printString , '/attachments'.

	self rawData ifFalse: [
		znClient contentReader: [ :entity |
			generalReader
				on: entity contents readStream;
				nextAs: ConfluencePharoBlogPostAttachementsResult ] ].
	^ znClient get
]

{ #category : #'api - page' }
ConfluencePharoAPI >> getPage: id [

	^ self getPage: id bodyFormat: #view
]

{ #category : #'api - page' }
ConfluencePharoAPI >> getPage: id bodyFormat: theBodyFormat [

	self prepareZnClient.
	znClient path: self basePath , '/pages/' , id printString.
	znClient queryAt: #'include-labels' put: true.
	theBodyFormat ifNotNil: [ :bodyFormat |
		znClient queryAt: #'body-format' put: theBodyFormat ].
	self rawData ifFalse: [
		znClient contentReader: [ :entity |
			generalReader
				on: entity contents readStream;
				nextAs: ConfluencePharoPage ] ].
	^ znClient get
]

{ #category : #'api - pages' }
ConfluencePharoAPI >> getPagesFromCursor: aCursorString spaceId: anArrayOfSpaceId [

	^ self
		  getPagesWithBodyFormat: nil
		  cursor: aCursorString
		  spaceId: anArrayOfSpaceId
]

{ #category : #'api - pages' }
ConfluencePharoAPI >> getPagesWithBodyFormat: theBodyFormat cursor: aCursorString spaceId: anArrayOfSpaceId [

	self prepareZnClient.
	znClient path: self basePath , '/pages'.

	theBodyFormat ifNotNil: [ :bodyFormat |
		znClient queryAt: #'body-format' put: bodyFormat ].
	aCursorString ifNotNil: [ :cursor |
		znClient queryAt: #cursor put: cursor ].
	anArrayOfSpaceId ifNotNil: [ :array |
		znClient queryAt: #'space-id' put: ($, join: array) ].


	self rawData ifFalse: [
		znClient contentReader: [ :entity |
			generalReader
				on: entity contents readStream;
				nextAs: ConfluencePharoArrayOfPageResult ] ].
	^ znClient get
]

{ #category : #'api - user' }
ConfluencePharoAPI >> getUsers: anArrayOfUserID [

	self prepareZnClient.
	znClient path: self basePath , '/users-bulk'.

	self rawData ifFalse: [
		znClient contentReader: [ :entity |
			generalReader
				on: entity contents readStream;
				nextAs: ConfluencePharoUserResearchResult ] ].


	znClient contents: { ('accountIds' -> anArrayOfUserID) } asDictionary.
	^ znClient post
]

{ #category : #initialization }
ConfluencePharoAPI >> initReader [

	generalReader for: ConfluencePharoPage do: [ :mapping |
		mapping mapAllInstVars.
		(mapping mapInstVar: #space) valueSchema: ConfluencePharoSpace.
		(mapping mapInstVar: #body) valueSchema: ConfluencePharoPageBody.
		mapping
			mapProperty: #labels
			getter: [ :el | "Not used" ]
			setter: [ :page :value |
				page labels: ((value at: #results) collect: [ :item |
						 ConfluencePharoLabel fromDictionary: item ]) ] ].

	generalReader for: ConfluencePharoBlogPost do: [ :mapping |
		mapping mapAllInstVars.
		(mapping mapInstVar: #space) valueSchema: ConfluencePharoSpace.
		(mapping mapInstVar: #body) valueSchema: ConfluencePharoPageBody ].

	generalReader
		for: ConfluencePharoBlogPostAttachement
		do: [ :mapping | mapping mapAllInstVars ].

	generalReader
		for: ConfluencePharoUser
		do: [ :mapping | mapping mapAllInstVars ].
	generalReader
		for: ConfluencePharoLinks
		do: [ :mapping | mapping mapAllInstVars ].

	generalReader
		for: ConfluencePharoSpace
		do: [ :mapping | mapping mapAllInstVars ].

	generalReader for: ConfluencePharoPageBody do: [ :mapping |
		mapping mapAllInstVars.
		(mapping mapInstVar: #view) valueSchema: ConfluencePharoPageBodyView ].

	generalReader
		for: ConfluencePharoUserResearchResult
		do: [ :mapping |
			(mapping mapInstVar: #results) valueSchema:
				#ArrayOfConfluencePharoUser ].

	generalReader
		for: ConfluencePharoBlogPostAttachementsResult
		do: [ :mapping |
			(mapping mapInstVar: #results) valueSchema:
				#ArrayOfConfluencePharoBlogPostAttachement ].


	generalReader
		for: ConfluencePharoPageBodyView
		do: [ :mapping | mapping mapAllInstVars ].

	generalReader
		for: #ArrayOfConfluencePharoUser
		customDo: [ :mapping |
		mapping listOfElementSchema: ConfluencePharoUser ].

	generalReader
		for: #ArrayOfConfluencePharoBlogPostAttachement
		customDo: [ :mapping |
			mapping listOfElementSchema: ConfluencePharoBlogPostAttachement ].


	generalReader for: ConfluencePharoArrayOfPageResult do: [ :mapping |
		(mapping mapInstVar: #results) valueSchema:
			#ArrayOfConfluencePharoPage.
		(mapping mapInstVar: #_links) valueSchema: ConfluencePharoLinks ].

	generalReader
		for: #ArrayOfConfluencePharoPage
		customDo: [ :mapping |
		mapping listOfElementSchema: ConfluencePharoPage ]
]

{ #category : #initialization }
ConfluencePharoAPI >> initWriter [

	writer := NeoJSONWriter new.
	writer
		for: ConfluencePharoPageBodyWrite
		do: [ :mapping | mapping mapAllInstVars ].
]

{ #category : #initialization }
ConfluencePharoAPI >> initialize [

	super initialize.
	endpoint := 'jira.atlassian.com'.
	self basePath: 'wiki/rest/api/latest/'.
	https := true.
	generalReader := NeoJSONReader new.
	self initReader.
	self initWriter.
	self rawData: false
]

{ #category : #accessing }
ConfluencePharoAPI >> isHttps [

	^ https
]

{ #category : #accessing }
ConfluencePharoAPI >> port [

	^ port
]

{ #category : #accessing }
ConfluencePharoAPI >> port: anObject [

	port := anObject
]

{ #category : #'private - building' }
ConfluencePharoAPI >> prepareZnClient [

	znClient := ZnClient new.
	znClient host: self endpoint.
	znClient forJsonREST.
	self port ifNotNil: [ :specifiedPort | znClient port: specifiedPort ].
	self isHttps
		ifTrue: [ znClient https ]
		ifFalse: [ znClient http ].
	"bearer or api + user"
	self bearerToken ifNotNil: [ :anApiKey |
		znClient headerAt: #Authorization put: 'Bearer ' , anApiKey ].
	self apiToken ifNotNil: [ :anApiKey |
		znClient
			headerAt: #Authorization
			put:
			'Basic '
			, (self user , ':' , self apiToken) utf8Encoded base64Encoded ]
]

{ #category : #accessing }
ConfluencePharoAPI >> rawData [

	^ rawData
]

{ #category : #accessing }
ConfluencePharoAPI >> rawData: anObject [

	rawData := anObject
]

{ #category : #accessing }
ConfluencePharoAPI >> user [

	^ user
]

{ #category : #accessing }
ConfluencePharoAPI >> user: anObject [

	user := anObject
]

{ #category : #accessing }
ConfluencePharoAPI >> znClient [

	^ znClient
]

{ #category : #accessing }
ConfluencePharoAPI >> znClient: anObject [

	znClient := anObject
]
