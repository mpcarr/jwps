
'****************************
' Rotate Lane Lights Clockwise
' Event Listeners:  
AddPinEventListener SWITCH_RIGHT_FLIPPER_DOWN, "RotateLaneLightsClockwise"
'
'*****************************
Sub RotateLaneLightsClockwise()
    Dim temp : temp = GetPlayerState(LANE_1)
    SetPlayerState LANE_1, GetPlayerState(LANE_4)
    SetPlayerState LANE_4, GetPlayerState(LANE_3)
    SetPlayerState LANE_3, GetPlayerState(LANE_2)
    SetPlayerState LANE_2, temp
End Sub

'****************************
' Rotate Lane Lights Anti Clockwise
' Event Listeners:      
    AddPinEventListener SWITCH_LEFT_FLIPPER_DOWN, "RotateLaneLightsAntiClockwise"
'
'*****************************
Sub RotateLaneLightsAntiClockwise()
    Dim temp : temp = GetPlayerState(LANE_1)
    SetPlayerState LANE_1, GetPlayerState(LANE_2)
    SetPlayerState LANE_2, GetPlayerState(LANE_3)
    SetPlayerState LANE_3, GetPlayerState(LANE_4)
    SetPlayerState LANE_4, temp
End Sub

Sub HitInLanes(lane)
    AddScore POINTS_BASE
    If GetPlayerState(lane) = 0 Then
        SetPlayerState lane, 1
    End If
End Sub
