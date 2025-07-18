"
I model a D3 participation, my instvar whose name starts by ""o"" and ""m"" represent respectively data from the original and the modified experimental images.
"
Class {
	#name : 'D3Participation',
	#superclass : 'Object',
	#instVars : [
		'participationId',
		'oEventHistory',
		'mEventHistory',
		'oDSA',
		'mDSA',
		'taskName',
		'questions'
	],
	#category : 'D3Dbg-1-Analysis',
	#package : 'D3Dbg-1-Analysis'
}

{ #category : 'accessing' }
D3Participation >> dateStarted [
	^oEventHistory dateTime min: mEventHistory dateTime
]

{ #category : 'accessing' }
D3Participation >> duration [
	^(oEventHistory absoluteTimeTaken max: mEventHistory absoluteTimeTaken) minutes
]

{ #category : 'accessing' }
D3Participation >> durationHumanReadable [

	^ String streamContents: [ :s |
		  self duration printHumanReadableOn: s ]
]

{ #category : 'initialization' }
D3Participation >> initializeWithData: aD3DataDictionary [

	oDSA := DSA new fromEvents:
		        (OCDbgExampleCode loadDataFromPath:
			         (aD3DataDictionary at: 'original')).
	oEventHistory := oDSA history.
	mDSA := DSA new fromEvents:
		        (OCDbgExampleCode loadDataFromPath:
			         (aD3DataDictionary at: 'modified')).
	mEventHistory := mDSA history
]

{ #category : 'as yet unclassified' }
D3Participation >> listOfSwitch [

	| switch sortedA sortedB |
	sortedA := oEventHistory records sort: [ :x :y |
		           x dateTime <= y dateTime ].
	sortedB := mEventHistory records sort: [ :x :y |
		           x dateTime <= y dateTime ].

	switch := LinkedList new.

	1 to: sortedA size - 1 do: [ :i |
		| d1 d2 bridge |
		d1 := (sortedA at: i) dateTime.
		d2 := (sortedA at: i + 1) dateTime.

		bridge := sortedB select: [ :e |
			          e dateTime > d1 and: [ e dateTime < d2 ] ].
		bridge isEmpty ifFalse: [ switch add: bridge ].
		sortedB := sortedB reject: [ :e | bridge includes: e ] ].

	^ switch
]

{ #category : 'accessing' }
D3Participation >> mDSA [

	^ mDSA
]

{ #category : 'accessing' }
D3Participation >> mDSA: anObject [

	mDSA := anObject
]

{ #category : 'accessing' }
D3Participation >> mEventHistory [

	^ mEventHistory
]

{ #category : 'accessing' }
D3Participation >> mEventHistory: anObject [

	mEventHistory := anObject
]

{ #category : 'accessing' }
D3Participation >> oDSA [

	^ oDSA
]

{ #category : 'accessing' }
D3Participation >> oDSA: anObject [

	oDSA := anObject
]

{ #category : 'accessing' }
D3Participation >> oEventHistory [

	^ oEventHistory
]

{ #category : 'accessing' }
D3Participation >> oEventHistory: anObject [

	oEventHistory := anObject
]

{ #category : 'accessing' }
D3Participation >> participationId [

	^ participationId
]

{ #category : 'accessing' }
D3Participation >> participationId: anObject [

	participationId := anObject
]

{ #category : 'printing' }
D3Participation >> printOn: aStream [

	participationId < 10 ifTrue: [ aStream << '0' ].
	participationId printOn: aStream.
	aStream << ' << '.
	aStream << taskName
]

{ #category : 'services' }
D3Participation >> question [ 

	^ questions
]

{ #category : 'services' }
D3Participation >> question: aDictionnary [ 

	questions := aDictionnary
]

{ #category : 'accessing' }
D3Participation >> taskName [
	^ taskName
]

{ #category : 'accessing' }
D3Participation >> taskName: aString [ 
	taskName := aString
]
