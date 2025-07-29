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
		'questionOccurrence'
	],
	#category : 'D3Dbg-1-Analysis-Presenters',
	#package : 'D3Dbg-1-Analysis',
	#tag : 'Presenters'
}

{ #category : 'layout' }
D3AnswerStrategyPresenter >> defaultLayout [

	^ SpBoxLayout newTopToBottom
		  add: (SpBoxLayout newLeftToRight
				   add: saveButton width: 100;
				   add: vlcButton width: 100;
				   yourself)
		  expand: false fill: false;
		  add: (SpBoxLayout newTopToBottom
				   add: 'Used tools (check as many):' expand: false fill: false;
				   add: SpBoxLayout newTopToBottom;
				   yourself);
		  add: (SpBoxLayout newTopToBottom
				   add: (SpBoxLayout newLeftToRight
						    add: 'Analysis:' expand: false fill: false;
						    add: isEchoCheckbox;
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

{ #category : 'initialization' }
D3AnswerStrategyPresenter >> initializePresenters [

	comment := self newText.
	comment text: answerStrategy comment.
	
	tools := answerStrategy usedTools.
	
	isEchoCheckbox := self newCheckBox.
	isEchoCheckbox state: answerStrategy isEcho.
	isEchoCheckbox whenActivatedDo: [ answerStrategy isEcho: true ].
	isEchoCheckbox whenDeactivatedDo: [ answerStrategy isEcho: false ].
	isEchoCheckbox label: 'isEcho'.
	
	saveButton := self newButton
		              label: 'Export';
		              action: [self exportToDisk ];
		              icon: (self iconNamed: #smallSave);
		              yourself.
	vlcButton := self newButton
		                 label: 'Open video';
		                 action: [self openVLC  ];
		                    icon: (self iconNamed: #smallPrintIt);
		                 yourself.
]

{ #category : 'accessing' }
D3AnswerStrategyPresenter >> questionOccurrence: anObject [

	questionOccurrence := anObject
]

{ #category : 'accessing - model' }
D3AnswerStrategyPresenter >> setModelBeforeInitialization: anAnswerStrategy [

	answerStrategy := anAnswerStrategy
]
