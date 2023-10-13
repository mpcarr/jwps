
'****************************
' Lane Lights 1
' Event Listeners:  
AddStateListener LANE_1, "LaneLights1"
'
'*****************************
Sub LaneLights1()
    lightCtrl.LightState l11, GetPlayerState(LANE_1)
End Sub
'****************************
' Lane Lights 2
' Event Listeners:  
    AddStateListener LANE_2, "LaneLights2"
'
'*****************************
Sub LaneLights2()
    lightCtrl.LightState l12, GetPlayerState(LANE_2)
End Sub
'****************************
' Lane Lights 3
' Event Listeners:  
    AddStateListener LANE_3, "LaneLights3"
'
'*****************************
Sub LaneLights3()
    lightCtrl.LightState l13, GetPlayerState(LANE_3)
End Sub
'****************************
' Lane Lights 4
' Event Listeners:  
    AddStateListener LANE_4, "LaneLights4"
'
'*****************************
Sub LaneLights4()
    lightCtrl.LightState l14, GetPlayerState(LANE_4)
End Sub
