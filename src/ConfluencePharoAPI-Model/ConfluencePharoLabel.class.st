Class {
	#name : #ConfluencePharoLabel,
	#superclass : #Object,
	#instVars : [
		'prefix',
		'name',
		'id'
	],
	#category : #'ConfluencePharoAPI-Model'
}

{ #category : #'instance creation' }
ConfluencePharoLabel class >> fromDictionary: aConfluencePharoLabelInDictionary [

	| aConfluencePharoLabel |
	aConfluencePharoLabel := self new.
	aConfluencePharoLabelInDictionary keysAndValuesDo: [ :key :value |
		| setter |
		setter := (key asSymbol , ':') asSymbol.
		(aConfluencePharoLabel respondsTo: setter) ifTrue: [
			aConfluencePharoLabel perform: setter with: value ] ].
	^ aConfluencePharoLabel
]

{ #category : #accessing }
ConfluencePharoLabel >> id [

	^ id
]

{ #category : #accessing }
ConfluencePharoLabel >> id: anObject [

	id := anObject
]

{ #category : #accessing }
ConfluencePharoLabel >> name [

	^ name
]

{ #category : #accessing }
ConfluencePharoLabel >> name: anObject [

	name := anObject
]

{ #category : #accessing }
ConfluencePharoLabel >> prefix [

	^ prefix
]

{ #category : #accessing }
ConfluencePharoLabel >> prefix: anObject [

	prefix := anObject
]
