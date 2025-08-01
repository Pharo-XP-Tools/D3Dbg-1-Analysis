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

{ #category : 'accessing' }
D3ExperimentResults class >> newQuestionsIds [

	^ #( 3 4 5 6 7 8 11 12 14 15 16 18 19 20 23 25 26 27 28 30 32 36 41
	     42 43 44 45 46 49 52 53 54 55 )
]

{ #category : 'accessing' }
D3ExperimentResults class >> participantsExpertise [

	^ {
		  (#beginner -> #( 2 6 9 1 3 7 )).
		  (#intermediate -> #( 4 11 8 13 15 )).
		  (#expert -> #( 10 12 5 14 )) } asDictionary
]

{ #category : 'data loading' }
D3ExperimentResults >> answerStrategyAnalysisFor: aQuestionOccurrence [

	| fileRef |
	fileRef := self class analysisDataPath / aQuestionOccurrence uuid.
	^ fileRef exists
		  ifTrue: [ STON fromString: fileRef contents ]
		  ifFalse: [ D3AnswerStrategy new ]
]

{ #category : 'descriptive statistics' }
D3ExperimentResults >> averageDuration [

	^ (participations collect: [ :p | p totalDuration asDuration ])
		  average
]

{ #category : 'descriptive statistics' }
D3ExperimentResults >> averageQuestionByParticipant [

	^ ((questions collect: #occurrences) flattened size
	   / participations size) asFloat
]

{ #category : 'descriptive statistics' }
D3ExperimentResults >> averageQuestionPerMinute [
	"Nb questions / nb minutes"

	^ (questions collect: #occurrences) flattened size asFloat
	  /
		  (participations collect: [ :p |
			   p totalDuration asDuration asMinutes ]) sum
]

{ #category : 'descriptive statistics' }
D3ExperimentResults >> averageQuestionsPerExpertise [

	| result |
	result := Dictionary new.
	self participantsPerExpertise keysAndValuesDo: [ :expertise :parts |
		result
			at: expertise
			put:
			(parts collect: [ :p | (p questions ifNil: [ #(  ) ]) size ]) average asFloat].
	^ result
]

{ #category : 'data loading' }
D3ExperimentResults >> categorizeQuestions [

	| categories |
	categories := self class dataClassification.
	questions do: [ :q |
		categories keysAndValuesDo: [ :k :v |
			(v includes: q tag asNumber) ifTrue: [ q questionCategory: k ] ] ]
]

{ #category : 'initialization' }
D3ExperimentResults >> colorForQuestion: aQuestion [

	aQuestion category = #echo ifTrue: [ ^ Color yellow lighter].
	aQuestion category = #debug ifTrue: [ ^ Color orange lighter lighter].
	aQuestion category = #comprehension ifTrue: [ ^ Color magenta lighter lighter].
	^ Color lightGreen lighter
]

{ #category : 'data loading' }
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

{ #category : 'data loading' }
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

{ #category : 'data loading' }
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

	questions := questions asOrderedCollection.
	self categorizeQuestions.
	self mergeQuestions.
	questions := (questions sort: [ :a :b |
		              a occurrences size > b occurrences size ])
		             asOrderedCollection
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

{ #category : 'descriptive statistics' }
D3ExperimentResults >> medianDuration [

	^ (participations collect: [ :p | p totalDuration asDuration ])
		  median
]

{ #category : 'data access' }
D3ExperimentResults >> mergeNumberFor: aQuestionNumber [

	self class dataMerge keysAndValuesDo: [ :k :v |
		(v includes: aQuestionNumber) ifTrue: [ ^ k ] ].
	^ aQuestionNumber
]

{ #category : 'data loading' }
D3ExperimentResults >> mergeQuestions [

	| dataMerge questionsToMerge |
	dataMerge := self class dataMerge.
	questionsToMerge := questions select: [ :q |
		                    dataMerge keys includes: q tag asNumber ].
	questionsToMerge do: [ :q |
		| mergeList |
		mergeList := questions select: [ :mq |
			             (dataMerge at: q tag asNumber) includes:
				             mq tag asNumber ].
		mergeList do: [ :mq |
			mq tag: q tag.
			q occurrences addAll: mq occurrences.
			
			questions remove: mq ] ].


]

{ #category : 'descriptive statistics' }
D3ExperimentResults >> minMaxDuration [
	|durations|
	durations := (participations collect: [ :p | p totalDuration asDuration ]).
	^{durations min. durations max}
]

{ #category : 'data access' }
D3ExperimentResults >> participantsPerExpertise [

	| expertises perExpertise |
	expertises := self class participantsExpertise.
	perExpertise := Dictionary new.
	participations do: [ :p |
		expertises keysAndValuesDo: [ :k :v |
			(v includes: p participationId asNumber) ifTrue: [
				(perExpertise at: k ifAbsentPut: [ OrderedCollection new ]) add: p ] ] ].
	^ perExpertise
]

{ #category : 'accessing' }
D3ExperimentResults >> participations [

	^ participations
]

{ #category : 'data access' }
D3ExperimentResults >> quarters [

	| durations |
	durations := participations collect: [ :p |
		             p -> p totalDuration asSeconds ].
	^ durations collect: [ :d |
		  | timeDivision timestamps startTimeAsSeconds |
		  timeDivision := (d value asSeconds / 4) asFloat.
		  timestamps := OrderedCollection new.
		  startTimeAsSeconds := d key startTime asSeconds.
		  0 to: 3 do: [ :i |
			  timestamps add: {
					  (startTimeAsSeconds + (i * timeDivision)).
					  (startTimeAsSeconds
					   + (i + 1 * timeDivision min: d value asSeconds)) } ].
		  d key -> timestamps ]
]

{ #category : 'descriptive statistics' }
D3ExperimentResults >> questionCountPerExpertise [

	| result |
	result := Dictionary new.
	self participantsPerExpertise keysAndValuesDo: [ :expertise :parts |
		| questionsForExpertise counts |
		questionsForExpertise := ((((parts select: [ :p |
			                             p questions isNotNil ]) flatCollect:
			                            #questions) collect: [ :d |
			                           d at: 'tag' ]) select:
			                          #isAllAlphaNumerics) collect: #asNumber.
		counts := OrderedCollection new.
		((questions collect: #tag) collect: #asNumber) do: [ :qn |
			counts add: qn -> (questionsForExpertise count: [:each| (self mergeNumberFor: each) = qn]) ].
		result at: expertise put: counts asDictionary ].
	^ result
]

{ #category : 'descriptive statistics' }
D3ExperimentResults >> questionNumberPerExpertise [

	| result |
	result := Dictionary new.
	self questionCountPerExpertise keysAndValuesDo: [ :exp :count |
		count keysAndValuesDo: [ :q :n |
			n > 0 ifTrue: [
				(result at: exp ifAbsentPut: [ OrderedCollection new ]) add: q ] ] ].
	^ result
]

{ #category : 'descriptive statistics' }
D3ExperimentResults >> questionNumbersPerParticipant [

	^ ((participations select: [ :p | p questions notNil ]) collect: [ :p |
		   p -> (p questions collect: [ :occ | self mergeNumberFor: (occ at: 'tag') ]) asSet ])
		  asDictionary
]

{ #category : 'descriptive statistics' }
D3ExperimentResults >> questionSequencePerParticipant [

	^ ((participations select: [ :p | p questions notNil ]) collect: [ :p |
		   p -> (p questions collect: [ :occ | occ at: 'tag' ]) ])
		  asDictionary
]

{ #category : 'data access' }
D3ExperimentResults >> questionSequences [

	^ ((participations collect: #questions) reject: #isNil) collect: [
		  :qs |
		  (qs collect: [ :d | self mergeNumberFor: (d at: 'tag') asInteger ])
			  reject: #isNil ]
]

{ #category : 'descriptive statistics' }
D3ExperimentResults >> questionSequencesGraph [

	| connections sequences canvas shapes colors |
	connections := Dictionary new.
	sequences := self questionSequences.
	sequences do: [ :s |
		2 to: s size do: [ :i |
			(connections at: (s at: i) ifAbsentPut: [ OrderedCollection new ])
				add: (s at: i - 1) ] ].

	canvas := RSCanvas new.

	colors := (questions collect:[:q| q tag asNumber -> (self colorForQuestion: q)]) asDictionary.
	 
	"((self questionsColorsBase: '#ff0000') associations
		           collect: [ :ass | ass key tag asNumber -> ass value ])
		          asDictionary."
		
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

{ #category : 'descriptive statistics' }
D3ExperimentResults >> questionsCountPerParticipant [

	^ ((participations select: [ :p | p questions notNil ]) collect: [ :p |
		   p -> (p questions collect: [ :occ | occ at: 'tag' ]) size ])
		  asDictionary
]

{ #category : 'data loading' }
D3ExperimentResults >> saveAnswerStrategyAnalysis: analysis forQuestionOccurrence: aQuestionOccurrence [

	| fileRef |
	fileRef := self class analysisDataPath / aQuestionOccurrence uuid.
	fileRef writeStream
		nextPutAll: (STON toString: analysis);
		close
]

{ #category : 'descriptive statistics' }
D3ExperimentResults >> totalQuestionsPerExpertise [

	| result |
	result := Dictionary new.
	self participantsPerExpertise keysAndValuesDo: [ :expertise :parts |
		result
			at: expertise
			put:
			(parts collect: [ :p | (p questions ifNil: [ #(  ) ]) size ]) sum ].
	^ result
]

{ #category : 'descriptive statistics' }
D3ExperimentResults >> totalTimePerToolPerParticipant [

	^ (participations collect: [ :p | p -> p timePerTool ]) asDictionary
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
