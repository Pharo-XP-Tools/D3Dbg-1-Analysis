Class {
	#name : 'D3VisualizationInspectorPresenter',
	#superclass : 'StInspectorPresenter',
	#category : 'D3Dbg-1-Analysis-Presenters',
	#package : 'D3Dbg-1-Analysis',
	#tag : 'Presenters'
}

{ #category : 'instance creation' }
D3VisualizationInspectorPresenter class >> onObject: anObject [

	^ self on: (D3InspectorModel on: anObject)
]

{ #category : 'inspector compatibility' }
D3VisualizationInspectorPresenter >> setModelBeforeInitialization: anInspectorModel [

	model := anInspectorModel
]
