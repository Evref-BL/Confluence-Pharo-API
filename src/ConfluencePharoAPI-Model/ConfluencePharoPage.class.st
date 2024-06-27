Class {
	#name : #ConfluencePharoPage,
	#superclass : #Object,
	#instVars : [
		'id',
		'type',
		'title',
		'body',
		'space'
	],
	#category : #'ConfluencePharoAPI-Model'
}

{ #category : #accessing }
ConfluencePharoPage >> body [

	^ body
]

{ #category : #accessing }
ConfluencePharoPage >> body: anObject [

	body := anObject
]

{ #category : #accessing }
ConfluencePharoPage >> id [

	^ id
]

{ #category : #accessing }
ConfluencePharoPage >> id: anObject [

	id := anObject
]

{ #category : #accessing }
ConfluencePharoPage >> space [

	^ space
]

{ #category : #accessing }
ConfluencePharoPage >> space: anObject [

	space := anObject
]

{ #category : #accessing }
ConfluencePharoPage >> title [

	^ title
]

{ #category : #accessing }
ConfluencePharoPage >> title: anObject [

	title := anObject
]

{ #category : #accessing }
ConfluencePharoPage >> type [

	^ type
]

{ #category : #accessing }
ConfluencePharoPage >> type: anObject [

	type := anObject
]
