@echo off
SETLOCAL DisableDelayedExpansion
:: If running from command line, the usage format is below.
:: Note that "<BatchOutputFolder>" "<IndSubDir>" "<AccuracyFilter>" "<FixFilter>" are all optional
::   GPMD2CSV.bat "<MP4 File from Directory to Process>" "<BatchOutputFolder>" "<IndSubDir>" "<AccuracyFilter>" "<FixFilter>"

Set SourceScriptDirectory=%~dp0

CD "%~dp1"

:: Sets up input directory based on if a file or folder was specified as input
IF EXIST %1\* ( Set SearchType=%1\*.MP4
	Set SourceFile="%%~f"
) ELSE (
	Set SearchType=*.MP4
	Set SourceFile="%~dp1%%~f"
)


:: Imports option to make an output folder
:CheckVar2
IF NOT [%2]==[] GOTO SetupVar2
GOTO RunIt
:: Properly configures var output to pass
:SetupVar2
Set BatchOutputFolder=%2
SET BatchOutputFolder=%BatchOutputFolder:"=%
SET BatchOutputFolder="%BatchOutputFolder%"
GOTO CheckVar3

:: Imports an option to change the individual subdirectory for each file setting
:CheckVar3
IF NOT [%3]==[] GOTO SetupVar3
GOTO RunIt
:: Properly configures var output to pass
:SetupVar3
Set IndSubDir=%3
SET IndSubDir=%IndSubDir:"=%
SET IndSubDir="%IndSubDir%"
GoTO CheckVar4

:: Imports an option to change the accuracy filter
:CheckVar4
IF NOT [%4]==[] GOTO SetupVar4
GOTO RunIt
:: Properly configures var output to pass
:SetupVar4
Set AccuracyFilter=%4
SET AccuracyFilter=%AccuracyFilter:"=%
SET AccuracyFilter="%AccuracyFilter%"
GoTO CheckVar5

:: Imports an option to change the fix filter
:CheckVar5
IF NOT [%5]==[] GOTO SetupVar5
GOTO RunIt
:: Properly configures var output to pass
:SetupVar5
Set FixFilter=%5
SET FixFilter=%FixFilter:"=%
SET FixFilter="%FixFilter%"
GOTO RunIt

:: Runs the final script to pass settings and files to GPMD2CSV.bat
:RunIt
For %%f in (%SearchType%) do (
	CLS
	ECHO.
	ECHO **************************************************
	ECHO **************** Processing file: ****************
	ECHO "%~dp1%%~f"
	ECHO **************************************************
CALL "%~dp0\GPMD2CSV.bat" %SourceFile% %BatchOutputFolder% %IndSubDir% %AccuracyFilter% %FixFilter%
)
