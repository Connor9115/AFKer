#SingleInstance Force
#NoEnv
SendMode Input
SetWorkingDir %A_ScriptDir%
DetectHiddenWindows, On
SetTitleMatchMode 2

version = %1%
MsgBox, %version%

; Repo vars
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
		WinClose, AFKer.exe
		UrlDownloadToFile, https://github.com/Connor9115/AFKer/releases/download/%latestVersion%/AFKer.exe, AFKer.exe
		MsgBox, AFKer has been updated and will now restart.
		Run, AFKer.exe
	}
}

; Fetch latest version number
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
