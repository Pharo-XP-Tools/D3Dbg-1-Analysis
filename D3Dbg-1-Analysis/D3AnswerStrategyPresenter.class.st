"
Use me to fill out a D3AnswerStrategy object.
"
Class {
	#name : 'D3AnswerStrategyPresenter',
	#superclass : 'SpPresenter',
	#instVars : [
		'tools',
		'comment',
		'isEchoCheckbox',
		'saveButton',
		'vlcButton',
		'answerStrategy',
		'experiment',
		'questionOccurrence',
		'toolsUsedInOriginTable',
		'toolsUsedInModifiedTable'
	],
	#category : 'D3Dbg-1-Analysis-Presenters',
	#package : 'D3Dbg-1-Analysis',
	#tag : 'Presenters'
}

{ #category : 'layout' }
D3AnswerStrategyPresenter >> defaultLayout [

	^ SpBoxLayout newTopToBottom
		  add: (SpBoxLayout newLeftToRight
				   "add: saveButton width: 100;"
				   add: vlcButton width: 100;
				   yourself)
		  expand: false fill: false;
		  add: (SpBoxLayout newTopToBottom
				   add: 'Used tools (check as many):' expand: false fill: false;
				   add: (SpBoxLayout newLeftToRight
						    add: toolsUsedInOriginTable;
						    add: toolsUsedInModifiedTable;
						    yourself);
				   yourself);
		  add: (SpBoxLayout newTopToBottom
				   add: (SpBoxLayout newLeftToRight
						    add: 'Analysis:' expand: false fill: false;
						    add: isEchoCheckbox expand: false fill: false;
						    yourself)
				   expand: false fill: false;
				   add: comment;
				   yourself);
		  yourself
]

{ #category : 'accessing' }
D3AnswerStrategyPresenter >> experiment: anObject [

	experiment := anObject
]

{ #category : 'actions' }
D3AnswerStrategyPresenter >> exportToDisk [

	experiment
		saveAnswerStrategyAnalysis: answerStrategy
		forQuestionOccurrence: questionOccurrence
]

{ #category : 'initialization' }
D3AnswerStrategyPresenter >> initializePresenters [

	comment := self newText.
	comment text: answerStrategy comment.
	comment whenTextChangedDo: [
		answerStrategy comment: comment text.
		self exportToDisk ].

	isEchoCheckbox := self newCheckBox.
	isEchoCheckbox state: answerStrategy isEcho.
	isEchoCheckbox whenActivatedDo: [
		answerStrategy isEcho: true.
		self exportToDisk ].
	isEchoCheckbox whenDeactivatedDo: [
		answerStrategy isEcho: false.
		self exportToDisk ].
	isEchoCheckbox label: 'is echo'.

	saveButton := self newButton
		              label: 'Export';
		              action: [ self exportToDisk ];
		              icon: (self iconNamed: #smallSave);
		              yourself.
	vlcButton := self newButton
		             label: 'Open video';
		             action: [ self openVLC ];
		             icon: (self iconNamed: #smallPrintIt);
		             yourself.

	toolsUsedInOriginTable := self toolTableFor: 'origin'.
	toolsUsedInModifiedTable := self toolTableFor: 'modified'
]

{ #category : 'actions' }
D3AnswerStrategyPresenter >> openVLC [

	[
	OSPlatform current runCommand:
		('python3 openVideo.py video/0{3}.mov {1} {2}' format: {
				 questionOccurrence start.
				 15.
				 questionOccurrence participationId printString }) ] fork
]

{ #category : 'accessing' }
D3AnswerStrategyPresenter >> questionOccurrence: anObject [

	questionOccurrence := anObject
]

{ #category : 'accessing - model' }
D3AnswerStrategyPresenter >> setModelBeforeInitialization: anAnswerStrategy [

	answerStrategy := anAnswerStrategy
]

{ #category : 'initialization' }
D3AnswerStrategyPresenter >> toolTableFor: originOrModified [

	| table box |
	table := self newTable.
	table
		addColumn: ((SpCheckBoxTableColumn
				  title: ' '
				  evaluated: [ :item |
					  answerStrategy isToolUsed: item for: originOrModified ])
				 onActivation: [ :item |
					 answerStrategy toolUsed: item for: originOrModified.
					 self exportToDisk ];
				 onDeactivation: [ :item |
					 answerStrategy toolNotUsed: item for: originOrModified.
					 self exportToDisk ];
				 width: 20;
				 yourself);
		addColumn:
			(SpStringTableColumn title: 'Tool' evaluated: [ :item | item ])
				yourself.
	box := SpBoxLayout newTopToBottom.
	box add: originOrModified capitalized expand: false fill: false.
	box add: table.
	^ box
]

{ #category : 'accessing' }
D3AnswerStrategyPresenter >> tools: anObject [

	tools := anObject.
	toolsUsedInOriginTable presenters second items: (tools at: 'origin').
	toolsUsedInModifiedTable presenters second items: (tools at: 'modified')
]
