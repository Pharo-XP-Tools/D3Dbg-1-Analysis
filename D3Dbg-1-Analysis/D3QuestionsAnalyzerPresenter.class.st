Class {
	#name : 'D3QuestionsAnalyzerPresenter',
	#superclass : 'SpPresenter',
	#instVars : [
		'experiment',
		'questionsTable',
		'colors'
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
		  add: SpBoxLayout new;
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
	questionsTable items: experiment questions
]

{ #category : 'accessing - model' }
D3QuestionsAnalyzerPresenter >> setModelBeforeInitialization: anExperimentResults [

	experiment := anExperimentResults
]

{ #category : 'TOREMOVE' }
D3QuestionsAnalyzerPresenter >> title [
	^'Divergence Driven Question Analyzer'
]
