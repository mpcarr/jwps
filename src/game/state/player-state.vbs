
'***********************************************************************************
'***** Player State                                                     	    ****
'***********************************************************************************

'Score 
Const SCORE = "Player Score"
'Ball
Const CURRENT_BALL = "Current Ball"
'Lanes
Const LANE_1 = "Lane 1"
Const LANE_2 = "Lane 2"
Const LANE_3 = "Lane 3"
Const LANE_4 = "Lane 4"
'Ball Save
Const BALL_SAVE_ENABLED = "Ball Save Enabled"
'Locked Balls
Const BALLS_LOCKED = "Balls Locked"


Function GetPlayerState(key)
    If IsNull(currentPlayer) Then
        Exit Function
    End If

    If playerState(currentPlayer).Exists(key)  Then
        GetPlayerState = playerState(currentPlayer)(key)
    Else
        GetPlayerState = Null
    End If
End Function

Function SetPlayerState(key, value)
    If IsNull(currentPlayer) Then
        Exit Function
    End If

    If playerState(currentPlayer).Exists(key)  Then
        playerState(currentPlayer)(key) = value
    Else
        playerState(currentPlayer).Add key, value
    End If
    If playerEvents.Exists(key) Then
        Dim x
        For Each x in playerEvents(key).Keys()
            If playerEvents(key)(x) = True Then
                ExecuteGlobal x
            End If
        Next
    End If
    
    SetPlayerState = Null
End Function

Sub AddStateListener(e, v)
    If Not playerEvents.Exists(e) Then
        playerEvents.Add e, CreateObject("Scripting.Dictionary")
    End If
    playerEvents(e).Add v, True
End Sub

Sub AddPinEventListener(e, v)
    If Not pinEvents.Exists(e) Then
        pinEvents.Add e, CreateObject("Scripting.Dictionary")
    End If
    pinEvents(e).Add v, True
End Sub

Sub EmitAllPlayerEvents()
    Dim key
    For Each key in playerState(currentPlayer).Keys()
        If playerEvents.Exists(key) Then
            Dim x
            For Each x in playerEvents(key).Keys()
                If playerEvents(key)(x) = True Then
                    ExecuteGlobal x
                End If
            Next
        End If
    Next
End Sub

Sub DispatchPinEvent(e)
    If Not pinEvents.Exists(e) Then
        Exit Sub
    End If
    Dim x
    For Each x in pinEvents(e).Keys()
        If pinEvents(e)(x) = True Then
            ExecuteGlobal x
        End If
    Next
End Sub
