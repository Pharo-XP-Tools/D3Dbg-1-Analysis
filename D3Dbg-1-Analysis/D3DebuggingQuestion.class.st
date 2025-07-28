Class {
	#name : 'D3DebuggingQuestion',
	#superclass : 'Object',
	#instVars : [
		'tag',
		'question',
		'occurrences'
	],
	#category : 'D3Dbg-1-Analysis-Model',
	#package : 'D3Dbg-1-Analysis',
	#tag : 'Model'
}

{ #category : 'instance creation' }
D3DebuggingQuestion class >> from: anAssociation [

	| question |
	question := self new.
	question tag: anAssociation key.
	question question: anAssociation value.
	^ question
]

{ #category : 'accessing' }
D3DebuggingQuestion >> occurrences [

	^ occurrences
]

{ #category : 'accessing' }
D3DebuggingQuestion >> occurrences: anObject [

	occurrences := anObject
]

{ #category : 'printing' }
D3DebuggingQuestion >> printOn: aStream [
	aStream << question.
	aStream << ' ('.
	aStream << occurrences size printString.
	aStream << ' occurrences)'
]

{ #category : 'accessing' }
D3DebuggingQuestion >> question [

	^ question
]

{ #category : 'accessing' }
D3DebuggingQuestion >> question: anObject [

	question := anObject
]

{ #category : 'accessing' }
D3DebuggingQuestion >> tag [

	^ tag
]

{ #category : 'accessing' }
D3DebuggingQuestion >> tag: anObject [

	tag := anObject
]
