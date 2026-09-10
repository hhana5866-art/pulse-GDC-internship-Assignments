@ECHO OFF
@REM ---------------------------------------------------------------------------
@REM Maven Wrapper (Windows)
@REM
@REM Lets you build this project without installing Maven yourself. On the first
@REM run it downloads the Maven distribution named in
@REM .mvn\wrapper\maven-wrapper.properties into %USERPROFILE%\.m2\wrapper\dists,
@REM then reuses it every time after that.
@REM
@REM   mvnw.cmd spring-boot:run
@REM   mvnw.cmd test
@REM ---------------------------------------------------------------------------
SETLOCAL ENABLEDELAYEDEXPANSION

SET "BASE_DIR=%~dp0"
IF "%BASE_DIR:~-1%"=="\" SET "BASE_DIR=%BASE_DIR:~0,-1%"

SET "PROPS=%BASE_DIR%\.mvn\wrapper\maven-wrapper.properties"
IF NOT EXIST "%PROPS%" (
  ECHO mvnw: cannot find "%PROPS%"
  EXIT /B 1
)

SET "DIST_NAME="
SET "DIST_URL="
FOR /F "usebackq eol=# tokens=1,* delims==" %%A IN ("%PROPS%") DO (
  IF "%%A"=="distributionName"   SET "DIST_NAME=%%B"
  IF "%%A"=="distributionUrlWin" SET "DIST_URL=%%B"
)

IF NOT DEFINED DIST_NAME (
  ECHO mvnw: distributionName missing from "%PROPS%"
  EXIT /B 1
)
IF NOT DEFINED DIST_URL (
  ECHO mvnw: distributionUrlWin missing from "%PROPS%"
  EXIT /B 1
)

IF NOT DEFINED MAVEN_USER_HOME SET "MAVEN_USER_HOME=%USERPROFILE%\.m2"
SET "DIST_HOME=%MAVEN_USER_HOME%\wrapper\dists\%DIST_NAME%"
SET "MVN_CMD=%DIST_HOME%\%DIST_NAME%\bin\mvn.cmd"

IF NOT EXIST "%MVN_CMD%" (
  ECHO Downloading %DIST_NAME% ^(one time only^)...
  IF NOT EXIST "%DIST_HOME%" MKDIR "%DIST_HOME%"
  powershell -NoProfile -ExecutionPolicy Bypass -Command ^
    "$ErrorActionPreference='Stop'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12; $zip=Join-Path '%DIST_HOME%' '%DIST_NAME%-bin.zip'; Invoke-WebRequest -Uri '%DIST_URL%' -OutFile $zip; Expand-Archive -Path $zip -DestinationPath '%DIST_HOME%' -Force; Remove-Item $zip"
  IF ERRORLEVEL 1 (
    ECHO mvnw: download or extraction failed
    EXIT /B 1
  )
)

IF NOT EXIST "%MVN_CMD%" (
  ECHO mvnw: Maven was not found at "%MVN_CMD%" after extraction
  ECHO mvnw: delete "%DIST_HOME%" and try again
  EXIT /B 1
)

SET "MAVEN_PROJECTBASEDIR=%BASE_DIR%"
CALL "%MVN_CMD%" %*
EXIT /B %ERRORLEVEL%
