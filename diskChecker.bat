
:: 1909 error --> locked account
:: 89 error --> pasword expired
:: 85 error --> resource in use
::1219 error--> multiple connection with another credentials

@echo off


SET ipWarsawDepartment = x.x.x.x
SET ipSupervisorProjects= x.x.x.y
SET ipPoznanDepartment= x.x.z.z
call :MsgBox "Do you work in a branch in Warsaw?" "VBYESNOCANCEL+VBQuestion" "Disk connection checker"
if %errorlevel%==6 GOTO Warsaw
if %errorlevel%==7 GOTO PoznanDepartment
if %errorlevel%==2 GOTO cancel

:againChoose
call :MsgBox "Do you work in a branch in Warsaw?" "VBYESNOCANCEL+VBQuestion" "Disk connection checker"
if %errorlevel%==6 GOTO Warsaw
if %errorlevel%==7 GOTO PoznanDepartment
if %errorlevel%==2 GOTO cancel

:alredyInUse
	call :MsgBox  "Restart the computer. The resource being used." "VBOKOnly+VBQuestion" "Disk connection checker. "
	if %errorlevel%==6 timeout 15 GOTO restartComputer
:invalidPassword
	call :MsgBox  "Incorrect password or username." "VBOKOnly+VBQuestion" "Disk connection checker. "
	if %errorlevel%==6 timeout 15 GOTO againChoose
:lockedAccount
	call :MsgBox  "Too many login attempts. The account has been blocked. Wait 15 minutes and try again." "VBOKOnly+VBQuestion" "Disk connection checker. "
	if %errorlevel%==6 timeout 15 GOTO againChoose
:multipleConnections
	call :MsgBox  "You log in to a known resource using other credentials." "VBOKOnly+VBQuestion" "Disk connection checker. "
	if %errorlevel%==6 timeout 15 GOTO againChoose
:resourceConnectredByAnotherCredentials
	call :MsgBox  "The resource connects with other credentials. Delete the wrong credentials from the credentials manager and restart the process." "VBOKOnly+VBQuestion" "Disk connection checker. "
	if %errorlevel%==6 timeout 15 GOTO cancel
:unespectedError
	call :MsgBox  "Unidentified error, take a screen and report it to IT." "VBOKOnly+VBQuestion" "Disk connection checker. "
	if %errorlevel%==6 timeout 15 GOTO cancel
:restartComputer
	shutdown /r -t 60
	pasue

	:PoznanDepartment
		call :MsgBox "Work in a branch in Poznan?" "VBYESNOCANCEL+VBQuestion" "Disk connection checker"
		if %errorlevel%==6 GOTO checkConnectionPoznanDepartment
		if %errorlevel%==7 GOTO noAccess
		if %errorlevel%==2 GOTO cancel

			:checkConnectionPoznanDepartment
				ping -n 1 $ipPoznanDepartmentDepartment | find "TTL=" >nul
				if errorlevel 1 goto checkUserCredentialPoznanDepartment
				else GOTO notPingingPoznanDepartment
				
				:checkUserCredentialPoznanDepartment
				net use Y: /delete
				net use Y: \\x.x.x.x\HydePark > %temp%\netUseResult.txt 2^>^&1
				findstr /R /C:"successfully." %temp%\netUseResult.txt
				if %ERRORLEVEL% EQU 0 goto pingingPoznanDepartment
				findstr /R /C:"error 85" %temp%\netUseResult.txt
				if %ERRORLEVEL% EQU 0 goto alredyInUse 
				findstr /R /C:"error 86" %temp%\netUseResult.txt
				if %ERRORLEVEL% EQU 0 goto invalidPassword 
				findstr /R /C:"error 1909" %temp%\netUseResult.txt
				if  %ERRORLEVEL% EQU 0 goto lockedAccount 
				findstr /R /C:"error 1219" %temp%\netUseResult.txt
				if  %ERRORLEVEL% EQU 0 goto resourceConnectredByAnotherCredentials
					else GOTO unespectedError
			

				:notPingingPoznanDepartment
					call :MsgBox  "No connection to the server. \ n Check that the network cable is connected and that the computer is connected to the correct network." "VBOKOnly+VBQuestion" "Disk connection checker. "
					if %errorlevel%==6 GOTO checkConnectionPoznanDepartment	
		 
				 :pingingPoznanDepartment
					call :MsgBox "Connection to server x.x.z.z was established. Do you want to connect drives automatically?" "VBYESNO+VBQuestion" "Disk connection checker"
					if %errorlevel%==6 GOTO mapPoznanDepartment
					if %errorlevel%==7 GOTO manualMapPoznanDepartment


					:mapPoznanDepartment
						net use * /delete
						net use H: \\x.x.x.x\Private  /persistent:yes /SAVECRED
						net use L: \\x.x.x.x\Media  /persistent:yes /SAVECRED
						net use M: \\x.x.x.x\Library  /persistent:yes /SAVECRED
						net use o: \\x.x.x.x\Administration  /persistent:yes /SAVECRED
						net use p: \\x.x.z.z\PoznanDepartment  /persistent:yes /SAVECRED
						net use R: \\x.x.z.z\PoznanAdministration  /persistent:yes /SAVECRED
						net use Z: \\x.x.x.x\Prof  /persistent:yes /SAVECRED
						net use T: \\x.x.x.x\Common  /persistent:yes /SAVECRED
						net use Y: \\x.x.x.x\HydePark  /persistent:yes /SAVECRED 
					GOTO workingInSupervisorProjects

					:manualMapPoznanDepartment
						explorer.exe "\\x.x.z.z"
						explorer.exe "\\x.x.x.x"
						call :MsgBox  "Right-click on the selected resource, then click 'Map network drive' and assign the appropriate letter" "VBOKOnly+VBQuestion" "Disk connection checker"
					goto checkDiskLetterPoznanDepartment
						:checkDiskLetterPoznanDepartment
							call :MsgBox  "Drives are attached in the order as per the procedures?" "VBYESNO+VBQuestion" "Disk connection checker"
							if %errorlevel%==6 GOTO workingInSupervisorProjects
							if %errorlevel%==7 GOTO mapPoznanDepartment
			:noAccess
				call :MsgBox  "No entitlements for other branches" "VBOKOnly+VBQuestion" "Disk connection checker. "
				if %errorlevel%==6 timeout 15 GOTO checkConnectionRemotly

	:Warsaw
		call :MsgBox "Do you work in the office?" "VBYESNOCANCEL+VBQuestion" "Disk connection checker"
		if %errorlevel%==6 GOTO checkConnectionWarsaw
		if %errorlevel%==7 GOTO checkConnectionRemotly
		if %errorlevel%==2 GOTO cancel
		::OK would be: if %errorlevel%==1 goto OK

		:checkConnectionWarsaw
			ping -n 1 $ipWarsawDepartment | find "TTL=" >nul
			if errorlevel 1 goto checkUserCredentialWarsaw
			else GOTO notPinging
			
			:checkUserCredentialWarsaw
				net use Y: /delete
				net use Y: \\x.x.x.x\HydePark > %temp%\netUseResult.txt 2^>^&1
				findstr /R /C:"successfully." %temp%\netUseResult.txt
				if %ERRORLEVEL% EQU 0 goto pingingPoznanDepartment
				findstr /R /C:"error 85" %temp%\netUseResult.txt
				if %ERRORLEVEL% EQU 0 goto alredyInUse 
				findstr /R /C:"error 86" %temp%\netUseResult.txt
				if %ERRORLEVEL% EQU 0 goto invalidPassword 
				findstr /R /C:"error 1909" %temp%\netUseResult.txt
				if  %ERRORLEVEL% EQU 0 goto lockedAccount 
				findstr /R /C:"error 1219" %temp%\netUseResult.txt
				if  %ERRORLEVEL% EQU 0 goto resourceConnectredByAnotherCredentials
					else GOTO unespectedError
 
			:pinging
			call :MsgBox "Connection to server x.x.x.x. Do you want to connect drives automatically?" "VBYESNO+VBQuestion" "Disk connection checker"
			if %errorlevel%==6 GOTO map
			if %errorlevel%==7 GOTO manualMap
			
				:map
					net use * /delete /y
					net use H: \\x.x.x.x\Private /persistent:yes /SAVECRED
					net use I: \\x.x.x.x\ISO /persistent:yes /SAVECRED
					net use L: \\x.x.x.x\Media /persistent:yes /SAVECRED
					net use M: \\x.x.x.x\Library /persistent:yes /SAVECRED
					net use o: \\x.x.x.x\Administration /persistent:yes /SAVECRED
					net use p: \\x.x.x.x\Common /persistent:yes /SAVECRED
					net use R: \\x.x.x.x\Prof /persistent:yes /SAVECRED
					net use T: \\x.x.x.x\Apps /persistent:yes /SAVECRED
					net use Y: \\x.x.x.x\HydePark /persistent:yes /SAVECRED
				GOTO workingInSupervisorProjects

				:manualMap
					explorer.exe "\\x.x.x.x"
					call :MsgBox  "Right-click on the selected resource, then click 'Map network drive' and assign the appropriate letter" "VBOKOnly+VBQuestion" "Disk connection checker"
				goto checkDiskLetter

					:checkDiskLetter
						call :MsgBox  "Drives are attached in the order as per the procedures?" "VBYESNO+VBQuestion" "Disk connection checker"
						if %errorlevel%==6 GOTO workingInSupervisorProjects
						if %errorlevel%==7 GOTO map

			:notPinging
				call :MsgBox  "No connection to the server. \ n Check that the network cable is connected and that the computer is connected to the correct network." "VBOKOnly+VBQuestion" "Disk connection checker. "
				if %errorlevel%==6 GOTO checkConnectionWarsaw

	:checkConnectionRemotly
		ping -n 1 $ipWarsawDepartment | find "TTL=" >nul
		if errorlevel 1 goto pinging
		else GOTO notPingingRemotly
	
		:notPingingRemotly
			call :MsgBox  "No connection to the server. \ n Check the VPN connection." "VBOKOnly+VBQuestion" "Disk connection checker. "
			if %errorlevel%==6 timeout 15 GOTO checkConnectionRemotly



:workingInSupervisorProjects
	call :MsgBox "Are you working on a supervisory contract?" "VBYESNO+VBQuestion" "Disk connection checker"
	if %errorlevel%==6 GOTO checkConnectionSupervisorProjects
	if %errorlevel%==7 GOTO done

	:checkConnectionSupervisorProjects
		ping -n 1 $ipSupervisorProjects | find "TTL=" >nul
		if errorlevel 1 goto pingingSupervisorProjects
		else GOTO notPingingSupervisorProjects
 
		:pingingSupervisorProjects
			call :MsgBox "A connection was made to the server. Do you want to connect drives automatically?" "VBYESNO+VBQuestion" "Disk connection checker"
			if %errorlevel%==6 GOTO mapSupervisorProjects
			if %errorlevel%==7 GOTO manualMapSupervisorProjects
			
			:mapSupervisorProjects
				net use A: /delete
				net use W: /delete
				net use A: \\x.x.x.y\AProjcet
				net use W: \\x.x.x.y\WProject
			GOTO done
			
			:manualMapSupervisorProjects
				explorer.exe "\\x.x.x.y"
				call :MsgBox  "Right-click on the selected resource, then click 'Map network drive' and assign the appropriate letter" "VBOKOnly+VBQuestion" "Disk connection checker"
				goto checkDiskLetterSupervisorProjects
				
				:checkDiskLetterSupervisorProjects
						call :MsgBox  "Drives are attached in the order as per the procedures?" "VBYESNO+VBQuestion" "Disk connection checker"
						if %errorlevel%==6 GOTO done
						if %errorlevel%==7 GOTO mapSupervisorProjects
			
		:notPingingSupervisorProjects
			call :MsgBox  "No connection to the server. \ n Check that the network cable is connected and that the computer is connected to the correct network." "VBOKOnly+VBQuestion" "Disk connection checker. "
			if %errorlevel%==6 GOTO checkConnectionSupervisorProjects

:done
	call :MsgBox  "The drives are connected. Thank you. Have fun at work" "VBOKOnly+VBQuestion" "Disk connection checker." OKOnly
exit

:cancel

echo You Clicked on Cancel

timeout 5
exit


:MsgBox prompt type title
    setlocal enableextensions
    set "tempFile=%temp%\%~nx0.%random%%random%%random%vbs.tmp"
    >"%tempFile%" echo(WScript.Quit msgBox("%~1",%~2,"%~3") & cscript //nologo //e:vbscript "%tempFile%"
    set "exitCode=%errorlevel%" & del "%tempFile%" >nul 2>nul
    endlocal & exit /b %exitCode%