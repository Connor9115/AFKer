; Your typical AHK affair
#NoEnv
SendMode Input
SetWorkingDir %A_ScriptDir%

; Version vars
version := "v1.1.0"
owner := "Connor9115"
repo := "AFKer"

; Get latest version
res := WebRequest("https://api.github.com/repos/" . owner . "/" . repo . "/releases/latest",,,, error := "")
if error
	MsgBox,, Error, % error . "`n`nresponse:`n" . res
else
	pos := RegExMatch(res, """tag_name"":\s*""\K[^""]*", ver)

; If newer version, ask to update
latestVersion := (pos ? ver : "not found")
if (latestVersion != version) {
	wantUpdate := 0
	MsgBox, 4, New Version Available, A new version has been found!`nNew Version: %latestVersion% `nCurrent Version: %version%
	IfMsgBox Yes
		wantUpdate := 1
	if (wantUpdate) {
		UrlDownloadToFile, https://github.com/Connor9115/AFKer/releases/latest/download/AFKer.exe, AFKer.exe
		MsgBox, AFKer has been updated and will now close. Please reopen the script manually.
		ExitApp
	}
}

; Show start-up info
MsgBox, 64, AFKer v1.1.0, WARNING: Raw Input should be turned OFF for the anti-AntiAFK measures to work as intended!`n`nWARNING: Shift+F10 deactivation may not work as intended. For this reason it is recommended to use without Shift`n`nPress F4 at any time to see controls.

; Ready Guis
; delayInput
Gui, delayInput:New, +AlwaysOnTop +ToolWindow -Caption
Gui, delayInput:Add, Text, x12 y9 w170 h20, Enter left click delay: (default 300)
Gui, delayInput:Add, Text, x12 y59 w170 h20, Enter right click delay: (default 300)
Gui, delayInput:Add, Edit, x12 y29 w170 h20 +Limit5 +Number vLNewDelay, 300
Gui, delayInput:Add, Edit, x12 y79 w170 h20 +Limit5 +Number vRNewDelay, 300
Gui, delayInput:Add, Button, gDelayDone x59 y108 w78 h27, Done

; bypassHelp
Gui, bypassHelp:New, +AlwaysOnTop +ToolWindow -Caption
Gui, bypassHelp:Add, Text,, 
(
There are two main types of AFK detection:
Keypress based and mouse movement based. The AFK bypass (referred in the script as `"anti-AntiAFK`") bypasses mouse based.
`nPress Shift+F4 to close this dialog.
)

; controlHelp
Gui, controlsHelp:New, +AlwaysOnTop +ToolWindow -Caption
Gui, controlsHelp:Add, Text,, 
(
F4: Open/Close help dialog
Shift+F4: Open/Close `"What is anti-AntiAFK and how does it work?`" dialog
F8: Spam right mouse button WITH anti-AntiAFK
Alt+F8: Hold right mouse button WITH anti-AntiAFK
F9: Hold jump WITH anti-AntiAFK
F10: Rapidly press left mouse button WITH anti-AntiAFK
Shift+Alt+F10: Show current click spam speed
Shift+F8/F9/F10: Do the corresponding action WITHOUT anti-AntiAFK
Alt+Shift+F12: Suspend the script
Ctrl+Alt+Shift+F12: Exit the this script
Home: Increase LEFT click spam speed by 100ms
End: Decrease LEFT click spam speed by 100ms
Shift+Home: Increase RIGHT click spam speed by 100ms
Shift+End: Decrease RIGHT click spam speed by 100ms
Pause: Reset LEFT click spam speed to default (300ms)
Shift+Pause: Reset RIGHT click spam speed to default (300ms)
Alt+Shift+Pause: Enter custom right and left spam speed in milliseconds
)

; Ready vars
moveMouseDistance := 1
lclickSpamDelay := 300
rclickSpamDelay := 300
antiAntiAFKusers := 0
toggleShiftF4 := 0
toggleF4 := 0
toggleShiftF8 := 0
toggleF8 := 0
toggleAltShiftF8 := 0
toggleAltF8 := 0
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
!F8::
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
!+F8::
	if (!toggleF8)
		toggleShiftF8 := !toggleShiftF8
	
	if (toggleShiftF8) {
		SendInput, {RButton Down}
	} else if (!toggleShiftF8 && !toggleF8) {
		SendInput, {RButton Up}
	}
return

; Spam right mouse with anti-AntiAFK
F8::
	if (!toggleAltShiftF8)
		toggleAltF8 := !toggleAltF8

	if (toggleAltF8) {
		SetTimer, rclickSpam, %rclickSpamDelay%
		antiAntiAFKusers++
		Goto, TimerTest
	} else if (!toggleAltShiftF8 && !toggleAltF8) {
		SetTimer, rclickSpam, off
		antiAntiAFKusers--
		Goto, TimerTest
	}	
return

; Spam right mouse without anti-AntiAFK
+F8::
	if (!toggleAltF8)
		toggleAltShiftF8 := !toggleAltShiftF8
	
	if (toggleAltShiftF8) {
		SetTimer, rclickSpam, %rclickSpamDelay%
	} else if (!toggleAltShiftF8 && !toggleAltF8) {
		SetTimer, rclickSpam, off
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
		SetTimer, lclickSpam, %lclickSpamDelay%
		antiAntiAFKusers++
		Goto, TimerTest
	} else if (!toggleShiftF10 && !toggleF10) {
		SetTimer, lclickSpam, off
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
		SetTimer, lclickSpam, %lclickSpamDelay%
	} else if (!toggleShiftF10 && !toggleF10) {
		SetTimer, lclickSpam, off
		SendInput, {LButton Up}
	}
return

; Show current left click spam speed
!+F10::
	if (!toggleF10 || !toggleShiftF10)
		MsgBox, Left click spam delay: %lclickSpamDelay%ms`nRight click spam delay: %rclickSpamDelay%ms
return

; "Can I haz keys back?" (Suspends the script)
!+F12::
	Suspend, Toggle
return

; "Take it behind the barn" (Close/exit the script)
!^+F12::
Suspend, Permit
ExitApp, 0

; Increase current left click spam speed
Home::
lclickSpamDelay += 100
if (toggleShiftF10 || toggleF10)
	SetTimer, lclickSpam, %lclickSpamDelay%
return

; Increase current right click spam speed
+Home::
rclickSpamDelay += 100
if (toggleShiftF10 || toggleF10)
	SetTimer, rclickSpam, %lclickSpamDelay%
return

; Decrease current left click spam speed
End::
lclickSpamDelay -= 100
if (toggleShiftF10 || toggleF10)
	SetTimer, lclickSpam, %lclickSpamDelay%
return

; Decrease current right click spam speed
+End::
rclickSpamDelay -= 100
if (toggleShiftF10 || toggleF10)
	SetTimer, rclickSpam, %lclickSpamDelay%
return

; Reset left click spam speed
Pause::
lclickSpamDelay := 300
if (toggleShiftF10 || toggleF10)
	SetTimer, lclickSpam, %lclickSpamDelay%
return

; Reset right click spam speed
+Pause::
rclickSpamDelay := 300
if (toggleShiftF10 || toggleF10)
	SetTimer, rclickSpam, %lclickSpamDelay%
return

; Enter custom spam speeds
!+Pause::
Gui, delayInput:Show
return

; Fetch 
WebRequest(url, method := "GET", HeadersArray := "", body := "", ByRef error := "") {
   Whr := ComObjCreate("WinHttp.WinHttpRequest.5.1")
   Whr.Open(method, url, true)
   for name, value in HeadersArray
      Whr.SetRequestHeader(name, value)
   Whr.Send(body)
   Whr.WaitForResponse()
   status := Whr.status
   if (status != 200)
      error := "HttpRequest error, status: " . status
   Arr := Whr.responseBody
   pData := NumGet(ComObjValue(arr) + 8 + A_PtrSize)
   length := Arr.MaxIndex() + 1
   Return StrGet(pData, length, "UTF-8")
}
DelayDone:
Gui, Submit
lclickSpamDelay := LNewDelay
rclickSpamDelay := RNewDelay

if (toggleShiftF10 || toggleF10) {
	SetTimer, lclickSpam, %lclickSpamDelay%
}
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
lclickSpam:
SendInput, {LButton}
return

; Ultra complex code the likes of which you've never seen: (spam right click)
rclickSpam:
SendInput, {RButton}
return
