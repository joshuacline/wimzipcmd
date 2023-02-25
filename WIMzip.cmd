@ECHO OFF&&ECHO.&&SET "MODE="&&TITLE  Download from github.com/joshuacline
FOR %%1 in (1 2 3) DO (CALL SET A%%1=&&CALL SET "A%%1=%%%%1%%")
SET "ARCHIVE=%A2%"&&SET "FOLDER=%A3%"&&IF NOT DEFINED A1 GOTO:MESSAGE
Reg.exe query "HKU\S-1-5-19\Environment">NUL 2>&1
IF NOT "%ERRORLEVEL%" EQU "0" GOTO:MESSAGE
FOR %%G in ($a $A) DO (IF "%A1%"=="-%%G" SET "MODE=ARCHIVE")
FOR %%G in ($x $X) DO (IF "%A1%"=="-%%G" SET "MODE=EXTRACT")
IF NOT DEFINED MODE GOTO:MESSAGE
IF "%MODE%"=="ARCHIVE" IF EXIST %ARCHIVE% ECHO archive %ARCHIVE% already exists.&&SET "MODE="
IF "%MODE%"=="ARCHIVE" IF NOT EXIST %FOLDER% ECHO folder %FOLDER% doesn't exist.&&SET "MODE="
IF "%MODE%"=="ARCHIVE" DISM /CAPTURE-IMAGE /CAPTUREDIR:%FOLDER% /IMAGEFILE:%ARCHIVE% /COMPRESS:FAST /NAME:WIMzip>NUL 2>&1
IF "%MODE%"=="ARCHIVE" IF EXIST %ARCHIVE% ECHO archive %ARCHIVE% created from %FOLDER%
IF "%MODE%"=="EXTRACT" IF NOT EXIST %ARCHIVE% ECHO archive %ARCHIVE% doesn't exist.&&SET "MODE="
IF "%MODE%"=="EXTRACT" IF NOT EXIST %FOLDER% MD %FOLDER%>NUL 2>&1
IF "%MODE%"=="EXTRACT" IF EXIST %FOLDER% DISM /APPLY-IMAGE /IMAGEFILE:%ARCHIVE% /INDEX:1 /APPLYDIR:%FOLDER%>NUL 2>&1
IF "%MODE%"=="EXTRACT" IF EXIST %FOLDER% ECHO archive %ARCHIVE% extracted to %FOLDER%
GOTO:END
:MESSAGE
ECHO.&&ECHO ======================== WIMzip Command line ========================
ECHO     - WIMzip uses DISM and requires administrative permissions -
ECHO     Create archive  : WIMzip.cmd -$a "X:\archive.$Z" "X:\folder"
ECHO     Extract archive : WIMzip.cmd -$x "X:\archive.$Z" "X:\folder"
ECHO =====================================================================&&ECHO.
:END
