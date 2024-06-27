Class {
	#name : #BaselineOfConfluencePharoAPI,
	#superclass : #BaselineOf,
	#category : #BaselineOfConfluencePharoAPI
}

{ #category : #baselines }
BaselineOfConfluencePharoAPI >> baseline: spec [

	<baseline>
	spec for: #common do: [
		self defineDependencies: spec.
		self definePackages: spec.
		self defineGroups: spec ]
]

{ #category : #baselines }
BaselineOfConfluencePharoAPI >> defineDependencies: spec [

	spec
		baseline: 'NeoJSON'
		with: [ spec repository: 'github://svenvc/NeoJSON/repository' ]
]

{ #category : #baselines }
BaselineOfConfluencePharoAPI >> defineGroups: spec [
]

{ #category : #baselines }
BaselineOfConfluencePharoAPI >> definePackages: spec [

	spec package: 'ConfluencePharoAPI' with: [
		spec requires: #( 'ConfluencePharoAPI-Model'
		   'NeoJSON' ) ].
	spec package: 'ConfluencePharoAPI-Model'
]
