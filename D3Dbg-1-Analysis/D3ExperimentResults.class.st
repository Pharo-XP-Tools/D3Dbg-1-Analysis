"
I model a D3 experiment.
"
Class {
	#name : 'D3ExperimentResults',
	#superclass : 'Object',
	#instVars : [
		'participations',
		'questionOccurrences',
		'questions'
	],
	#category : 'D3Dbg-1-Analysis-Model',
	#package : 'D3Dbg-1-Analysis',
	#tag : 'Model'
}

{ #category : 'accessing' }
D3ExperimentResults class >> analysisDataPath [

	^ 'echo/data/Echo/answers' asFileReference
		  ensureCreateDirectory;
		  yourself
]

{ #category : 'raw data' }
D3ExperimentResults class >> dataConfiguration [

	| blueprintMPath blueprintOPath microdownMPath microdownOPath blueprintParticipations microdownParticipations |
	blueprintOPath := 'echo/data/Echo/classBluePrint-Original-experiment/' asFileReference.
	blueprintMPath := 'echo/data/Echo/classBluePrint-Modify-experiment/' asFileReference.
	microdownOPath := 'echo/data/Echo/Microdown-Origin-experiment/' asFileReference.
	microdownMPath := 'echo/data/Echo/Microdown-Modify-experiment/' asFileReference.

	blueprintParticipations := #( '01' '03' '05' '07' '08' '13' '14' )
		                           collect: [ :fname |
			                           fname -> (Dictionary new
				                           at: 'original'
				                           put: blueprintOPath / fname;
				                           at: 'modified'
				                           put: blueprintMPath / fname;
				                           yourself) ].

	microdownParticipations := #( '02' '04' '06' '09' '10' '11' '12' )
		                           collect: [ :fname |
			                           fname -> (Dictionary new
				                           at: 'original'
				                           put: microdownOPath / fname;
				                           at: 'modified'
				                           put: microdownMPath / fname;
				                           yourself) ].
	^ Dictionary new
		  at: 'Class Blueprint' put: blueprintParticipations asDictionary;
		  at: 'Microdown' put: microdownParticipations asDictionary;
		  yourself
]

{ #category : 'accessing' }
D3ExperimentResults class >> dataPath [

	^ 'echo/data/Echo/' asFileReference
]

{ #category : 'accessing' }
D3ExperimentResults class >> experimentName [
	^'Echo-1'
]

{ #category : 'data access' }
D3ExperimentResults >> answerStrategyAnalysisFor: aQuestionOccurrence [

	| fileRef |
	fileRef := self class analysisDataPath / aQuestionOccurrence uuid.
	^ fileRef exists
		  ifTrue: [ STON fromString: fileRef contents ]
		  ifFalse: [ D3AnswerStrategy new ]
]

{ #category : 'data access' }
D3ExperimentResults >> dataConfiguration [
	^self class dataConfiguration
]

{ #category : 'accessing' }
D3ExperimentResults >> experimentName [
	^self class experimentName
]

{ #category : 'installing' }
D3ExperimentResults >> load [ 

	| question_by_file |
	self loadParticipations .
	self loadQuestions .
	
	question_by_file := (questionOccurrences at: 'questions_par_fichier').
	question_by_file keysDo: [ :e | (participations at: ((e truncateTo:2) asNumber ))question: (question_by_file at:e) ]
]

{ #category : 'data access' }
D3ExperimentResults >> loadParticipations [

	participations := SortedCollection new sortBlock: [ :p1 :p2 |
		                  p1 participationId < p2 participationId ].
	self dataConfiguration keysAndValuesDo: [
		:taskName
		:participationDataFilename |
		participationDataFilename keysAndValuesDo: [ :idString :dataFilename |
			| participation |
			participation := D3Participation new.
			participation taskName: taskName.
			participation participationId: idString asNumber.
			participation initializeWithData: dataFilename.
			participations add: participation ] ]
]

{ #category : 'data access' }
D3ExperimentResults >> loadQuestions [

	| occurrences |
	occurrences := Dictionary new.
	questionOccurrences := 'echo/data/questions.json' asFileReference
		                       readStreamDo: [ :stream |
			                       STON reader
				                       on: stream;
				                       next ].
	questions := ('echo/data/questions-translated.json' asFileReference
		              readStreamDo: [ :stream |
			              STON reader
				              on: stream;
				              next ]) associations collect: [ :association |
		             D3DebuggingQuestion from: association ].
	self participations do: [ :p |
		p questions ifNotNil: [ :qs |
			qs
				collect: [ :d |
					(D3DebuggingQuestionOccurence fromDictionary: d)
						participantionId: p participationId;
						yourself ]
				thenDo: [ :q |
					(occurrences at: q tag ifAbsentPut: [ OrderedCollection new ])
						add: q ] ] ].

	questions do: [ :q |
		q occurrences:
			(occurrences at: q tag ifAbsent: [ OrderedCollection new ]) ].

	questions := questions sort: [ :a :b |
		             a occurrences size > b occurrences size ]
]

{ #category : 'accessing' }
D3ExperimentResults >> participations [

	^ participations
]

{ #category : 'accessing' }
D3ExperimentResults >> questions [
	^ questions
]

{ #category : 'data access' }
D3ExperimentResults >> saveAnswerStrategyAnalysis: analysis forQuestionOccurrence: aQuestionOccurrence [

	| fileRef |
	fileRef := self class analysisDataPath / aQuestionOccurrence uuid.
	fileRef writeStream nextPutAll: (STON toString: analysis)
]

{ #category : 'as yet unclassified' }
D3ExperimentResults >> usedToolsFor: aD3DebuggingQuestionOccurence [

	| participation tools |
	participation := participations detect: [ :p |
		                 p participationId
		                 = aD3DebuggingQuestionOccurence participantionId ].
	tools := Dictionary new.
	tools at: 'origin' put: participation oEventHistory usedTools.
	tools at: 'modified' put: participation mEventHistory usedTools.
	^tools
]
