"
I'm an inspector for questions asked by developers when debugging.
"
Class {
	#name : 'D3QuestionInspectorPresenter',
	#superclass : 'StInspectorPresenter',
	#instVars : [
		'table'
	],
	#category : 'D3Dbg-1-Analysis-Presenters',
	#package : 'D3Dbg-1-Analysis',
	#tag : 'Presenters'
}

{ #category : 'instance creation' }
D3QuestionInspectorPresenter class >> onObject: anObject [

	^ self on: (D3InspectorModel on: anObject)
]

{ #category : 'inspector compatibility' }
D3QuestionInspectorPresenter >> setModelBeforeInitialization: anInspectorModel [

	model := anInspectorModel
]
