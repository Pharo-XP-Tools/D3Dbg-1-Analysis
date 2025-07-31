"
Use me to analyze how questions were answered in divergence driven experiment Echo-1
"
Class {
	#name : 'D3QuestionsAnalyzerPresenter',
	#superclass : 'SpPresenter',
	#instVars : [
		'experiment',
		'questionsTable',
		'colors',
		'occurrencesList',
		'selectedQuestion',
		'answerAnalyzer',
		'totalQuestions',
		'totalOccurrences'
	],
	#category : 'D3Dbg-1-Analysis-Presenters',
	#package : 'D3Dbg-1-Analysis',
	#tag : 'Presenters'
}

{ #category : 'layout' }
D3QuestionsAnalyzerPresenter >> defaultLayout [

	^ SpPanedLayout newLeftToRight
		  positionOfSlider: 35 percent;
		  add: (SpBoxLayout newTopToBottom
				   add: ('{1} questions, {2} occurrences.' format: {
								    totalQuestions printString.
								    totalOccurrences printString })
				   expand: false fill: false;
				   add: questionsTable);
		  add: (SpPanedLayout newLeftToRight
				   positionOfSlider: 50 percent;
				   add: occurrencesList;
				   add: answerAnalyzer;
				   yourself);
		  yourself
]

{ #category : 'initialization' }
D3QuestionsAnalyzerPresenter >> initialExtent [
	"Initial extent of the SettingBrowser window"
	^ (1200@700) scaledByDisplayScaleFactor
]

{ #category : 'initialization' }
D3QuestionsAnalyzerPresenter >> initialize [

	self initializeColors.
	super initialize
]

{ #category : 'initialization' }
D3QuestionsAnalyzerPresenter >> initializeColors [

	colors := experiment questionsColorsBase: '#72d3fe'
]

{ #category : 'initialization' }
D3QuestionsAnalyzerPresenter >> initializePresenters [

	answerAnalyzer := SpBoxLayout newTopToBottom.
	questionsTable := self newTable.
	questionsTable addColumn: ((SpIndexTableColumn title: '')
			 width: 15;
			 yourself).
			"glamorousRedCircle"
	questionsTable addColumn:
		((SpStringTableColumn title: 'Tag' evaluated: [ :item | item tag ])
			 displayBackgroundColor: [ :question |
				 experiment colorForQuestion: question ];
			 displayAlignment: [ :object | SpColumnAlignment center ];
			 width: 30;
			 yourself).
	questionsTable addColumn: ((SpStringTableColumn
			  title: 'Occ.'
			  evaluated: [ :item | item occurrences size printString ])
			 displayBackgroundColor: [ :question | colors at: question ];
			 width: 30;
			 displayAlignment: [ :object | SpColumnAlignment center ];
			 yourself).
			
	questionsTable addColumn: (SpCompositeTableColumn new
			title: 'Question';
			addColumn: (SpImageTableColumn evaluated: [ :each | 
				self iconNamed: (each isNewQuestion 
					ifTrue: [ #greenCircle ] 
					ifFalse: [ #grayCircleEmpty ]) ]);
			addColumn: (SpStringTableColumn evaluated: [ :item | item question ])).
			
	"questionsTable addColumn: (SpStringTableColumn
			 title: 'Question'
			 evaluated: [ :item | item question ]) yourself."
	questionsTable items: (experiment questions reject: [:q| q count = 0]).

	occurrencesList := self newList.
	questionsTable transmitDo: [ :item |
		selectedQuestion := item.
		occurrencesList items: item occurrences ].
	occurrencesList transmitDo: [ :item |
		item ifNotNil: [
			answerAnalyzer := D3AnswerStrategyPresenter on:
				                  (experiment answerStrategyAnalysisFor: item).
			answerAnalyzer questionOccurrence: item.
			answerAnalyzer experiment: experiment.
			answerAnalyzer tools: (experiment usedToolsFor: item).
			self layout: self defaultLayout ] ]
]

{ #category : 'accessing - model' }
D3QuestionsAnalyzerPresenter >> setModelBeforeInitialization: anExperimentResults [

	experiment := anExperimentResults.
	totalQuestions := (experiment questions reject: [:q| q count = 0]) size.
	totalOccurrences := ((experiment questions collect: #occurrences)
		                     collect: #size) sum
]

{ #category : 'TOREMOVE' }
D3QuestionsAnalyzerPresenter >> title [
	^'Divergence Driven Question Analyzer'
]
