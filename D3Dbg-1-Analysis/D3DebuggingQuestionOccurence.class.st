"
I represent an occurence of a D3DebuggingQuestion.
"
Class {
	#name : 'D3DebuggingQuestionOccurence',
	#superclass : 'Object',
	#instVars : [
		'segments',
		'file',
		'tag',
		'end',
		'debut_id',
		'start',
		'text',
		'participantionId'
	],
	#category : 'D3Dbg-1-Analysis-Model',
	#package : 'D3Dbg-1-Analysis',
	#tag : 'Model'
}

{ #category : 'instance creation' }
D3DebuggingQuestionOccurence class >> fromDictionary: aDictionary [

	| question |
	question := self new.
	(self slots collect: #name) do: [ :slotName |
		| accessor |
		accessor := slotName , ':'.
		slotName = #participationId ifFalse: [
			question
				perform: accessor
				with: (aDictionary at: slotName ifAbsent: [  ]) ] ].
	^ question
]

{ #category : 'accessing' }
D3DebuggingQuestionOccurence >> debut_id [

	^ debut_id
]

{ #category : 'accessing' }
D3DebuggingQuestionOccurence >> debut_id: anObject [

	debut_id := anObject
]

{ #category : 'accessing' }
D3DebuggingQuestionOccurence >> end [

	^ end
]

{ #category : 'accessing' }
D3DebuggingQuestionOccurence >> end: anObject [

	end := anObject
]

{ #category : 'accessing' }
D3DebuggingQuestionOccurence >> file [

	^ file
]

{ #category : 'accessing' }
D3DebuggingQuestionOccurence >> file: anObject [

	file := anObject
]

{ #category : 'accessing' }
D3DebuggingQuestionOccurence >> participantionId [

	^ participantionId
]

{ #category : 'accessing' }
D3DebuggingQuestionOccurence >> participantionId: anObject [

	participantionId := anObject
]

{ #category : 'printing' }
D3DebuggingQuestionOccurence >> printOn: aStream [

	aStream << '['.
	(Time fromSeconds: start)
		print24: true
		showSeconds: false
		on: aStream.
	aStream << ']'.
	aStream space.
	aStream << text capitalized
]

{ #category : 'accessing' }
D3DebuggingQuestionOccurence >> segments [

	^ segments
]

{ #category : 'accessing' }
D3DebuggingQuestionOccurence >> segments: anObject [

	segments := anObject
]

{ #category : 'accessing' }
D3DebuggingQuestionOccurence >> start [

	^ start
]

{ #category : 'accessing' }
D3DebuggingQuestionOccurence >> start: anObject [

	start := anObject
]

{ #category : 'accessing' }
D3DebuggingQuestionOccurence >> tag [

	^ tag
]

{ #category : 'accessing' }
D3DebuggingQuestionOccurence >> tag: anObject [

	tag := anObject
]

{ #category : 'accessing' }
D3DebuggingQuestionOccurence >> text [

	^ text
]

{ #category : 'accessing' }
D3DebuggingQuestionOccurence >> text: anObject [

	text := anObject
]
