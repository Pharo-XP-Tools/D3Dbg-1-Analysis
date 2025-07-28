"
I hold an analysis of how a debugging question was answered.
"
Class {
	#name : 'D3AnswerStrategy',
	#superclass : 'Object',
	#instVars : [
		'usedTools',
		'comment',
		'isEcho',
		'questionTag'
	],
	#category : 'D3Dbg-1-Analysis-Model',
	#package : 'D3Dbg-1-Analysis',
	#tag : 'Model'
}

{ #category : 'accessing' }
D3AnswerStrategy >> comment [

	^ comment
]

{ #category : 'accessing' }
D3AnswerStrategy >> comment: anObject [

	comment := anObject
]

{ #category : 'accessing' }
D3AnswerStrategy >> isEcho [

	^ isEcho
]

{ #category : 'accessing' }
D3AnswerStrategy >> isEcho: anObject [

	isEcho := anObject
]

{ #category : 'accessing' }
D3AnswerStrategy >> questionTag [

	^ questionTag
]

{ #category : 'accessing' }
D3AnswerStrategy >> questionTag: anObject [

	questionTag := anObject
]

{ #category : 'accessing' }
D3AnswerStrategy >> usedTools [

	^ usedTools
]

{ #category : 'accessing' }
D3AnswerStrategy >> usedTools: anObject [

	usedTools := anObject
]
