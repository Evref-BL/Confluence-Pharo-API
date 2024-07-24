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
		'generalReader'
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

{ #category : #'api - page' }
ConfluencePharoAPI >> getPage: id [

	^ self getPage: id bodyFormat: #view
]

{ #category : #'api - page' }
ConfluencePharoAPI >> getPage: id bodyFormat: theBodyFormat [

	self prepareZnClient.
	znClient path: self basePath , '/pages/' , id printString.
	theBodyFormat ifNotNil: [ :bodyFormat |
		znClient queryAt: #'body-format' put: theBodyFormat ].
	self rawData ifFalse: [
		znClient contentReader: [ :entity |
			generalReader
				on: entity contents readStream;
				nextAs: ConfluencePharoPage ] ].
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
		(mapping mapInstVar: #body) valueSchema: ConfluencePharoPageBody ].

	generalReader for: ConfluencePharoBlogPost do: [ :mapping |
		mapping mapAllInstVars.
		(mapping mapInstVar: #space) valueSchema: ConfluencePharoSpace.
		(mapping mapInstVar: #body) valueSchema: ConfluencePharoPageBody ].

	generalReader
		for: ConfluencePharoUser
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
		for: ConfluencePharoPageBodyView
		do: [ :mapping | mapping mapAllInstVars ].

	generalReader
		for: #ArrayOfConfluencePharoUser
		customDo: [ :mapping |
		mapping listOfElementSchema: ConfluencePharoUser ]
]

{ #category : #initialization }
ConfluencePharoAPI >> initialize [

	super initialize.
	endpoint := 'jira.atlassian.com'.
	self basePath: 'wiki/rest/api/latest/'.
	https := true.
	generalReader := NeoJSONReader new.
	self initReader.
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
