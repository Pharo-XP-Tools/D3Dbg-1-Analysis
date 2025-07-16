"
I model a D3 experiment.
"
Class {
	#name : 'D3ExperimentResults',
	#superclass : 'Object',
	#instVars : [
		'participations'
	],
	#category : 'D3Dbg-1-Analysis',
	#package : 'D3Dbg-1-Analysis'
}

{ #category : 'raw data' }
D3ExperimentResults class >> dataConfiguration [

	| blueprintMPath blueprintOPath microdownMPath microdownOPath blueprintParticipations microdownParticipations |
	blueprintOPath := 'echo/data/Echo/classBluePrint-Original-experiment/' asFileReference.
	blueprintMPath := 'echo/data/Echo/classBluePrint-Modify-experiment/' asFileReference.
	microdownOPath := 'echo/data/Echo/Microdown-Origin-experiment/' asFileReference.
	microdownMPath := 'echo/data/Echo/Microdown-Modify-experiment/' asFileReference.

	blueprintParticipations := #( '01' '03' '05' '07' '08' '13' '14' )
		                           collect: [ :fname |
			                           fname -> (Dictionary new
				                           at: 'original'
				                           put: blueprintOPath / fname;
				                           at: 'modified'
				                           put: blueprintMPath / fname;
				                           yourself) ].

	microdownParticipations := #( '02' '04' '06' '09' '10' '11' '12' )
		                           collect: [ :fname |
			                           fname -> (Dictionary new
				                           at: 'original'
				                           put: microdownOPath / fname;
				                           at: 'modified'
				                           put: microdownMPath / fname;
				                           yourself) ].
	^ Dictionary new
		  at: 'Class Blueprint' put: blueprintParticipations asDictionary;
		  at: 'Microdown' put: microdownParticipations asDictionary;
		  yourself
]

{ #category : 'data access' }
D3ExperimentResults >> dataConfiguration [
	^self class dataConfiguration
]

{ #category : 'data access' }
D3ExperimentResults >> loadParticipations [

	participations := SortedCollection new sortBlock: [ :p1 :p2 |
		                  p1 participationId < p2 participationId ].
	self dataConfiguration keysAndValuesDo: [
		:taskName
		:participationDataFilename |
		participationDataFilename keysAndValuesDo: [ :idString :dataFilename |
			| participation |
			participation := D3Participation new.
			participation taskName: taskName.
			participation participationId: idString asNumber.
			participation initializeWithData: dataFilename.
			participations add: participation ] ]
]
