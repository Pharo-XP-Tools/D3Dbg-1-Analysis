"
I represent a question asked during an experiment.
"
Class {
	#name : 'D3DebuggingQuestion',
	#superclass : 'Object',
	#instVars : [
		'segments',
		'file',
		'tag',
		'end',
		'debut_id',
		'start',
		'text'
	],
	#category : 'D3Dbg-1-Analysis-Model',
	#package : 'D3Dbg-1-Analysis',
	#tag : 'Model'
}

{ #category : 'instance creation' }
D3DebuggingQuestion class >> fromDictionary: aDictionary [

	| question |
	question := self new.
	(self slots collect: #name) do: [ :slotName |
		| accessor |
		accessor := slotName , ':'.
		question perform: accessor with: (aDictionary at: slotName) ].
	^ question
]

{ #category : 'accessing' }
D3DebuggingQuestion >> debut_id [

	^ debut_id
]

{ #category : 'accessing' }
D3DebuggingQuestion >> debut_id: anObject [

	debut_id := anObject
]

{ #category : 'accessing' }
D3DebuggingQuestion >> end [

	^ end
]

{ #category : 'accessing' }
D3DebuggingQuestion >> end: anObject [

	end := anObject
]

{ #category : 'accessing' }
D3DebuggingQuestion >> file [

	^ file
]

{ #category : 'accessing' }
D3DebuggingQuestion >> file: anObject [

	file := anObject
]

{ #category : 'accessing' }
D3DebuggingQuestion >> segments [

	^ segments
]

{ #category : 'accessing' }
D3DebuggingQuestion >> segments: anObject [

	segments := anObject
]

{ #category : 'accessing' }
D3DebuggingQuestion >> start [

	^ start
]

{ #category : 'accessing' }
D3DebuggingQuestion >> start: anObject [

	start := anObject
]

{ #category : 'accessing' }
D3DebuggingQuestion >> tag [

	^ tag
]

{ #category : 'accessing' }
D3DebuggingQuestion >> tag: anObject [

	tag := anObject
]

{ #category : 'accessing' }
D3DebuggingQuestion >> text [

	^ text
]

{ #category : 'accessing' }
D3DebuggingQuestion >> text: anObject [

	text := anObject
]
