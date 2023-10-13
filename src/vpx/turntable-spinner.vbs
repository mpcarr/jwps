
'******************************************************
' ZTTS				Turntable Spinner
'******************************************************

Dim SpinnerBall1

	'Spinner
	Set SpinnerBall1 = SpinnerKick.CreateSizedballWithMass(35/2,Ballmass*1.375)
	SpinnerBall1.visible = False
	Spinnerkick.kick 0,0,0
	Spinnerkick.enabled = False

Dim discPosition, discSpinSpeed, discLastPos, SpinCounter, maxvel
dim spinAngle, degAngle, spinAngle2, degAngle2, startAngle, postSpeedFactor
dim discX, discY
startAngle = -15
discX = 287.5
discY = 732.5
PostSpeedFactor = 130'90

Const cDiscSpeedMult = 32 '35 					' Affects speed transfer to object (deg/sec)
Const cDiscFriction = 0.55  '1.0    			' Friction coefficient (deg/sec/sec)
Const cDiscMinSpeed = 0.05 						' Object stops at this speed (deg/sec)
'Const cDiscMinSpeed = 5 						' use this value if you want to enable DOF for lamp below in script
Const cDiscRadius = 52

'Wobble
Const discSpringConst = -70 '-100
Const discSpringAngle = 30
Const discSpringRange = 25
'End Wobble

Sub SpinnerBallTimer_Timer()
	Dim oldDiscSpeed, discFriction
	oldDiscSpeed = discSpinSpeed

	discPosition = discPosition + discSpinSpeed * Me.Interval / 1000

	if ABS(discSpinSpeed) < 200 Then
		discFriction = 6 ' was 6
	else
		discFriction = cDiscFriction
	end if 
	discSpinSpeed = discSpinSpeed * (1 - discFriction * Me.Interval / 1000)

	Do While discPosition < 0 : discPosition = discPosition + 360 : Loop
	Do While discPosition > 360 : discPosition = discPosition - 360 : Loop

	'Wobble

	Dim UpperRange, LowerRange
	UpperRange = discSpringAngle + discSpringRange
	LowerRange = discSpringAngle - discSpringRange

	If abs(discSpinSpeed) < 400 Then
		If discPosition > LowerRange and discPosition < discSpringAngle Then
			discSpinSpeed = newDiscSpinSpeed(discSpinSpeed ,discPosition - LowerRange, Me.Interval / 1000)
		ElseIf discPosition > discSpringAngle and discPosition < UpperRange  Then
			discSpinSpeed = newDiscSpinSpeed(discSpinSpeed ,discPosition - UpperRange, Me.Interval / 1000)
		ElseIf discPosition > LowerRange+180 and discPosition < discSpringAngle+180 Then
			discSpinSpeed = newDiscSpinSpeed(discSpinSpeed ,discPosition - LowerRange - 180, Me.Interval / 1000)
		ElseIf discPosition > discSpringAngle+180 and discPosition < UpperRange+180  Then
			discSpinSpeed = newDiscSpinSpeed(discSpinSpeed ,discPosition - UpperRange - 180, Me.Interval / 1000)
		End If
	End If
	'End Wobble

	If Abs(discSpinSpeed) < cDiscMinSpeed Then
		discSpinSpeed = 0
		'DOF 103,DOFOff
	Else
		'DOF 103,DOFOn
	End If

	If discSpinSpeed < 0 and discPosition < 210 and discPosition > 30 and discLastPos <> 180 Then
		'PlaySoundAt SoundFX("fx_lamp",DOFGear), LampPr1
		'vpmTimer.PulseSw 56
		discLastPos = 180
	ElseIf discSpinSpeed < 0 and (discPosition >= 210  or discPosition < 30) and discLastPos <> 360 Then
		'PlaySoundAt SoundFX("fx_lamp",DOFGear), LampPr1
		'vpmTimer.PulseSw 56
		discLastPos = 360
	ElseIf discSpinSpeed > 0 and discPosition < 210  and discPosition > 30 and discLastPos <> 180 Then
		'PlaySoundAt SoundFX("fx_lamp",DOFGear), LampPr1
		'vpmTimer.PulseSw 57
		discLastPos = 180
	ElseIf discSpinSpeed > 0 and (discPosition >= 210  or discPosition < 30) and discLastPos <> 360 Then
		'PlaySoundAt SoundFX("fx_lamp",DOFGear), LampPr1
		'vpmTimer.PulseSw 57
		discLastPos = 360
	End If

	degAngle = -180 + startAngle + discPosition
	degAngle2 = degAngle + 180

	spinAngle = PI * (degAngle) / 180
	spinAngle2 = PI * (degAngle2) / 180
	
	SpinnerBall1.x = discX + (cDiscRadius * Cos(spinAngle))
	SpinnerBall1.y = discY + (cDiscRadius * Sin(spinAngle))
'	SpinnerBall1.z = 25

	If ABS(discSpinSpeed*sin(spinAngle)/postSpeedFactor) < 0.05 Then
		SpinnerBall1.velx = 0.05
	Else
		SpinnerBall1.velx = - discSpinSpeed*sin(spinAngle)/postSpeedFactor
	End If

	If Abs(discSpinSpeed*cos(spinAngle)/postSpeedFactor) < 0.05 Then
		SpinnerBall1.vely = 0.05
	Else
		SpinnerBall1.vely = discSpinSpeed*cos(spinAngle)/postSpeedFactor		'0.05
	End If

	SpinnerBall1.velz = 0


	SpinDisc.objrotz = discPosition + 75
	'LampPr1.objrotz = discPosition + 75
	'LampPr3.objrotz = discPosition + 75
	'LampPr001.objrotz = discPosition + 75
	'Flasher2.RotZ = discPosition + 75
	'Flasher3.RotZ = discPosition + 75

End Sub

Function newDiscSpinSpeed(spinspeed, springangle, springtime)
	newDiscSpinSpeed = spinspeed + discSpringConst * springangle * springtime
End Function

'********************************************
' Ball Collision, spinner collision and Sound
'********************************************

Sub OnBallBallCollision(ball1, ball2, velocity)

	dim collAngle,bvelx,bvely,hitball, whichBall
	If ball1.radius < 23 or ball2.radius < 23 then
		
		If ball1.radius < 23 Then
			collAngle = GetCollisionAngle(ball1.x,ball1.y,ball2.x,ball2.y)
			set hitball = ball2
			If ball1.x = SpinnerBall1.x and ball1.y = SpinnerBall1.y Then
				whichball = 1
			Else	
				whichball = 2
			End If
		else 
			collAngle = GetCollisionAngle(ball2.x,ball2.y,ball1.x,ball1.y)
			set hitball = ball1
			If ball2.x = SpinnerBall1.x and ball2.y = SpinnerBall1.y Then
				whichball = 1
			Else	
				whichball = 2
			End If
		End If

		dim discAngle

		If whichBall = 1 Then
			discAngle = NormAngle(spinAngle)
		Else
			discAngle = NormAngle(spinAngle2)
		End If

'		discSpinSpeed = discspinspeed + ecvel(0,1.5,sin(collAngle - discAngle)*velocity,BallMass * ABS(sin(collAngle - discAngle))) * cDiscSpeedMult

'		PlaySound "fx_lamphit", 0, Csng(velocity) ^2 / 2000, AudioPan(ball1), 0, Pitch(ball1), 1, 0, AudioFade(ball1)

		dim sineOfAngle, sineOfAngleSqr
		sineOfAngle = sin(collAngle - discAngle)

		discSpinSpeed = discspinspeed + ecvel(0,1.5,sineOfAngle*velocity,BallMass) * cDiscSpeedMult

		PlaySound "fx_lamphit", 0, Csng(velocity) ^2 / 2000 / 3, AudioPan(ball1), 0, Pitch(ball1), 1, 0, AudioFade(ball1)


	Else
		If ball1.z > 10 and ball2.z > 10 Then
'			PlaySound("fx_collide"), 0, Csng(velocity) ^2 / 2000, AudioPan(ball1), 0, Pitch(ball1), 0, 0, AudioFade(ball1)
			'--- From Fleep code
			Dim snd
			Select Case Int(Rnd * 7) + 1
				Case 1
				snd = "Ball_Collide_1"
				Case 2
				snd = "Ball_Collide_2"
				Case 3
				snd = "Ball_Collide_3"
				Case 4
				snd = "Ball_Collide_4"
				Case 5
				snd = "Ball_Collide_5"
				Case 6
				snd = "Ball_Collide_6"
				Case 7
				snd = "Ball_Collide_7"
			End Select
			
			PlaySound (snd), 0, CSng(velocity) ^ 2 / 200 * BallWithBallCollisionSoundFactor * VolumeDial, AudioPan(ball1), 0, Pitch(ball1), 0, 0, AudioFade(ball1)
			'--- End Fleep code
		End If

		'Newton ball code
		If (ball1.id = NewtonBall.id) and (ball2.id <> CaptiveBall.id) and (ball2.vely < 0) then KickCapBall ball2,velocity
		If (ball2.id = NewtonBall.id) and (ball1.id <> CaptiveBall.id) and (ball1.vely < 0) then KickCapBall ball1,velocity

	End If
End Sub

Const CBAngle = 1.5   '1.5 radians is the direction the captive ball can move
Sub KickCapBall(capball,velocity)
	dim angle, vel
	angle = CBAngle - GetCollisionAngle(NewtonBall.x, NewtonBall.y, capball.x, capball.x)    
	vel = 0.8*velocity*cos(angle)
	CaptiveBall.velx = vel*cos(CBAngle)
	CaptiveBall.vely = -vel*sin(CBAngle)
End Sub



Function GetCollisionAngle(ax, ay, bx, by)
	Dim ang
	Dim collisionV:Set collisionV = new jVector
	collisionV.SetXY ax - bx, ay - by
	GetCollisionAngle = collisionV.ang
End Function

Function NormAngle(angle)
	NormAngle = angle
''	Dim pi:pi = 3.14159265358979323846
	Do While NormAngle>2 * pi
		NormAngle = NormAngle - 2 * pi
	Loop
	Do While NormAngle <0
		NormAngle = NormAngle + 2 * pi
	Loop
End Function
 
Class jVector
     Private m_mag, m_ang, pi
 
     Sub Class_Initialize
         m_mag = CDbl(0)
         m_ang = CDbl(0)
         pi = CDbl(3.14159265358979323846)
     End Sub
 
     Public Function add(anothervector)
         Dim tx, ty, theta
         If TypeName(anothervector) = "jVector" then
             Set add = new jVector
             add.SetXY x + anothervector.x, y + anothervector.y
         End If
     End Function
 
     Public Function multiply(scalar)
         Set multiply = new jVector
         multiply.SetXY x * scalar, y * scalar
     End Function
 
     Sub ShiftAxes(theta)
         ang = ang - theta
     end Sub
 
     Sub SetXY(tx, ty)
 
         if tx = 0 And ty = 0 Then
             ang = 0
          elseif tx = 0 And ty <0 then
             ang = - pi / 180 ' -90 degrees
          elseif tx = 0 And ty>0 then
             ang = pi / 180   ' 90 degrees
         else
             ang = atn(ty / tx)
             if tx <0 then ang = ang + pi ' Add 180 deg if in quadrant 2 or 3
         End if
 
         mag = sqr(tx ^2 + ty ^2)
     End Sub
 
     Property Let mag(nmag)
         m_mag = nmag
     End Property
 
     Property Get mag
         mag = m_mag
     End Property
 
     Property Let ang(nang)
         m_ang = nang
         Do While m_ang>2 * pi
             m_ang = m_ang - 2 * pi
         Loop
         Do While m_ang <0
             m_ang = m_ang + 2 * pi
         Loop
     End Property
 
     Property Get ang
         Do While m_ang>2 * pi
             m_ang = m_ang - 2 * pi
         Loop
         Do While m_ang <0
             m_ang = m_ang + 2 * pi
         Loop
         ang = m_ang
     End Property
 
     Property Get x
         x = m_mag * cos(ang)
     End Property
 
     Property Get y
         y = m_mag * sin(ang)
     End Property
 
     Property Get dump
         dump = "vector "
         Select Case CInt(ang + pi / 8)
             case 0, 8:dump = dump & "->"
             case 1:dump = dump & "/'"
             case 2:dump = dump & "/\"
             case 3:dump = dump & "'\"
             case 4:dump = dump & "<-"
             case 5:dump = dump & ":/"
             case 6:dump = dump & "\/"
             case 7:dump = dump & "\:"
         End Select
 
         dump = dump & " mag:" & CLng(mag * 10) / 10 & ", ang:" & CLng(ang * 180 / pi) & ", x:" & CLng(x * 10) / 10 & ", y:" & CLng(y * 10) / 10
     End Property
End Class


Function ECVel(Velocity1, Mass1, Velocity2, Mass2)
	ECVel = (Mass1 - Mass2)/(Mass1 + Mass2) * Velocity1  + 2 * Mass2/(Mass1 + Mass2)*Velocity2 
End Function
