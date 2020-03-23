@ECHO OFF
SETLOCAL DisableDelayedExpansion
:: If running from command line, the usage format is below.
:: Note that "<BatchOutputFolder>" "<IndSubDir>" "<AccuracyFilter>" "<FixFilter>" are all optional
:: GPMD2CSV.bat "<MP4 Input File>" "<BatchOutputFolder>" "<IndSubDir>" "<AccuracyFilter>" "<FixFilter>"

:: Name of the folder that is created to output to (Optional)
:: Default=GoPro Metadata Extract
SET BatchOutputFolder=GoPro Metadata Extract

:: Make Individual Subdirectories FOR each file? Enter in Yes or No
:: Default=Yes
SET IndSubDir=Yes

:: Choose GPS accuracy filter. FOR example 500 (high accuracy) or 10000 (very low accuracy)
:: If this script is ran with a second command line argument, this setting is overriden.
:: Default=1000
SET AccuracyFilter=1000

:: Choose GPS fix filter. 3 (3D Fix, best case scenario), 2 (2D fix) or 0 (no fix, but there might still be some useful data)
:: If this script is ran with a third command line argument, this setting is overriden.
::Default=3
SET FixFilter=3

:: ==========================================
:: You shouldn't need to edit below this line
::===========================================

:: IF no source file, quit
IF [%1]==[] GOTO :eof

:: Imports option to make an output folder
IF NOT [%2]==[] Set BatchOutputFolder=%2

:: Imports an option to change the individual subdirectory for each file setting
IF NOT [%3]==[] Set IndSubDir=%3

:: Imports an option to change the accuracy filter
IF NOT [%4]==[] Set AccuracyFilter=%4

:: Imports an option to change the fix filter
IF NOT [%5]==[] Set FixFilter=%5

:: Clean up Vars with quotes
IF NOT [%2]==[] Set BatchOutputFolder=%BatchOutputFolder:"=%
IF NOT [%3]==[] Set IndSubDir=%IndSubDir:"=%
IF NOT [%4]==[] Set SET AccuracyFilter=%AccuracyFilter:"=%
IF NOT [%5]==[] Set FixFilter=%FixFilter:"=%

:: Check if the user would like Subdirectories FOR export files
:IndSubDirCheck
IF '%IndSubDir%'=='No' GOTO IndSubDirNo
IF '%IndSubDir%'=='no' GOTO IndSubDirNo
IF '%IndSubDir%'=='N' GOTO IndSubDirNo
IF '%IndSubDir%'=='n' GOTO IndSubDirNo
GOTO IndSubDirYes

:: Sets var IndSubDir format to Yes to enable subdirectories
:IndSubDirYes
SET IndSubDir=Yes
GOTO RunIt

:: Sets var IndSubDir format to No to disable subdirectories
:IndSubDirNo
SET IndSubDir=No
GOTO RunIt

:: Collection of var settings complete, run the main script
:RunIt
:: Set some defaults (Working directory, script directory).
CD "%~dp1"
SET ScriptDir=%~dp0

:: Check if the user wants the output files in a subdirectory and if yes, make the folder
IF '"%BatchOutputFolder%"'=='' (
	SET OutputDir=%~dp1
) Else (
	ECHO %BatchOutputFolder%
	SET BatchOutputFolder=%~dp1\%BatchOutputFolder%
	MKDIR "%~dp1\%BatchOutputFolder%"
	SET OutputDir=%~dp1\%BatchOutputFolder%
)

:: Check if the user wants the output files in nested individual subdirectories and if yes, make the folder
:: Also checks if the last output file (.gpx) exists.
:: If so, assumes the file has already been processed, and the script exits.
IF '%IndSubDir%'=='Yes' (
	MKDIR "%OutputDir%\%~n1"
	SET OutputDir=%OutputDir%\%~n1
	IF EXIST "%OutputDir%\%~n1\%~n1.gpx" GOTO :eof
) Else (
	IF EXIST "%OutputDir%\%~n1.gpx" GOTO :eof )


:loop
:: Creates a temporary "GPMD2CSV_output.txt" file in the system temp directory.
"%ScriptDir%\bin\ffmpeg" -i "%~1" > "%temp%\GPMD2CSV_output.txt" 2>&1
FOR /F "delims=" %%a in ('FINDSTR "gpmd" "%temp%\GPMD2CSV_output.txt"') DO SET line=%%a
ECHO "%line%"
SET stream= %line:~12,3%
ECHO "%stream%"
CLS
ECHO.
:: User friendly display of the current file being processed.
ECHO **************************************************
ECHO **************** Processing file: ****************
ECHO "%~nx1"
ECHO ***************** In Directory: ******************
ECHO "%~dp1"
ECHO ***************** Saving to: : *******************
ECHO "%OutputDir%"
ECHO **************************************************
:: Runs the various scripts to create the output files.
:: Turns on ECHO to show the user the command being rand and output.
@ECHO ON
START "" /WAIT /MIN "%ScriptDir%bin\ffmpeg" -y -i "%~1" -codec COPY -map "%stream%" -f rawvideo "%temp%\GPMD2CSV.bin"
START "" /WAIT /MIN "%ScriptDir%bin\gpmd2csv" -i "%temp%\GPMD2CSV.bin" -o "%OutputDir%\%~n1.csv"
#START "" /WAIT /MIN "%ScriptDir%bin\gopro2json" -i "%temp%\GPMD2CSV.bin" -o "%OutputDir%\%~n1.json"
#START "" /WAIT /MIN "%ScriptDir%bin\gps2kml" -i "%temp%\GPMD2CSV.bin" -a %AccuracyFilter% -f %FixFilter% -o "%OutputDir%\%~n1.kml"
#START "" /WAIT /MIN "%ScriptDir%bin\gopro2gpx" -i "%temp%\GPMD2CSV.bin" -a %AccuracyFilter% -f %FixFilter% -o "%OutputDir%\%~n1.gpx"
#START "" /WAIT /MIN "%ScriptDir%bin\gopro2geojson" -i "%temp%\GPMD2CSV.bin" -a %AccuracyFilter% -f %FixFilter% -o "%OutputDir%\%~n1.geojson"
@ECHO OFF
:: Deletes the two temp files that were created
DEL "%temp%\GPMD2CSV.bin"
DEL "%temp%\GPMD2CSV_output.txt"
SHIFT
GOTO eof
