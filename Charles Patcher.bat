@echo off
title Charles Patcher

set charles=C:\Program Files\Charles\lib\charles.jar
set identification=Charles Patcher

cd /d "%~dp0"
set path=%path%;"%~dp0\jdk\bin";"%~dp0\grep"

REM Preparing
echo Cleaning files...
rmdir .\charles\ /s /q >nul 2>&1
del .\Main.jad >nul 2>&1
del grep.temp >nul 2>&1
del *.java >nul 2>&1
rmdir .\com\ /s /q >nul 2>&1
del .\charles*.jar >nul 2>&1
timeout 1 >nul

copy "%charles%" .\charles_original.jar /y >nul 2>&1

REM Extract charles.jar
echo Extracking charles.jar...
mkdir .\charles\
cd .\charles\
jar xf ..\charles_original.jar
cd ..

REM Decompiling
echo Decompiling Main.class...
jad .\charles\com\xk72\charles\Main.class >nul 2>&1
grep "protected boolean [a-zA-Z]" .\Main.jad | grep -Eo " [a-zA-Z]+;" | grep -Eo "[a-zA-Z]+" > grep.temp
set /p validate=<grep.temp
grep "Registered to: " .\Main.jad | grep -Eo "[a-zA-Z]+\.[a-zA-Z]+\(\)" | grep -Eo "[a-zA-Z]+\." | grep -Eo "[a-zA-Z]+" > grep.temp
set /p class=<grep.temp
grep "Registered to: " .\Main.jad | grep -Eo "[a-zA-Z]+\.[a-zA-Z]+\(\)" | grep -Eo "\.[a-zA-Z]+" | grep -Eo "[a-zA-Z]+" > grep.temp
set /p identify=<grep.temp

REM Patching
echo Patching %class%.java...
echo package com.xk72.charles; > %class%.java
echo public final class %class% { >> %class%.java
echo 	public static boolean %validate%() { return true; } >> %class%.java
echo 	public static String %identify%() { return "%identification%"; } >> %class%.java
echo 	public static String %validate%(String name, String key) { return null; } >> %class%.java
echo } >> %class%.java
javac -encoding UTF-8 %class%.java -d .
copy .\charles_original.jar .\charles.jar /y >nul 2>&1
jar -uvf .\charles.jar ./com/xk72/charles/%class%.class >nul 2>&1
copy .\charles.jar "%charles%" /y >nul 2>&1

REM Cleaning
echo Cleaning files...
rmdir .\charles\ /s /q >nul 2>&1
del .\Main.jad >nul 2>&1
del grep.temp >nul 2>&1
del *.java >nul 2>&1
rmdir .\com\ /s /q >nul 2>&1
timeout 1 >nul

echo.
echo Done!
echo.

pause