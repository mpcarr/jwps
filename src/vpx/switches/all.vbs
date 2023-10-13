

Sub Kicker1_Hit
	set KickerBall1 = activeball
	Addscore 5000
	SoundSaucerLock
	Kicker1.timerenabled = True
End Sub

Sub Kicker1_Timer
	SoundSaucerKick 1, Kicker1
	KickBall KickerBall1, 23, 0, 50, 10
	Kicker1.timerenabled = False
	ToyLid.isdropped = 0
	ToyLid.collidable = 1
	ToyLid_Pillar.visible = 0
	ToyLid_Pillar.collidable = 0
	SpinDisc.transz = 0
	SpinnerBall1.z = 25
End Sub

'*******************************************
'  Triggers
'*******************************************


Sub Spinner_Spin
	Addscore 110
	SoundSpinner Spinner
End Sub

Sub swRampSW_Hit
	LockPin.isdropped = 0
End Sub

Sub LockPin_Hit
	LockPin.TimerEnabled = 1
End Sub

Sub LockPin_Timer
	vpmTimer.AddTimer 3000,"LockPin.isdropped = 1'"
	LockPin.TimerEnabled = 0
End Sub

'*******************************************
'  Tower Trigger
'*******************************************

Sub TowerKick_Hit
	TowerKick.TimerEnabled = 1
End Sub

Sub TowerKick_Timer
	ToyLid.isdropped = 1
	ToyLid.collidable = 0
	ToyLid_Pillar.visible = 1
	ToyLid_Pillar.collidable = 1
	SpinDisc.transz = 60
	SpinnerBall1.z = 85
	TowerKick.kick 0,0
	TowerKick.Enabled = 0
	vpmTimer.AddTimer 4000,"TowerKick.Enabled = 1'"
	TowerKick.TimerEnabled = 0
End Sub

'*******************************************
'  Ramp Triggers
'*******************************************
Sub ramptrigger01_hit()
	WireRampOn True	 'Play Plastic Ramp Sound
	bsRampOnClear	   'Shadow on ramp and pf below
End Sub

Sub ramptrigger02_hit()
	WireRampOff	 'Turn off the Plastic Ramp Sound
	bsRampOnWire	'Shadow only on pf
End Sub

Sub ramptrigger02_unhit()
	Addscore 10000
	WireRampOn False	'On Wire Ramp, Play Wire Ramp Sound
End Sub

Sub ramptrigger03_hit()
	WireRampOff	 'Exiting Wire Ramp Stop Playing Sound
End Sub

Sub ramptrigger03_unhit()
	PlaySoundAt "WireRamp_Stop", ramptrigger03
End Sub

'********************************************
'  Targets
'********************************************

Sub sw11_Hit
	STHit 11
End Sub

Sub sw11o_Hit
	TargetBouncer Activeball, 1
End Sub

Sub sw12_Hit
	STHit 12
End Sub

Sub sw12o_Hit
	TargetBouncer Activeball, 1
End Sub

Sub sw13_Hit
	STHit 13
End Sub

Sub sw13o_Hit
	TargetBouncer Activeball, 1
End Sub

'********************************************
'  Drop Target Controls
'********************************************

' Drop targets
Sub sw1_Hit
	DTHit 1
End Sub

Sub sw2_Hit
	DTHit 2
End Sub

Sub sw3_Hit
	DTHit 3
End Sub

' If the drop targets can be reset individually, use specific solenoid subs for each like below
' These subroutines would be called by the solenoid callbacks if using a ROM

Sub SolDT1(enabled) ' Drop Target 1 Solenoid
	If enabled Then
		RandomSoundDropTargetReset sw1p
		DTRaise 1
	End If
End Sub

Sub SolDT2(enabled) ' Drop Target 2 Solenoid
	If enabled Then
		RandomSoundDropTargetReset  sw2p
		DTRaise 2
	End If
End Sub

Sub SolDT3(enabled) ' Drop Target 3 Solenoid
	If enabled Then
		RandomSoundDropTargetReset  sw3p
		DTRaise 3
	End If
End Sub

' If a whole bank of drop targets can be reset at once, use sub like below

Sub SolDTBank123(enabled)
	Dim xx
	If enabled Then
		RandomSoundDropTargetReset sw2p
		DTRaise 1
		DTRaise 2
		DTRaise 3
		For Each xx In ShadowDT
			xx.visible = True
		Next
	End If
End Sub

'*******************************************
'  Other Solenoids
'*******************************************

' Knocker (this sub mimics how you would handle kicker in ROM based tables)
' For this to work, you must create a primitive on the table named KnockerPosition
' SolCallback(XX) = "SolKnocker"  'In ROM based tables, change the solenoid number XX to the correct number for your table.
Sub SolKnocker(Enabled) 'Knocker solenoid
	If enabled Then
		KnockerSolenoid 'Add knocker position object
	End If
End Sub
