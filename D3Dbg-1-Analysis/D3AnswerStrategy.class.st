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
		'questionTag',
		'participationId'
	],
	#category : 'D3Dbg-1-Analysis-Model',
	#package : 'D3Dbg-1-Analysis',
	#tag : 'Model'
}

{ #category : 'accessing' }
D3AnswerStrategy >> comment [

	^ comment ifNil: [ comment := '' ]
]

{ #category : 'accessing' }
D3AnswerStrategy >> comment: anObject [

	comment := anObject
]

{ #category : 'accessing' }
D3AnswerStrategy >> isEcho [

	^ isEcho ifNil:[isEcho := false]
]

{ #category : 'accessing' }
D3AnswerStrategy >> isEcho: anObject [

	isEcho := anObject
]

{ #category : 'accessing' }
D3AnswerStrategy >> isToolUsed: item for: originOrModified [

	^ (self usedTools
		   at: originOrModified
		   ifAbsentPut: [ Dictionary new ]) at: item ifAbsentPut: [ false ]
]

{ #category : 'accessing' }
D3AnswerStrategy >> participationId [

	^ participationId
]

{ #category : 'accessing' }
D3AnswerStrategy >> participationId: anObject [

	participationId := anObject
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
D3AnswerStrategy >> toolNotUsed: item for: originOrModified [

	^ (self usedTools
		   at: originOrModified
		   ifAbsentPut: [ Dictionary new ]) at: item put: false
]

{ #category : 'accessing' }
D3AnswerStrategy >> toolUsed: item for: originOrModified [

	^ (self usedTools
		   at: originOrModified
		   ifAbsentPut: [ Dictionary new ]) at: item put: true
]

{ #category : 'accessing' }
D3AnswerStrategy >> usedTools [

	^ usedTools ifNil: [ usedTools := Dictionary new ]
]

{ #category : 'accessing' }
D3AnswerStrategy >> usedTools: anObject [

	usedTools := anObject
]
