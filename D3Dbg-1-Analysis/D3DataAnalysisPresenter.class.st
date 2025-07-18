"
I'm a presenter for the exploration and the analysis of the D3 echo-1 qualitative experiment.
"
Class {
	#name : 'D3DataAnalysisPresenter',
	#superclass : 'SpPresenter',
	#instVars : [
		'participantsTable',
		'experiment',
		'buttonBar',
		'progress',
		'participantsToolbar',
		'dataDirs',
		'taskAnalysisPresenter'
	],
	#category : 'D3Dbg-1-Analysis-Presenters',
	#package : 'D3Dbg-1-Analysis',
	#tag : 'Presenters'
}

{ #category : 'layout' }
D3DataAnalysisPresenter >> buildParticipantsToolbar [

	participantsToolbar := self newToolbar.
	participantsToolbar addItem: (SpToolbarButtonPresenter new
			 label: 'Fix times';
			 icon: (self iconNamed: #history);
			 action: [ self fixTimes ];
			 yourself).
	participantsToolbar beIcons
]

{ #category : 'initialization' }
D3DataAnalysisPresenter >> colorForParticipation: p [

	^ p taskName = 'Microdown'
		  ifTrue: [ Color fromHexString: #D1F3E2 ]
		  ifFalse: [ Color fromHexString: #FEEEBA ]
]

{ #category : 'layout' }
D3DataAnalysisPresenter >> defaultLayout [

	^ SpBoxLayout newTopToBottom

		add: (SpPanedLayout newTopToBottom positionOfSlider: 30 percent;
		
		  add: (SpPanedLayout newLeftToRight
	positionOfSlider: 40 percent;
	add: (SpBoxLayout newTopToBottom
			 add: (SpBoxLayout newLeftToRight
					  add: 'Participants:' expand: false fill: false;
					  add: self participationsGeneralInfo expand: false fill: false;
					  add: participantsToolbar height: 16;
					  yourself)
			 expand: false
			 fill: false
			 padding: 5;
			 add: participantsTable;
			 yourself);
	yourself);
				   add: taskAnalysisPresenter;
				   yourself); yourself
]

{ #category : 'layout' }
D3DataAnalysisPresenter >> displayVisualizationsFor: p [

	taskAnalysisPresenter layout: (SpBoxLayout newLeftToRight
			 add: (SpBoxLayout newTopToBottom
					  add: 'Origin' expand: false fill: false padding: 5;
					  add: (StInspectorPresenter onObject: p oDSA);
					  yourself);
			 add: (SpBoxLayout newTopToBottom
					  add: 'Modified' expand: false fill: false padding: 5; 
					  add: (StInspectorPresenter onObject: p mDSA);
					  yourself);
			 yourself)
]

{ #category : 'initialization' }
D3DataAnalysisPresenter >> initializePresenters [

	taskAnalysisPresenter := StPresenter new. " OCREMetricAnalysisPresenter on: OrderedCollection new."
	taskAnalysisPresenter layout: SpBoxLayout newTopToBottom.

	participantsTable := self newTable.
	participantsTable contextMenu: self menu.

	participantsTable addColumn: ((SpStringTableColumn
			  title: 'Id'
			  evaluated: [ :item | item participationId ])
			 width: 30;
			 yourself).
	participantsTable addColumn: ((SpStringTableColumn
			  title: 'Date'
			  evaluated: [ :item | item dateStarted asLocalStringYMDHM ])
			 width: 100;
			 yourself).
	participantsTable addColumn: ((SpStringTableColumn
			  title: 'Duration'
			  evaluated: [ :item | item duration ])
			 width: 75;
			 yourself).

	participantsTable addColumn: ((SpStringTableColumn
			  title: 'Task'
			  evaluated: [ :item | item taskName ])
			 displayBackgroundColor: [ :p | self colorForParticipation: p ];
			 width: 75;
			 yourself).

	"	participantsTable addColumn:
		((SpImageTableColumn title: ' ' evaluated: [ :item |
				  item isControlTaskValid
					  ifTrue: [ self iconNamed: #testGreen ]
					  ifFalse: [ self iconNamed: #testRed ] ])
			 width: 16;
			 sortFunction: nil;
			 yourself).
	"


	"	participantsTable addColumn: (OCDbgLinkTableColumn new
			 title: 'Correctness';
			 evaluated: [ :item | self printCorrectnessFor: item ];
			 action: [ :item | self checkData: item ];
			 displayColor: [ :item | self correctnessColorFor: item ];
			 width: 100;
			 yourself)."

	"	participantsTable addColumn: ((OCDbgActionTableColumn title: 'Time check' 
		evaluated: [ :item | self iconNamed: #history ])
			action:[:p| self fixTime: p];
			 width: 40;
			 sortFunction: nil;
			 yourself)."

	participantsTable items: (experiment participations sort: [ :a :b |
			 a participationId < b participationId ]).

	participantsTable transmitDo: [ :p |
		self displayVisualizationsFor: p ].


	"buttonBar := self newButtonBar.
	buttonBar
		placeAtStart;"
	"		add: (self newButton
				 icon: (self application iconNamed: #glamorousZoomIn);
				 action: [ self openDetailedAnalysis ];
				 label: 'Explore';
				 yourself);"
	"add: (self newButton
				 icon: (self application iconNamed: #references);
				 action: [ self openDiagrams ];
				 label: 'Diagrams';
				 yourself);
		add: (self newButton
				 icon: (self application iconNamed: #glamorousInspect);
				 action: [ experiment inspect ];
				 label: 'Inspect';
				 yourself);
		add: (self newButton
				 icon: (self application iconNamed: #smallDoIt);
				 action: [ self doAnalysisAndUpdate ];
				 label: 'Analyze';
				 yourself);
		add: (self newButton
				 icon: (self application iconNamed: #glamorousTable);
				 action: [ self reload ];
				 label: 'Load';
				 yourself);
		add: (self newButton
				 icon: (self application iconNamed: #smallForward);
				 action: [ self stonExport ];
				 label: 'To STON';
				 yourself);
			add: (self newButton
				 icon: (self application iconNamed: #glamorousDown);
				 action: [ self stonImport ];
				 label: 'From STON';
				 yourself);
		add: (self newButton
				 icon: (self application iconNamed: #glamorousFolder);
				 action: [ self chooseAndLoad ];
				 label: 'Open';
				 yourself).
"

	self buildParticipantsToolbar
]

{ #category : 'initialization' }
D3DataAnalysisPresenter >> initializeWindow: aWindowPresenter [

	aWindowPresenter title: experiment experimentName
]

{ #category : 'layout' }
D3DataAnalysisPresenter >> menu [

	^ self newMenu
		  addItem: [ :anItem |
			  anItem
				  name: 'Fix data';
				  iconName: #configuration;
				  action: [
					  (OCRETaskSorcererPresenter on: participantsTable selectedItem) experimentResultsBrowser:  self;
						  open ] ];
		  addItem: [ :anItem |
			  anItem
				  name: 'inspect';
				  iconName: #glamorousInspect;
				  action: [ participantsTable selectedItem inspect ] ];
		  yourself
]

{ #category : 'analysis' }
D3DataAnalysisPresenter >> participationsGeneralInfo [

	^ String streamContents: [ :s |
		  s << experiment participations size asString.
		  s << ' participations' ]
]

{ #category : 'accessing - model' }
D3DataAnalysisPresenter >> setModelBeforeInitialization: aD3ExperimentResults [
	experiment := aD3ExperimentResults 
]
