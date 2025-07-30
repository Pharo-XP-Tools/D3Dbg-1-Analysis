"
I model a D3 experiment.
"
Class {
	#name : 'D3ExperimentResults',
	#superclass : 'Object',
	#instVars : [
		'participations',
		'questionOccurrences',
		'questions',
		'mergedQuestions'
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

{ #category : 'accessing' }
D3ExperimentResults class >> dataClassification [
	^{#echo -> #(6 15 14 7 18 43 53 54 45 12 42 55).
	#debug -> #(3 4 5 16 49 11 44).
	#comprehension -> #(8 19 23 20 25 26 27 28 30 32 36 41 46 52)} asDictionary 
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
D3ExperimentResults class >> dataMerge [

	^ {
		  (6 -> #( 15 )).
		  (7 -> #( 14 )).
		  (3 -> #( 4 5 16 49 )).
		  (19 -> #( 23 )) } asDictionary
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

{ #category : 'constants' }
D3ExperimentResults >> marker [

	^ RSMarker new
		  shape: (RSShapeFactory triangle
				   color: Color red;
				   "border: self border;"size: 10;
				   yourself);
		  yourself
]

{ #category : 'accessing' }
D3ExperimentResults >> participations [

	^ participations
]

{ #category : 'data access' }
D3ExperimentResults >> questionSequences [

	^ ((participations collect: #questions) reject: #isNil) collect: [
		  :qs |
		  (qs collect: [ :d |
			   (D3DebuggingQuestionOccurence fromDictionary: d) tag asInteger ])
			  reject: #isNil ]
]

{ #category : 'data access' }
D3ExperimentResults >> questionSequencesGraph [

	| connections sequences canvas shapes colors |
	connections := Dictionary new.
	sequences := self questionSequences.
	sequences do: [ :s |
		2 to: s size do: [ :i |
			(connections at: (s at: i) ifAbsentPut: [ OrderedCollection new ])
				add: (s at: i - 1) ] ].

	canvas := RSCanvas new.

	colors := ((self questionsColorsBase: '#ff0000') associations
		           collect: [ :ass | ass key tag asNumber -> ass value ])
		          asDictionary.
	shapes := connections keys asArray collect: [ :m |
		          RSBox new
			          labeled;
			          size: (10 max: 4 * (connections at: m) size);
			          model: m;
			          draggable;
			          withBorder;
			          color: (colors at: m ifAbsent: [ Color white ]);
			          yourself ].
	RSLineBuilder line
		beDirectional;
		markerStart: self marker;
		withBorderAttachPoint;
		shapes: shapes;
		canvas: canvas;
		useAssociations: ((connections keys collect: [ :k |
					  (connections at: k) collect: [ :v | k -> v ] ]) flattened
				 reject: [ :ass | ass key = ass value ]).
	canvas edges do: #withBorder.
	canvas addAll: shapes.
	canvas shapes @ RSHighlightable red.
	RSWeightedCircleLayout new on: shapes. "gapSize: 40; "
	canvas @ RSCanvasController.
	canvas zoomToFit.
	^ canvas
]

{ #category : 'accessing' }
D3ExperimentResults >> questions [
	^ questions
]

{ #category : 'accessing' }
D3ExperimentResults >> questionsColorsBase: aHexString [

	| colors color |
	colors := Dictionary new.
	color := Color fromHexString: aHexString.

	self questions do: [ :q |
		colors at: q put: color.
		color := color lighter ].
	^ colors
]

{ #category : 'data access' }
D3ExperimentResults >> saveAnswerStrategyAnalysis: analysis forQuestionOccurrence: aQuestionOccurrence [

	| fileRef |
	fileRef := self class analysisDataPath / aQuestionOccurrence uuid.
	fileRef writeStream
		nextPutAll: (STON toString: analysis);
		close
]

{ #category : 'data access' }
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
