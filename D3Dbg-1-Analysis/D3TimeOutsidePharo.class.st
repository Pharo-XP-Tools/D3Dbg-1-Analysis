"
I represent activities performed outside Pharo in the Echo-1/D3 debugging experiment.
The activityType field specifies what activity I was actually doing during that time.
"
Class {
	#name : 'D3TimeOutsidePharo',
	#superclass : 'Object',
	#instVars : [
		'startEvent',
		'stopEvent',
		'activityType',
		'comment'
	],
	#category : 'D3Dbg-1-Analysis-Model',
	#package : 'D3Dbg-1-Analysis',
	#tag : 'Model'
}

{ #category : 'accessing' }
D3TimeOutsidePharo class >> externalActivities [
	^#('Github' 'Tasks browsing')
]

{ #category : 'instance creation' }
D3TimeOutsidePharo class >> on: anArray [

	^ self new
		  startEvent: anArray first;
		  stopEvent: anArray second;
		  yourself
]

{ #category : 'accessing' }
D3TimeOutsidePharo >> activityType [

	^ activityType
]

{ #category : 'accessing' }
D3TimeOutsidePharo >> activityType: anObject [

	activityType := anObject
]

{ #category : 'computation' }
D3TimeOutsidePharo >> interruptionDuration [

	^ self interruptionStart - self interruptionStop
]

{ #category : 'computation' }
D3TimeOutsidePharo >> interruptionStart [

	^ startEvent stop min: stopEvent stop
]

{ #category : 'computation' }
D3TimeOutsidePharo >> interruptionStop [

	^ stopEvent start
]

{ #category : 'printing' }
D3TimeOutsidePharo >> printOn: aStream [

	self interruptionDuration printHumanReadableOn: aStream
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
