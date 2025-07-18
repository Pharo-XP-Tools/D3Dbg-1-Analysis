Class {
	#name : 'D3ObjectInspectorPresenter',
	#superclass : 'StObjectInspectorPresenter',
	#category : 'D3Dbg-1-Analysis-Presenters',
	#package : 'D3Dbg-1-Analysis',
	#tag : 'Presenters'
}

{ #category : 'private - factory' }
D3ObjectInspectorPresenter >> newInspectionForContext: aContext [

	aContext withoutEvaluator.
	^ super newInspectionForContext: aContext
]
