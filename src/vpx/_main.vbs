'John Williams Pinball Symphony
'0001 - Sixtoe - Initial Build (built from VPW Example Table)
'0002 - Sixtoe - Added playfield mesh, subway, vuk, tower trap, lockpin control (activated by right ramp), giant hole (opened by going in tower), colour coded ramps (because reasons)
'0003 - Sixtoe - Added newton ball and captive ball, not coded yet, numerous playfield tweaks
'0005 - Sixtoe - Added Turntable spinner that raises up and down when a ball is locked in left tower
'0006 - apophis - Added preliminary captive ball code
'0007 - Sixtoe - Redid the special shape ramps / ramp entrances, tilted superman vertical ramp backwards a bit, made the top ramps circular to give them more space (in prep for something), tweaked entire table layout, added missing rubbers, added centre pole to spinner wheel when up
'0008 - apophis - Reworked captive ball
'0009 - flux - Added boilerplate game logic code. 4 player setup.
'0010 - flux - Added lightcontroller, some lights, ballsaver and lane code
'0011 - apophis - Reworked captive ball (again)
'0012 - Sixtoe - Changed the under spindisc geometry to make entry easier, fixed balls catching on NBKicker, made newtonball invisible and replaced with golden snitch primitive
'0013 - Sixtoe -Removed measuring kickers.
'0014 - flux - Tidied up left over example table bits, updated light controller, added basic pup and removed main flexdmd.
'0015 - flux - Removed Lampz, added inserts lights and gi lights.

Option Explicit
Randomize

On Error Resume Next
ExecuteGlobal GetTextFile("controller.vbs")
If Err Then MsgBox "You need the controller.vbs in order to run this table, available in the vp10 package"
On Error GoTo 0

Const DebugShotMode = 0 'Set to 0 to disable.  1 to enable

'*******************************************
'  User Options
'*******************************************

'----- DMD Options -----
Const UseFlexDMD = 0			'0 = no FlexDMD, 1 = enable FlexDMD
Const FlexONPlayfield = False	'False = off, True=DMD on playfield ( vrroom overrides this )

'----- Shadow Options -----
Const DynamicBallShadowsOn = 1	'0 = no dynamic ball shadow ("triangles" near slings and such), 1 = enable dynamic ball shadow
Const AmbientBallShadowOn = 1	'0 = Static shadow under ball ("flasher" image, like JP's), 1 = Moving ball shadow ("primitive" object, like ninuzzu's) - This is the only one that behaves like a true shadow!, 2 = flasher image shadow, but it moves like ninuzzu's

'----- General Sound Options -----
Const VolumeDial = 0.8			'Overall Mechanical sound effect volume. Recommended values should be no greater than 1.
Const BallRollVolume = 0.5		'Level of ball rolling volume. Value between 0 and 1
Const RampRollVolume = 0.5		'Level of ramp rolling volume. Value between 0 and 1

'----- VR Room -----
Const VRRoom = 0				'0 - VR Room off, 1 - Minimal Room, 2 - Ultra Minimal Room



'*******************************************
'  Constants and Global Variables
'*******************************************

Const UsingROM = False		'The UsingROM flag is to indicate code that requires ROM usage. Mostly for instructional purposes only.

Const BallSize = 50			'Ball diameter in VPX units; must be 50
Const BallMass = 1			'Ball mass must be 1
Const tnob = 7				'Total number of balls the table can hold
Const lob = 2				'Locked balls
Const cGameName = "JWPS"	'The unique alphanumeric name for this table

Dim tablewidth
tablewidth = Table1.width
Dim tableheight
tableheight = Table1.height
Dim BIP						'Balls in play
BIP = 0
Dim BIPL					'Ball in plunger lane
BIPL = False


Const IMPowerSetting = 50 			'Plunger Power
Const IMTime = 1.1        			'Time in seconds for Full Plunge
Dim plungerIM

Dim lightCtrl : Set lightCtrl = new LStateController
Dim gilvl : gilvl = 0  'General Illumination light state tracked for Dynamic Ball Shadows

'*******************************************
'  Table Initialization and Exiting
'*******************************************

LoadCoreFiles
Sub LoadCoreFiles
	On Error Resume Next
	ExecuteGlobal GetTextFile("core.vbs") 'TODO: drop-in replacement for vpmTimer (maybe vpwQueueManager) and cvpmDictionary (Scripting.Dictionary) to remove core.vbs dependency
	If Err Then MsgBox "Can't open core.vbs"
	On Error GoTo 0
End Sub

Dim JWPSBall1, JWPSBall2, JWPSBall3, JWPSBall4, JWPSBall5, gBOT, tmag, NewtonBall, CaptiveBall

Sub Table1_Init
	Dim i
	
	vpmMapLights alights
	lightCtrl.RegisterLights "VPX"

	'Ball initializations need for physical trough
	Set JWPSBall1 = swTrough1.CreateSizedballWithMass(Ballsize / 2,Ballmass)
	Set JWPSBall2 = swTrough2.CreateSizedballWithMass(Ballsize / 2,Ballmass)
	Set JWPSBall3 = swTrough3.CreateSizedballWithMass(Ballsize / 2,Ballmass)
	Set JWPSBall4 = swTrough4.CreateSizedballWithMass(Ballsize / 2,Ballmass)
	Set JWPSBall5 = swTrough5.CreateSizedballWithMass(Ballsize / 2,Ballmass)
	
	'Captive Ball
	Set CaptiveBall = CBKicker.CreateSizedballWithMass(Ballsize/2,Ballmass)
	Set NewtonBall = NBKicker.CreateSizedballWithMass(Ballsize/2,Ballmass)
	NewtonBall.visible = 0

	vpmTimer.AddTimer 300, "CBKicker.kick 180,0 '"
	vpmTimer.AddTimer 310, "CBKicker.enabled= 0 '"

	'*** Use gBOT in the script wherever BOT is normally used. Then there is no need for GetBalls calls ***
	gBOT = Array(NewtonBall, CaptiveBall, JWPSBall1, JWPSBall2, JWPSBall3, JWPSBall4, JWPSBall5)
	
	Dim xx
	
	' Add balls to shadow dictionary
	For Each xx In gBOT
		bsDict.Add xx.ID, bsNone
	Next
	
	' Make drop target shadows visible
	For Each xx In ShadowDT
		xx.visible = True
	Next

	Set plungerIM = New cvpmImpulseP
	With plungerIM
		.InitImpulseP swPlunger, IMPowerSetting, IMTime
		.Random 1.5
		.InitExitSnd SoundFX("fx_kicker", DOFContactors), SoundFX("fx_solenoid", DOFContactors)
		.CreateEvents "plungerIM"
	End With

	PlayVPXSeq()

End Sub


Sub Table1_Exit
	'Close flexDMD
	If UseFlexDMD = 0 Then Exit Sub
	'If Not FlexDMD Is Nothing Or VRRoom = 0 Then
		FlexDMD.Show = False
	'	FlexDMD.Run = False
	'	FlexDMD = Null
	'End If
End Sub
