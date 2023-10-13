
'***********************************************************************************
'***** Switches                                                         	    ****
'***********************************************************************************

'******************************************
Sub LeftOutlane_Hit()
    If GetPlayerState(LANE_1) > 0 Then
        lightCtrl.Pulse l11, 0
    End If
    HitInLanes(LANE_1)
End Sub
'******************************************
Sub LeftInlane_Hit()
    If GetPlayerState(LANE_2) > 0 Then
        lightCtrl.Pulse l12, 0
    End If
    HitInLanes(LANE_2)
End Sub
'******************************************
Sub RightInlane_Hit()
    If GetPlayerState(LANE_3) > 0 Then
        lightCtrl.Pulse l13, 0
    End If
    HitInLanes(LANE_3)
End Sub
'******************************************
Sub RightOutlane_Hit()
    If GetPlayerState(LANE_4) > 0 Then
        lightCtrl.Pulse l14, 0
    End If
    HitInLanes(LANE_4)
End Sub
'******************************************
