
'*******************************************
'  Key Press Handling
'*******************************************

Sub Table1_KeyDown(ByVal keycode)
	DebugShotTableKeyDownCheck keycode
	
	If keycode = 19 Then
		ScoreCard = 1
		CardTimer.enabled = True
	End If
	
	If keycode = LeftFlipperKey Then
		FlipperActivate LeftFlipper, LFPress
		FlipperActivate LeftFlipper1, LFPress
		SolLFlipper True	'This would be called by the solenoid callbacks if using a ROM
		If gameStarted = True Then 
			DispatchPinEvent SWITCH_LEFT_FLIPPER_DOWN
		End If
	End If
	
	If keycode = RightFlipperKey Then
		FlipperActivate RightFlipper, RFPress
		SolRFlipper True	'This would be called by the solenoid callbacks if using a ROM
		If gameStarted = True Then 
			DispatchPinEvent SWITCH_RIGHT_FLIPPER_DOWN
		End If
	End If
	
	If keycode = PlungerKey Then
		Plunger.Pullback
		SoundPlungerPull
	End If
	
	If keycode = LeftTiltKey Then
		Nudge 90, 1
		SoundNudgeLeft
	End If
	If keycode = RightTiltKey Then
		Nudge 270, 1
		SoundNudgeRight
	End If
	If keycode = CenterTiltKey Then
		Nudge 0, 1
		SoundNudgeCenter
	End If
	If keycode = MechanicalTilt Then
		SoundNudgeCenter() 'Send the Tilting command to the ROM (usually by pulsing a Switch), or run the tilting code for an orginal table
	End If
	
	If keycode = StartGameKey Then
		SoundStartButton
		
		If gameStarted = False Then
			AddPlayer()
			StartGame()
		Else
			If canAddPlayers = True Then
				AddPlayer()
			End If		
		End If

	End If
	
	'   If keycode = keyInsertCoin1 or keycode = keyInsertCoin2 or keycode = keyInsertCoin3 or keycode = keyInsertCoin4 Then 'Use this for ROM based games
	If keycode = AddCreditKey Or keycode = AddCreditKey2 Then
		Select Case Int(Rnd * 3)
			Case 0
			PlaySound ("Coin_In_1"), 0, CoinSoundLevel, 0, 0.25
			Case 1
			PlaySound ("Coin_In_2"), 0, CoinSoundLevel, 0, 0.25
			Case 2
			PlaySound ("Coin_In_3"), 0, CoinSoundLevel, 0, 0.25
		End Select
	End If
	
End Sub



Sub Table1_KeyUp(ByVal keycode)
	DebugShotTableKeyUpCheck keycode
	
	If keycode = 19 Then ScoreCard = 0
	
	If KeyCode = PlungerKey Then
		Plunger.Fire
		If BIPL = 1 Then
			SoundPlungerReleaseBall()   'Plunger release sound when there is a ball in shooter lane
		Else
			SoundPlungerReleaseNoBall() 'Plunger release sound when there is no ball in shooter lane
		End If
	End If
	
	If keycode = LeftFlipperKey Then
		FlipperDeActivate LeftFlipper, LFPress
		FlipperDeActivate LeftFlipper1, LFPress
		SolLFlipper False   'This would be called by the solenoid callbacks if using a ROM
	End If
	
	If keycode = RightFlipperKey Then
		FlipperDeActivate RightFlipper, RFPress
		SolRFlipper False   'This would be called by the solenoid callbacks if using a ROM
	End If
End Sub
