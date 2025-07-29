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
		'answerStrategy'
	],
	#category : 'D3Dbg-1-Analysis-Presenters',
	#package : 'D3Dbg-1-Analysis',
	#tag : 'Presenters'
}

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
