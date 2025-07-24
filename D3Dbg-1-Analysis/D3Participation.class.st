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
		'questions',
		'fixedTimes'
	],
	#category : 'D3Dbg-1-Analysis-Model',
	#package : 'D3Dbg-1-Analysis',
	#tag : 'Model'
}

{ #category : 'accessing' }
D3Participation class >> dataPath [
	^D3ExperimentResults dataPath 
]

{ #category : 'accessing' }
D3Participation >> collectTimeDiscrepancies [

	| o m all overlaps i current |
	o := oEventHistory collectTimeDiscrepancies collect: [ :association |
		     (self collectTimeErrorFor: association)
			     tag: #origin;
			     yourself ].
	m := mEventHistory collectTimeDiscrepancies collect: [ :association |
		     (self collectTimeErrorFor: association)
			     tag: #modified;
			     yourself ].

	all := SortedCollection new.
	all sortBlock: [ :x :y | x start <= y start ].
	all addAll: o.
	all addAll: m.


	overlaps := OrderedCollection new.
	current := all first.
	i := 2.

	[ i <= all size ] whileTrue: [
		| next |
		next := all at: i.
		current tag = next tag ifFalse: [
			(current start <= next stop and: [ next start <= current stop ])
				ifTrue: [
					overlaps add: {
							current.
							next } ] ].
		current := next.
		i := i + 1 ].
	^ overlaps collect: [ :array | D3TimeOutsidePharo on: array ]
]

{ #category : 'accessing' }
D3Participation >> collectTimeErrorFor: anAssociation [

	^ TaskTimeControl new
		  buildTimeErrorFrom: anAssociation key second dateTime
		  to: anAssociation key first dateTime
		  delta: anAssociation value
		  data: anAssociation key
]

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

{ #category : 'analysis' }
D3Participation >> fixedTimes [

	^ fixedTimes ifNil: [
		  | fileRef |
		  fileRef := self fixedTimesFilename.
		  fileRef exists
			  ifTrue: [ STON fromString: fileRef contents ]
			  ifFalse: [ self collectTimeDiscrepancies ] ]
]

{ #category : 'accessing' }
D3Participation >> fixedTimesFilename [

	^self class dataPath / participationId asString
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

{ #category : 'analysis' }
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

{ #category : 'analysis' }
D3Participation >> unresolvedTimeGaps [

	^ self fixedTimes select: [ :ft | ft activityType isNil ]
]
