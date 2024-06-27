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

{ #category : #'api - content' }
ConfluencePharoAPI >> getContent: id [

	^ self getContent: id withExpand: { #'body.view' . #space }
]

{ #category : #'api - content' }
ConfluencePharoAPI >> getContent: id withExpand: aCollectionOfExpand [

	self prepareZnClient.
	znClient path: self basePath , '/content/' , id printString.
	aCollectionOfExpand ifNotEmpty: [ :expand |
		znClient queryAt: #expand put: (String streamContents: [ :str |
				 expand do: [ :each | str << each ] separatedBy: [ str << ',' ] ]) ].
	self rawData ifFalse: [
		znClient contentReader: [ :entity |
			generalReader
				on: entity contents readStream;
				nextAs: ConfluencePharoPage ] ].
	^ znClient get
]

{ #category : #initialization }
ConfluencePharoAPI >> initReader [

	generalReader for: ConfluencePharoPage do: [ :mapping |
		mapping mapAllInstVars.
		(mapping mapInstVar: #space) valueSchema: ConfluencePharoSpace.
		(mapping mapInstVar: #body) valueSchema: ConfluencePharoPageBody ].

	generalReader
		for: ConfluencePharoSpace
		do: [ :mapping | mapping mapAllInstVars ].

	generalReader for: ConfluencePharoPageBody do: [ :mapping |
		mapping mapAllInstVars.
		(mapping mapInstVar: #view) valueSchema: ConfluencePharoPageBodyView ].

	generalReader
		for: ConfluencePharoPageBodyView
		do: [ :mapping | mapping mapAllInstVars ]
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