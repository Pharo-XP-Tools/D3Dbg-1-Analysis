"
I'm a custom inspector model that override slightly the default Pharo one by using a custom object inspector class `D3ObjectInspectorPresenter`.
"
Class {
	#name : 'D3InspectorModel',
	#superclass : 'StInspectorModel',
	#category : 'D3Dbg-1-Analysis-Model',
	#package : 'D3Dbg-1-Analysis',
	#tag : 'Model'
}

{ #category : 'inspector compatibility' }
D3InspectorModel >> defaultObjectInspectorClass [

	^ D3ObjectInspectorPresenter
]
