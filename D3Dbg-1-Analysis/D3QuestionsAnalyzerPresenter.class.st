Class {
	#name : 'D3QuestionsAnalyzerPresenter',
	#superclass : 'SpPresenter',
	#instVars : [
		'questionsOccurrences',
		'experiment',
		'questionsTable'
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
D3QuestionsAnalyzerPresenter >> initializePresenters [

	questionsTable := self newTable.
	questionsTable addColumn:
		((SpStringTableColumn title: 'Tag' evaluated: [ :item | item key ])
			 width: 30;
			 yourself).
	questionsTable addColumn: ((SpStringTableColumn
			  title: 'Question'
			  evaluated: [ :item | item value ])
			 width: 30;
			 yourself).
	questionsTable items: experiment questions associations
]

{ #category : 'accessing - model' }
D3QuestionsAnalyzerPresenter >> setModelBeforeInitialization: anExperimentResults [

	experiment := anExperimentResults.
	questionsOccurrences := Dictionary new.
	experiment participations do: [ :p |
		p questions ifNotNil: [ :questions |
			questions
				collect: [ :d |
					(D3DebuggingQuestionOccurence fromDictionary: d)
						participantionId: p participationId;
						yourself ]
				thenDo: [ :q |
					(questionsOccurrences
						 at: q tag
						 ifAbsentPut: [ OrderedCollection new ]) add: q ] ] ].
	self halt
]
