; Your typical AHK affair
#NoEnv
SendMode Input
SetWorkingDir %A_ScriptDir%

; Show start-up info
MsgBox, 64, AFKer v1.0.0, WARNING: Raw Input should be turned OFF for the anti-AntiAFK measures to work as intended!`n`nWARNING: Shift+F10 deactivation may not work as intended. For this reason it is recommended to use without Shift`n`nPress F4 at any time to see controls.

; Ready Guis
Gui, bypassHelp:New, +AlwaysOnTop +ToolWindow -Caption
Gui, bypassHelp:Add, Text,, There are two main types of AFK detection:`nKeypress based and mouse movement based. The AFK bypass (referred in the script as `"anti-AntiAFK`") bypasses mouse based.`n`nPress Shift+F4 to close this dialog.
Gui, controlsHelp:New, +AlwaysOnTop +ToolWindow -Caption
Gui, controlsHelp:Add, Text,, F4: Open/Close help dialog`nShift+F4: Open/Close `"What is anti-AntiAFK and how does it work?`" dialog`nF8: Hold right mouse button WITH anti-AntiAFK`nF9: Hold jump WITH anti-AntiAFK`nF10: Rapidly press left mouse button WITH anti-AntiAFK`nShift+Alt+F10: Show current F10 spam speed`nShift+F8/F9/F10: Do the corresponding action WITHOUT anti-AntiAFK`nHome: Increase F10 spam speed by 100ms`nEnd: Decrease F10 spam speed by 100ms`nPause: Reset F10 spam speed to default (300ms)

; Ready vars
moveMouseDistance := 1
clickSpamDelay := 300
antiAntiAFKusers := 0
toggleShiftF4 := 0
toggleF4 := 0
toggleShiftF8 := 0
toggleF8 := 0
toggleShiftF9 := 0
toggleF9 := 0
toggleShiftF10 := 0
toggleF10 := 0

; Controls help dialog
F4::
	if (!toggleShiftF4)
		toggleF4 := !toggleF4

	if (toggleF4 = 1)
		Gui, controlsHelp:Show
	else
		Gui, controlsHelp:Hide
return

; Bypass help dialog
+F4::
	if (!toggleF4)
		toggleShiftF4 := !toggleShiftF4

	if (toggleShiftF4 = 1)
		Gui, bypassHelp:Show
	else
		Gui, bypassHelp:Hide
return

; Hold right mouse with anti-AntiAFK
F8::
	if (!toggleShiftF8)
		toggleF8 := !toggleF8

	if (toggleF8) {
		SendInput, {RButton Down}
		antiAntiAFKusers++
		Goto, TimerTest
	} else if (!toggleShiftF8 && !toggleF8) {
		SendInput, {RButton Up}
		antiAntiAFKusers--
		Goto, TimerTest
	}	
return

; Hold right mouse without anti-AntiAFK
+F8::
	if (!toggleF8)
		toggleShiftF8 := !toggleShiftF8
	
	if (toggleShiftF8) {
		SendInput, {RButton Down}
	} else if (!toggleShiftF8 && !toggleF8) {
		SendInput, {RButton Up}
	}
return

; Hold space with anti-AntiAFK
F9::
	if (!toggleShiftF9)
		toggleF9 := !toggleF9

	if (toggleF9) {
		SendInput, {Space Down}
		antiAntiAFKusers++
		Goto, TimerTest
	} else if (!toggleShiftF9 && !toggleF9) {
		SendInput, {Space Up}
		antiAntiAFKusers--
		Goto, TimerTest
	}	
return

; Hold space without anti-AntiAFK
+F9::
	if (!toggleF9)
		toggleShiftF9 := !toggleShiftF9
	
	if (toggleShiftF9) {
		SendInput, {Space Down}
	} else if (!toggleShiftF9 && !toggleF9) {
		SendInput, {Space Up}
	}
return

; Spam left mouse with anti-AntiAFK
F10::
	if (!toggleShiftF10)
		toggleF10 := !toggleF10

	if (toggleF10) {
		SetTimer, clickSpam, %clickSpamDelay%
		antiAntiAFKusers++
		Goto, TimerTest
	} else if (!toggleShiftF10 && !toggleF10) {
		SetTimer, clickSpam, off
		SendInput, {LButton Up}
		antiAntiAFKusers--
		Goto, TimerTest
	}	
return

; Spam left mouse without anti-AntiAFK
+F10::
	if (!toggleF10)
		toggleShiftF10 := !toggleShiftF10

	if (toggleShiftF10) {
		SetTimer, clickSpam, %clickSpamDelay%
	} else if (!toggleShiftF10 && !toggleF10) {
		SetTimer, clickSpam, off
		SendInput, {LButton Up}
	}
return

; Show current left click spam speed
!+F10::
	if (!toggleF10 || !toggleShiftF10)
		toggleShiftF10 := !toggleShiftF10
	MsgBox, Left click spam delay: %clickSpamDelay%ms
return

; Increase current left click spam speed
Home::
clickSpamDelay += 100
if (toggleShiftF10 || toggleF10)
	SetTimer, clickSpam, %clickSpamDelay%
return

; Decrease current left click spam speed
End::
clickSpamDelay -= 100
if (toggleShiftF10 || toggleF10)
	SetTimer, clickSpam, %clickSpamDelay%
return

; Reset left click spam speed
Pause::
clickSpamDelay := 300
if (toggleShiftF10 || toggleF10)
	SetTimer, clickSpam, %clickSpamDelay%
return

; Check if another feature is using the timer so it isn't disabled unintentionally
TimerTest:
if (antiAntiAFKusers = 0)
	SetTimer, antiAntiAFK, off
else
	SetTimer, antiAntiAFK, 2000
return

; AFK bypass
; Move the mouse one pixel right, wait two seconds, one pixel left, wait, right, etc.
antiAntiAFK:
if (toggleMouseDirection = 0) {
	MouseMove, moveMouseDistance, 0, 90, R
	toggleMouseDirection := 1
} else {
	MouseMove, -moveMouseDistance, 0, 90, R
	toggleMouseDirection := 0
}
return 

; Name's on the tin (spam left click)
clickSpam:
SendInput, {LButton Down}
SendInput, {LButton Up}
return
