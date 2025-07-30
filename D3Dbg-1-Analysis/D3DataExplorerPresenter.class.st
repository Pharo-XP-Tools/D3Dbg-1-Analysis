"
I provide access to all D3 analysis tools.
"
Class {
	#name : 'D3DataExplorerPresenter',
	#superclass : 'SpPresenter',
	#instVars : [
		'explorerNotebook',
		'experiment'
	],
	#category : 'D3Dbg-1-Analysis-Presenters',
	#package : 'D3Dbg-1-Analysis',
	#tag : 'Presenters'
}

{ #category : 'layout' }
D3DataExplorerPresenter >> defaultLayout [

	^ SpBoxLayout newTopToBottom
		  add: explorerNotebook;
		  yourself
]

{ #category : 'accessing' }
D3DataExplorerPresenter >> initialExtent [
	"Initial extent of the SettingBrowser window"
	^ (1200@700) scaledByDisplayScaleFactor
]

{ #category : 'layout' }
D3DataExplorerPresenter >> initializePresenter [ 
	|main questions |
	main := D3DataAnalysisPresenter on: experiment.
	questions := D3QuestionsAnalyzerPresenter on: experiment. 
	explorerNotebook := self newNotebook.
	explorerNotebook addPageTitle: main title provider: [ main ].
	explorerNotebook addPageTitle: questions title provider: [ questions ].
	explorerNotebook addPageTitle: 'Questions graph' provider: [SpRoassalInspectorPresenter new canvas: experiment questionSequencesGraph  ].
]

{ #category : 'accessing - model' }
D3DataExplorerPresenter >> setModelBeforeInitialization: aD3Experiment [
	experiment := aD3Experiment 
]

{ #category : 'layout' }
D3DataExplorerPresenter >> title [
	^'D3 Echo Explorer'
]
