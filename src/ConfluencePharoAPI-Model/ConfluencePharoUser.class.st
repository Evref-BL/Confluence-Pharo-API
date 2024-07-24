Class {
	#name : #ConfluencePharoUser,
	#superclass : #Object,
	#instVars : [
		'displayName',
		'timeZone',
		'accountId',
		'email',
		'publicName'
	],
	#category : #'ConfluencePharoAPI-Model'
}

{ #category : #accessing }
ConfluencePharoUser >> accountId [

	^ accountId
]

{ #category : #accessing }
ConfluencePharoUser >> accountId: anObject [

	accountId := anObject
]

{ #category : #accessing }
ConfluencePharoUser >> displayName [

	^ displayName
]

{ #category : #accessing }
ConfluencePharoUser >> displayName: anObject [

	displayName := anObject
]

{ #category : #accessing }
ConfluencePharoUser >> email [

	^ email
]

{ #category : #accessing }
ConfluencePharoUser >> email: anObject [

	email := anObject
]

{ #category : #accessing }
ConfluencePharoUser >> publicName [

	^ publicName
]

{ #category : #accessing }
ConfluencePharoUser >> publicName: anObject [

	publicName := anObject
]

{ #category : #accessing }
ConfluencePharoUser >> timeZone [

	^ timeZone
]

{ #category : #accessing }
ConfluencePharoUser >> timeZone: anObject [

	timeZone := anObject
]
