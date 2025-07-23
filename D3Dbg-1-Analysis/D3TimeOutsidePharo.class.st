"
I represent activities performed outside Pharo in the Echo-1/D3 debugging experiment.
"
Class {
	#name : 'D3TimeOutsidePharo',
	#superclass : 'Object',
	#instVars : [
		'startEvent',
		'stopEvent'
	],
	#category : 'D3Dbg-1-Analysis-Model',
	#package : 'D3Dbg-1-Analysis',
	#tag : 'Model'
}

{ #category : 'instance creation' }
D3TimeOutsidePharo class >> on: anArray [

	^ self new
		  startEvent: anArray first;
		  stopEvent: anArray second;
		  yourself
]

{ #category : 'printing' }
D3TimeOutsidePharo >> printOn: aStream [

	startEvent stop - stopEvent start printHumanReadableOn: aStream
]

{ #category : 'accessing' }
D3TimeOutsidePharo >> startEvent [

	^ startEvent
]

{ #category : 'accessing' }
D3TimeOutsidePharo >> startEvent: anObject [

	startEvent := anObject
]

{ #category : 'accessing' }
D3TimeOutsidePharo >> stopEvent [

	^ stopEvent
]

{ #category : 'accessing' }
D3TimeOutsidePharo >> stopEvent: anObject [

	stopEvent := anObject
]
