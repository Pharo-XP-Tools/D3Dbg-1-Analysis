Class {
	#name : 'D3InspectorModel',
	#superclass : 'StInspectorModel',
	#category : 'D3Dbg-1-Analysis-Presenters',
	#package : 'D3Dbg-1-Analysis',
	#tag : 'Presenters'
}

{ #category : 'inspector compatibility' }
D3InspectorModel >> defaultObjectInspectorClass [

	^ D3ObjectInspectorPresenter
]
