@echo off
cls
echo ### JavWeb Compiler ###
echo Author: Lenny Bakkalian - github.com/lennybakkalian - hackerone.com/lennybakkalian
echo.
REM get jdk path and version from registry
FOR /F "skip=2 tokens=2*" %%A IN ('REG QUERY "HKLM\Software\JavaSoft\Java Development Kit" /v CurrentVersion') DO set CurVer=%%B
FOR /F "skip=2 tokens=2*" %%A IN ('REG QUERY "HKLM\Software\JavaSoft\Java Development Kit\%CurVer%" /v JavaHome') DO set jdkpath=%%B
REM check if javac.exe exist
set javacfile=%jdkpath%\bin\javac.exe
set javafile=%jdkpath%\bin\java.exe
set jarfile=%jdkpath%\bin\jar.exe
if exist "%javacfile%" goto foundjavac
echo [ERROR] Eine JDK installation konnte nicht gefunden werden! (%javacfile%)
pause>NUL
exit
:foundjavac
echo [INFO] JDK %CurVer% gefunden! compiler: %javacfile%
if not %CurVer% == 1.8 echo [WARNING] Es ist nicht die 1.8 JDK Version installiert! Es kann zu fehlern beim compilieren kommen! & timeout 3 >NUL
if exist build rmdir /s /q build & echo [INFO] Deleting old /build directory
mkdir build
echo [INFO] Compiling %cd%/src/*
"%javacfile%" -cp "%cd%/src/" "%cd%/src/javweb/Start.java" -d ./build
echo [INFO] Compiled! Creating .jar file...
cd build
REM todo: bugfix dont add logfile to jar
"%jarfile%" -cvfe build.jar javweb.Start ./
echo [INFO] build.jar created! Execute: %javafile% -jar build.jar
echo.
"%javafile%" -jar build.jar
if %errorlevel% == 1 echo Unbekannter Fehler & log.txt