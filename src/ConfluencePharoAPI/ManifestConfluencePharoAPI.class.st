"
Please describe the package using the class comment of the included manifest class. The manifest class also includes other additional metadata for the package. These meta data are used by other tools such as the SmalllintManifestChecker and the critics Browser
"
Class {
	#name : #ManifestConfluencePharoAPI,
	#superclass : #PackageManifest,
	#category : #'ConfluencePharoAPI-Manifest'
}

{ #category : #'code-critics' }
ManifestConfluencePharoAPI class >> ruleBadMessageRule2V1FalsePositive [

	<ignoreForCoverage>
	^ #(#(#(#RGMethodDefinition #(#ConfluencePharoAPI #downloadPage:asPDFIn: #false)) #'2024-10-04T14:02:39.959+02:00') )
]
