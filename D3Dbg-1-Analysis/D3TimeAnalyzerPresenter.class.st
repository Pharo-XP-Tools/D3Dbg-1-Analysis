Class {
	#name : 'D3TimeAnalyzerPresenter',
	#superclass : 'SpPresenter',
	#instVars : [
		'idleTimesList',
		'saveButton',
		'openVLCButton',
		'timeEventgaps',
		'decision',
		'comment',
		'idleTimes',
		'selectedIdleTime'
	],
	#category : 'D3Dbg-1-Analysis-Presenters',
	#package : 'D3Dbg-1-Analysis',
	#tag : 'Presenters'
}

{ #category : 'layout' }
D3TimeAnalyzerPresenter >> defaultLayout [

	^ SpPanedLayout newLeftToRight
		  positionOfSlider: 30 percent;
		  add: idleTimesList;
		  add: (SpBoxLayout newTopToBottom
				   add: (SpBoxLayout newLeftToRight
						    add: saveButton width: 90;
						    add: openVLCButton width: 90;
						    yourself)
				   expand: false fill: false;
				   add: (SpBoxLayout newLeftToRight
						    add: 'Time gap between:' expand: false fill: false;
						      add: timeEventgaps expand: false fill: false;
						yourself)
				   expand: false fill: false;
				   add: decision expand: false fill: false;
				   add: 'Comment:' expand: false fill: false;
				   add: comment;
				   yourself);
		  yourself
]

{ #category : 'initialization' }
D3TimeAnalyzerPresenter >> initializePresenters [

	idleTimesList := self newList.
	idleTimesList displayColor: [ :item |
		item activityType ifNil: [ Color red ] ifNotNil: [ Color blue ] ].
	idleTimesList whenSelectedDo: [ :s | self updateSelectedIdleTime: s ].
	idleTimesList items: idleTimes.

	comment := self newText.
	comment whenTextChangedDo: [ :newValue |
		selectedIdleTime ifNotNil: [ :t | t comment: newValue ] ].


	decision := self newDropList.
	decision
		addItemLabeled: '(unknown time gap)'
		do: [ selectedIdleTime ifNotNil: [ :e | e activityType: nil ] ]
		icon: (self iconNamed: #comments).
	decision
		addItemLabeled: D3TimeOutsidePharo externalActivities first
		do: [
			selectedIdleTime activityType:
				D3TimeOutsidePharo externalActivities first ]
		icon: (self iconNamed: #github).
	decision
		addItemLabeled: D3TimeOutsidePharo externalActivities second
		do: [
			selectedIdleTime activityType:
				D3TimeOutsidePharo externalActivities second ]
		icon: (self iconNamed: #book).


	saveButton := self newButton
		              label: 'Save';
		              action: [  ];
		              icon: (self iconNamed: #smallSave);
		              yourself.
	openVLCButton := self newButton
		                 label: 'Open video';
		                 action: [  ];
		                    icon: (self iconNamed: #smallPrintIt);
		                 yourself.
	timeEventgaps := self newLabel.

	idleTimesList selectIndex: 1
]

{ #category : 'actions' }
D3TimeAnalyzerPresenter >> openVLC [

	OSPlatform current runCommand:
		('python3 openVideo.py video/01.mov {1} {2}' format: {
				 selectedIdleTime interruptionStart asTime asSeconds.
				 selectedIdleTime interruptionDuration asSeconds })
]

{ #category : 'accessing - model' }
D3TimeAnalyzerPresenter >> setModelBeforeInitialization: timeGaps [

	idleTimes := timeGaps
]

{ #category : 'updating' }
D3TimeAnalyzerPresenter >> updateSelectedIdleTime: s [

	| decisionIndex |
	selectedIdleTime := s.
	decisionIndex := s activityType
		                 ifNil: [ 1 ]
		                 ifNotNil: [
		                 (D3TimeOutsidePharo externalActivities indexOf:
			                  s activityType) + 1 ].
	decision selectIndex: decisionIndex.
	comment text: (s comment ifNil: [ '' ]).
	timeEventgaps label: (String streamContents: [ :str |
			 s interruptionStop printHMSOn: str.
			 str << ' and '.
			 s interruptionStart printHMSOn: str ]).
	self update
]
