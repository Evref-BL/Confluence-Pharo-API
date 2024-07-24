Class {
	#name : #ConfluencePharoBlogPost,
	#superclass : #Object,
	#instVars : [
		'id',
		'type',
		'title',
		'body',
		'space',
		'authorId'
	],
	#category : #'ConfluencePharoAPI-Model'
}

{ #category : #accessing }
ConfluencePharoBlogPost >> authorId [

	^ authorId
]

{ #category : #accessing }
ConfluencePharoBlogPost >> authorId: anObject [

	authorId := anObject
]

{ #category : #accessing }
ConfluencePharoBlogPost >> body [

	^ body
]

{ #category : #accessing }
ConfluencePharoBlogPost >> body: anObject [

	body := anObject
]

{ #category : #accessing }
ConfluencePharoBlogPost >> id [

	^ id
]

{ #category : #accessing }
ConfluencePharoBlogPost >> id: anObject [

	id := anObject
]

{ #category : #accessing }
ConfluencePharoBlogPost >> space [

	^ space
]

{ #category : #accessing }
ConfluencePharoBlogPost >> space: anObject [

	space := anObject
]

{ #category : #accessing }
ConfluencePharoBlogPost >> title [

	^ title
]

{ #category : #accessing }
ConfluencePharoBlogPost >> title: anObject [

	title := anObject
]

{ #category : #accessing }
ConfluencePharoBlogPost >> type [

	^ type
]

{ #category : #accessing }
ConfluencePharoBlogPost >> type: anObject [

	type := anObject
]
