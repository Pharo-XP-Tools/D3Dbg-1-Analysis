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
		'answerAnalyzer'
	],
	#category : 'D3Dbg-1-Analysis-Presenters',
	#package : 'D3Dbg-1-Analysis',
	#tag : 'Presenters'
}

{ #category : 'layout' }
D3QuestionsAnalyzerPresenter >> defaultLayout [

	^ SpPanedLayout newLeftToRight
		  positionOfSlider: 30 percent;
		  add: questionsTable;
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
	^ (900@600) scaledByDisplayScaleFactor
]

{ #category : 'initialization' }
D3QuestionsAnalyzerPresenter >> initialize [

	self initializeColors.
	super initialize
]

{ #category : 'initialization' }
D3QuestionsAnalyzerPresenter >> initializeColors [

	| color |
	colors := Dictionary new.
	color := Color fromHexString: '#72d3fe'.

	experiment questions do: [ :q |
		colors at: q put: color.
		color := color lighter ]
]

{ #category : 'initialization' }
D3QuestionsAnalyzerPresenter >> initializePresenters [

	answerAnalyzer := SpBoxLayout newTopToBottom.
	questionsTable := self newTable.
	questionsTable addColumn:
		((SpStringTableColumn title: 'Tag' evaluated: [ :item | item tag ])
			 width: 30;
			 yourself).
	questionsTable addColumn: ((SpStringTableColumn
			  title: 'Occ.'
			  evaluated: [ :item | item occurrences size printString ])
			 displayBackgroundColor: [ :question | colors at: question ];
			 width: 30;
			 displayAlignment: [ :object | SpColumnAlignment center ];
			 yourself).
	questionsTable addColumn: (SpStringTableColumn
			 title: 'Question'
			 evaluated: [ :item | item question ]) yourself.
	questionsTable items: experiment questions.

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
			self layout: self defaultLayout ] ]
]

{ #category : 'accessing - model' }
D3QuestionsAnalyzerPresenter >> setModelBeforeInitialization: anExperimentResults [

	experiment := anExperimentResults
]

{ #category : 'TOREMOVE' }
D3QuestionsAnalyzerPresenter >> title [
	^'Divergence Driven Question Analyzer'
]
