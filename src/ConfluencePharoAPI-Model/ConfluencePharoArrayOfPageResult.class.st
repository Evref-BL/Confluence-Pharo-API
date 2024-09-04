Class {
	#name : #ConfluencePharoArrayOfPageResult,
	#superclass : #Object,
	#instVars : [
		'results',
		'_links'
	],
	#category : #'ConfluencePharoAPI-Model'
}

{ #category : #accessing }
ConfluencePharoArrayOfPageResult >> _links [

	^ _links
]

{ #category : #accessing }
ConfluencePharoArrayOfPageResult >> _links: anObject [

	_links := anObject
]

{ #category : #accessing }
ConfluencePharoArrayOfPageResult >> results [

	^ results
]

{ #category : #accessing }
ConfluencePharoArrayOfPageResult >> results: anObject [

	results := anObject
]
