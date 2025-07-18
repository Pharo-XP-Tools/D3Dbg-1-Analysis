Class {
	#name : 'D3ObjectInspectorPresenter',
	#superclass : 'StObjectInspectorPresenter',
	#category : 'D3Dbg-1-Analysis-Presenters',
	#package : 'D3Dbg-1-Analysis',
	#tag : 'Presenters'
}

{ #category : 'initialization' }
D3ObjectInspectorPresenter >> defaultLayout [

	^ SpBoxLayout newTopToBottom
		  add: views;
		  yourself
]

{ #category : 'private - factory' }
D3ObjectInspectorPresenter >> newInspectionForContext: aContext [

	aContext withoutEvaluator.
	^ super newInspectionForContext: aContext
]
