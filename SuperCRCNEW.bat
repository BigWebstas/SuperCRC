@echo off
setlocal enabledelayedexpansion
setlocal enableextensions
color 17
mode con: cols=80 lines=40
::Check for XM8 Running
tasklist /fi "imagename eq x.exe" /fi "status eq running"|Findstr /I "X"
If %ErrorLevel%==0 Goto KILL
If %ErrorLevel%==1 Goto starttoolcheck
:KILL
echo Xactimate is Running
echo Killing it in 5 seconds
ping 1.0.0.0 -n 1 -w 5000 >NU
taskkill /F /IM QA.exe >nul 2>&1
taskkill /F /IM X.exe >nul 2>&1
cls
:starttoolcheck
::check for Tools
if exist debugCRC.exe (
	goto toolcheck1
) Else (
	Echo "Debugcrc.exe" is missing
	goto end
)
)
:toolcheck1
if exist Core.sys.dll (
	goto toolcheck2
) Else (
	echo "Core.Sys.dll" is missing
	goto end
)
)
:toolcheck2
if exist Xm8.UI.Debugging.dll (
	goto toolcheckdone
) Else (
	echo "Xm8.UI.Debugging.dll" is missing
	goto end
)
)
:toolcheckdone
::check for XM8
set check32=HKLM\SOFTWARE\Xactware\Versions
reg query %check32% >nul 2>&1
IF !ERRORLEVEL! EQU 1 (
	goto check64
) Else (
	echo Xactimate is installed and running on a 32bit OS
	goto start
)
)
:check64
set check64=HKLM\SOFTWARE\WOW6432Node\Xactware\Versions
reg query %check64% >nul 2>&1
IF !ERRORLEVEL! EQU 1 (
	goto NotInstalled
) Else (
	echo Xactimate is installed and running on a 64bit OS
	goto start
)
)
:start
::Check System Architecture
Set RegQry=HKLM\Hardware\Description\System\CentralProcessor\0
REG Query %RegQry% > checkOS.txt
Find /i "x86" < CheckOS.txt > StringCheck.txt
If %ERRORLEVEL% == 0 (
	Echo Workstation Proc is 32bit only
	goto Start32
) ELSE (
	Echo Workstation Proc is 32/64bit
	goto Start64
)
)
:Start64
::Setup 64bit Xactimate Debug
set arch=64
for /f "tokens=*" %%a in ('debugcrc') do (set CRC=%%a)
echo The CRC for today is %CRC%
set n=0
::Creates a list with strings in registry key
for /f "skip=1" %%V in ('reg query HKLM\SOFTWARE\Wow6432Node\Xactware\Versions') do (
	set vector[!n!]=%%V
	set /A n+=1
)
)
for /l %%i in (0, 1, 3) do (
	IF !vector[%%i]! EQU 26.600 (
		set ver=XactimateSF27
		reg add HKLM\SOFTWARE\WOW6432Node\Xactware\Xactimatesf27\Debugging /v CRC /t REG_SZ /d %CRC% /f>Nul
		reg add HKLM\SOFTWARE\WOW6432Node\Xactware\Xactimatesf27\Debugging /v DecryptOption /t REG_SZ /d 1 /f>Nul
		reg add HKLM\SOFTWARE\WOW6432Node\Xactware\Xactimatesf27\Debugging /v DumpSmartObjects /t REG_SZ /d 1 /f>Nul
		reg add HKLM\SOFTWARE\WOW6432Node\Xactware\Xactimatesf27\Debugging /v EditFeatureFlags /t REG_SZ /d 1 /F>Nul
		reg add HKLM\SOFTWARE\WOW6432Node\Xactware\Xactimatesf27\Debugging /v SetAvail /t REG_SZ /d 1 /f>Nul
		reg add HKLM\SOFTWARE\WOW6432Node\Xactware\Xactimatesf27\Debugging /v TranslatePendingIndicator /t REG_SZ /d 1 /f>Nul
		reg add HKLM\SOFTWARE\WOW6432Node\Xactware\Xactimatesf27\Debugging /v AllowRoofImport /t REG_SZ /d 1 /f>Nul
		reg add HKLM\SOFTWARE\WOW6432Node\Xactware\Xactimatesf27\Debugging /v RoofSingleLevelIntersect /t REG_SZ /d 1 /f>Nul
		xcopy "Xm8.UI.Debugging.dll" "%PROGRAMFILES(X86)%\Xactware\Xactimatesf27\CORE" /Y
		echo Added Registry for 26.600.
	) ELSE (
		echo Checking Registry for 26.600.
)
)
for /l %%i in (0, 1, 3) do (
	IF !vector[%%i]! EQU 27.000 (
		set ver=Xactimate27
		reg add HKLM\SOFTWARE\WOW6432Node\Xactware\Xactimate27\Debugging /v CRC /t REG_SZ /d %CRC% /f>Nul
		reg add HKLM\SOFTWARE\WOW6432Node\Xactware\Xactimate27\Debugging /v DecryptOption /t REG_SZ /d 1 /f>Nul
		reg add HKLM\SOFTWARE\WOW6432Node\Xactware\Xactimate27\Debugging /v DumpSmartObjects /t REG_SZ /d 1 /f>Nul
		reg add HKLM\SOFTWARE\WOW6432Node\Xactware\Xactimate27\Debugging /v EditFeatureFlags /t REG_SZ /d 1 /F>Nul
		reg add HKLM\SOFTWARE\WOW6432Node\Xactware\Xactimate27\Debugging /v SetAvail /t REG_SZ /d 1 /f>Nul
		reg add HKLM\SOFTWARE\WOW6432Node\Xactware\Xactimate27\Debugging /v TranslatePendingIndicator /t REG_SZ /d 1 /f>Nul
		reg add HKLM\SOFTWARE\WOW6432Node\Xactware\Xactimate27\Debugging /v AllowRoofImport /t REG_SZ /d 1 /f>Nul
		reg add HKLM\SOFTWARE\WOW6432Node\Xactware\Xactimate27\Debugging /v RoofSingleLevelIntersect /t REG_SZ /d 1 /f>Nul
		xcopy "Xm8.UI.Debugging.dll" "%PROGRAMFILES(X86)%\Xactware\Xactimate27\CORE" /Y
		echo Added Registry for 27.000.
	) ELSE (
		echo Checking Registry for 27.000.
)
)
for /l %%i in (0, 1, 3) do (
	IF !vector[%%i]! EQU 28.000 (
		set ver=Xactimate28
		reg add HKLM\SOFTWARE\WOW6432Node\Xactware\Xactimate28\Debugging /v CRC /t REG_SZ /d %CRC% /f>Nul
		reg add HKLM\SOFTWARE\WOW6432Node\Xactware\Xactimate28\Debugging /v DecryptOption /t REG_SZ /d 1 /f>Nul
		reg add HKLM\SOFTWARE\WOW6432Node\Xactware\Xactimate28\Debugging /v DumpSmartObjects /t REG_SZ /d 1 /f>Nul
		reg add HKLM\SOFTWARE\WOW6432Node\Xactware\Xactimate28\Debugging /v EditFeatureFlags /t REG_SZ /d 1 /F>Nul
		reg add HKLM\SOFTWARE\WOW6432Node\Xactware\Xactimate28\Debugging /v SetAvail /t REG_SZ /d 1 /f>Nul
		reg add HKLM\SOFTWARE\WOW6432Node\Xactware\Xactimate28\Debugging /v TranslatePendingIndicator /t REG_SZ /d 1 /f>Nul
		reg add HKLM\SOFTWARE\WOW6432Node\Xactware\Xactimate28\Debugging /v AllowRoofImport /t REG_SZ /d 1 /f>Nul
		reg add HKLM\SOFTWARE\WOW6432Node\Xactware\Xactimate28\Debugging /v RoofSingleLevelIntersect /t REG_SZ /d 1 /f>Nul
		reg add HKLM\SOFTWARE\WOW6432Node\Xactware\Xactimate28\Debugging /v ECSTest /t REG_SZ /d 1 /f>Nul
		xcopy "Xm8.UI.Debugging.dll" "%PROGRAMFILES(X86)%\Xactware\Xactimate28\CORE" /Y
		echo Added Registry for 28.000.
	) ELSE (
		echo Checking Registry for 28.000.
)
)
for /l %%i in (0, 1, 3) do (
	IF !vector[%%i]! EQU 28.800 (
		set ver=Xactimate.800.28
		reg add HKLM\SOFTWARE\WOW6432Node\Xactware\Xactimate.800.28\Debugging /v CRC /t REG_SZ /d %CRC% /f>Nul
		reg add HKLM\SOFTWARE\WOW6432Node\Xactware\Xactimate.800.28\Debugging /v DecryptOption /t REG_SZ /d 1 /f>Nul
		reg add HKLM\SOFTWARE\WOW6432Node\Xactware\Xactimate.800.28\Debugging /v DumpSmartObjects /t REG_SZ /d 1 /f>Nul
		reg add HKLM\SOFTWARE\WOW6432Node\Xactware\Xactimate.800.28\Debugging /v EditFeatureFlags /t REG_SZ /d 1 /F>Nul
		reg add HKLM\SOFTWARE\WOW6432Node\Xactware\Xactimate.800.28\Debugging /v SetAvail /t REG_SZ /d 1 /f>Nul
		reg add HKLM\SOFTWARE\WOW6432Node\Xactware\Xactimate.800.28\Debugging /v TranslatePendingIndicator /t REG_SZ /d 1 /f>Nul
		reg add HKLM\SOFTWARE\WOW6432Node\Xactware\Xactimate.800.28\Debugging /v AllowRoofImport /t REG_SZ /d 1 /f>Nul
		reg add HKLM\SOFTWARE\WOW6432Node\Xactware\Xactimate.800.28\Debugging /v RoofSingleLevelIntersect /t REG_SZ /d 1 /f>Nul
		reg add HKLM\SOFTWARE\WOW6432Node\Xactware\Xactimate.800.28\Debugging /v ECSTest /t REG_SZ /d 1 /f>Nul
		xcopy "Xm8.UI.Debugging.dll" "%PROGRAMFILES(X86)%\Xactware\Xactimate.800.28\CORE" /Y
		echo Added Registry for 28.800.
	) ELSE (
		echo Checking Registry for 28.800.
)
)
for /l %%i in (0, 1, 3) do (
	IF !vector[%%i]! EQU 29.000 (
		set ver=Xactimate29
		reg add HKLM\SOFTWARE\WOW6432Node\Xactware\Xactimate29\Debugging /v CRC /t REG_SZ /d %CRC% /f>Nul
		reg add HKLM\SOFTWARE\WOW6432Node\Xactware\Xactimate29\Debugging /v DecryptOption /t REG_SZ /d 1 /f>Nul
		reg add HKLM\SOFTWARE\WOW6432Node\Xactware\Xactimate29\Debugging /v DumpSmartObjects /t REG_SZ /d 1 /f>Nul
		reg add HKLM\SOFTWARE\WOW6432Node\Xactware\Xactimate29\Debugging /v EditFeatureFlags /t REG_SZ /d 1 /F>Nul
		reg add HKLM\SOFTWARE\WOW6432Node\Xactware\Xactimate29\Debugging /v SetAvail /t REG_SZ /d 1 /f>Nul
		reg add HKLM\SOFTWARE\WOW6432Node\Xactware\Xactimate29\Debugging /v TranslatePendingIndicator /t REG_SZ /d 1 /f>Nul
		reg add HKLM\SOFTWARE\WOW6432Node\Xactware\Xactimate29\Debugging /v AllowRoofImport /t REG_SZ /d 1 /f>Nul
		reg add HKLM\SOFTWARE\WOW6432Node\Xactware\Xactimate29\Debugging /v RoofSingleLevelIntersect /t REG_SZ /d 1 /f>Nul
		reg add HKLM\SOFTWARE\WOW6432Node\Xactware\Xactimate29\Debugging /v ECSTest /t REG_SZ /d 1 /f>Nul
		xcopy "Xm8.UI.Debugging.dll" "%PROGRAMFILES(X86)%\Xactware\Xactimate29\CORE" /Y
		echo Added Registry for 29.000.
	) ELSE (
		echo Checking Registry for 29.000.
)
)
goto end
:Start32
::Setup 32bit Xactimate debug
set arch=32
for /f "tokens=*" %%a in ('debugcrc') do (set CRC=%%a)
echo The CRC for today is %CRC%
for /l %%i in (0, 1, 3) do (
	IF !vector[%%i]! EQU 26.600 (
		set ver=XactimateSF27
		reg add HKLM\SOFTWARE\Xactware\Xactimatesf27\Debugging /v CRC /t REG_SZ /d %CRC% /f>Nul
		reg add HKLM\SOFTWARE\Xactware\Xactimatesf27\Debugging /v DecryptOption /t REG_SZ /d 1 /f>Nul
		reg add HKLM\SOFTWARE\Xactware\Xactimatesf27\Debugging /v DumpSmartObjects /t REG_SZ /d 1 /f>Nul
		reg add HKLM\SOFTWARE\Xactware\Xactimatesf27\Debugging /v EditFeatureFlags /t REG_SZ /d 1 /F>Nul
		reg add HKLM\SOFTWARE\Xactware\Xactimatesf27\Debugging /v SetAvail /t REG_SZ /d 1 /f>Nul
		reg add HKLM\SOFTWARE\Xactware\Xactimatesf27\Debugging /v TranslatePendingIndicator /t REG_SZ /d 1 /f>Nul
		reg add HKLM\SOFTWARE\Xactware\Xactimatesf27\Debugging /v AllowRoofImport /t REG_SZ /d 1 /f>Nul
		reg add HKLM\SOFTWARE\Xactware\Xactimatesf27\Debugging /v RoofSingleLevelIntersect /t REG_SZ /d 1 /f>Nul
		copy "Xm8.UI.Debugging.dll" "%PROGRAMFILES%\Xactware\XactimateSF27\CORE" /Y
		echo Added Registry for 26.600.
	) ELSE (
		echo Checking Registry for 26.600.
)
)
for /l %%i in (0, 1, 3) do (
	IF !vector[%%i]! EQU 27.000 (
		set ver=Xactimate27
		reg add HKLM\SOFTWARE\Xactware\Xactimate27\Debugging /v CRC /t REG_SZ /d %CRC% /f>Nul
		reg add HKLM\SOFTWARE\Xactware\Xactimate27\Debugging /v DecryptOption /t REG_SZ /d 1 /f>Nul
		reg add HKLM\SOFTWARE\Xactware\Xactimate27\Debugging /v DumpSmartObjects /t REG_SZ /d 1 /f>Nul
		reg add HKLM\SOFTWARE\Xactware\Xactimate27\Debugging /v EditFeatureFlags /t REG_SZ /d 1 /f>Nul
		reg add HKLM\SOFTWARE\Xactware\Xactimate27\Debugging /v SetAvail /t REG_SZ /d 1 /f>Nul
		reg add HKLM\SOFTWARE\Xactware\Xactimate27\Debugging /v TranslatePendingIndicator /t REG_SZ /d 1 /f>Nul
		reg add HKLM\SOFTWARE\Xactware\Xactimate27\Debugging /v AllowRoofImport /t REG_SZ /d 1 /f>Nul
		reg add HKLM\SOFTWARE\Xactware\Xactimate27\Debugging /v RoofSingleLevelIntersect /t REG_SZ /d 1 /f>Nul
		copy "Xm8.UI.Debugging.dll" "%PROGRAMFILES%\Xactware\Xactimate27\CORE" /Y
		echo Added Registry for 27.000.
	) ELSE (
		echo Checking Registry for 27.000.
)
)
for /l %%i in (0, 1, 3) do (
	IF !vector[%%i]! EQU 28.000 (
		set ver=Xactimate28
		reg add HKLM\SOFTWARE\Xactware\Xactimate28\Debugging /v CRC /t REG_SZ /d %CRC% /f>Nul
		reg add HKLM\SOFTWARE\Xactware\Xactimate28\Debugging /v DecryptOption /t REG_SZ /d 1 /f>Nul
		reg add HKLM\SOFTWARE\Xactware\Xactimate28\Debugging /v DumpSmartObjects /t REG_SZ /d 1 /f>Nul
		reg add HKLM\SOFTWARE\Xactware\Xactimate28\Debugging /v EditFeatureFlags /t REG_SZ /d 1 /F>Nul
		reg add HKLM\SOFTWARE\Xactware\Xactimate28\Debugging /v SetAvail /t REG_SZ /d 1 /f>Nul
		reg add HKLM\SOFTWARE\Xactware\Xactimate28\Debugging /v TranslatePendingIndicator /t REG_SZ /d 1 /f>Nul
		reg add HKLM\SOFTWARE\Xactware\Xactimate28\Debugging /v AllowRoofImport /t REG_SZ /d 1 /f>Nul
		reg add HKLM\SOFTWARE\Xactware\Xactimate28\Debugging /v RoofSingleLevelIntersect /t REG_SZ /d 1 /f>Nul
		reg add HKLM\SOFTWARE\Xactware\Xactimate28\Debugging /v ECSTest /t REG_SZ /d 1 /f>Nul
		copy "Xm8.UI.Debugging.dll" "%PROGRAMFILES%\Xactware\Xactimate28\CORE" /Y
		echo Added Registry for 28.000.
	) ELSE (
		echo Checking Registry for 28.000.
)
)
for /l %%i in (0, 1, 3) do (
	IF !vector[%%i]! EQU 28.800 (
		set ver=Xactimate.800.28
		reg add HKLM\SOFTWARE\WOW6432Node\Xactware\Xactimate.800.28\Debugging /v CRC /t REG_SZ /d %CRC% /f>Nul
		reg add HKLM\SOFTWARE\WOW6432Node\Xactware\Xactimate.800.28\Debugging /v DecryptOption /t REG_SZ /d 1 /f>Nul
		reg add HKLM\SOFTWARE\WOW6432Node\Xactware\Xactimate.800.28\Debugging /v DumpSmartObjects /t REG_SZ /d 1 /f>Nul
		reg add HKLM\SOFTWARE\WOW6432Node\Xactware\Xactimate.800.28\Debugging /v EditFeatureFlags /t REG_SZ /d 1 /F>Nul
		reg add HKLM\SOFTWARE\WOW6432Node\Xactware\Xactimate.800.28\Debugging /v SetAvail /t REG_SZ /d 1 /f>Nul
		reg add HKLM\SOFTWARE\WOW6432Node\Xactware\Xactimate.800.28\Debugging /v TranslatePendingIndicator /t REG_SZ /d 1 /f>Nul
		reg add HKLM\SOFTWARE\WOW6432Node\Xactware\Xactimate.800.28\Debugging /v AllowRoofImport /t REG_SZ /d 1 /f>Nul
		reg add HKLM\SOFTWARE\WOW6432Node\Xactware\Xactimate.800.28\Debugging /v RoofSingleLevelIntersect /t REG_SZ /d 1 /f>Nul
		reg add HKLM\SOFTWARE\WOW6432Node\Xactware\Xactimate.800.28\Debugging /v ECSTest /t REG_SZ /d 1 /f>Nul
		xcopy "Xm8.UI.Debugging.dll" "%PROGRAMFILES%\Xactware\Xactimate.800.28\CORE" /Y
		echo Added Registry for 28.800.
	) ELSE (
		echo Checking Registry for 28.800.
)
)
for /l %%i in (0, 1, 3) do (
	IF !vector[%%i]! EQU 29.000 (
		set ver=Xactimate29
		reg add HKLM\SOFTWARE\Xactware\Xactimate29\Debugging /v CRC /t REG_SZ /d %CRC% /f>Nul
		reg add HKLM\SOFTWARE\Xactware\Xactimate29\Debugging /v DecryptOption /t REG_SZ /d 1 /f>Nul
		reg add HKLM\SOFTWARE\Xactware\Xactimate29\Debugging /v DumpSmartObjects /t REG_SZ /d 1 /f>Nul
		reg add HKLM\SOFTWARE\Xactware\Xactimate29\Debugging /v EditFeatureFlags /t REG_SZ /d 1 /F>Nul
		reg add HKLM\SOFTWARE\Xactware\Xactimate29\Debugging /v SetAvail /t REG_SZ /d 1 /f>Nul
		reg add HKLM\SOFTWARE\Xactware\Xactimate29\Debugging /v TranslatePendingIndicator /t REG_SZ /d 1 /f>Nul
		reg add HKLM\SOFTWARE\Xactware\Xactimate29\Debugging /v AllowRoofImport /t REG_SZ /d 1 /f>Nul
		reg add HKLM\SOFTWARE\Xactware\Xactimate29\Debugging /v RoofSingleLevelIntersect /t REG_SZ /d 1 /f>Nul
		reg add HKLM\SOFTWARE\Xactware\Xactimate29\Debugging /v ECSTest /t REG_SZ /d 1 /f>Nul
		copy "Xm8.UI.Debugging.dll" "%PROGRAMFILES%\Xactware\Xactimate29\CORE" /Y
		echo Added Registry for 29.000.
	) ELSE (
		echo Checking Registry for 29.000.
)
)
goto end
:end
echo **************************************
echo ****************      ****************
echo ************* C          *************
echo ***********     O          ***********
echo *********         M          *********
echo ********            P         ********
echo *******               L        *******
echo ******                  E       ******
echo *****	                  T      *****
echo ****    ASCII ART WIN       E     ****
echo **************************************			
ping 1.0.0.0 -n 1 -w 5000 >NU
if %arch% EQU 64 (
	::Removing start because it can't open 2 versions at the same time.
	::start "Xactimate" /D "%PROGRAMFILES(X86)%\Xactware\%ver%\CORE\" x.exe
	goto cleanup
) else (
	::Removing start because it can't open 2 versions at the same time.
	::start "Xactimate" /D "%PROGRAMFILES%\Xactware\%ver%\CORE\" x.exe
	goto cleanup
)
)
:NotInstalled
Echo Xactimate is not installed.
pause
exit
:cleanup
del NU
del checkOS.txt
del StringCheck.txt
exit
exit