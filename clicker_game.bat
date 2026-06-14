@echo off
setlocal enabledelayedexpansion

:: === ADMIN PASSWORD ===
set adminpass=QuinnIsAdmin

:: === LOAD SAVE OR ASK NAME ===
if exist save.dat (
    for /f "tokens=1,2 delims==" %%a in (save.dat) do (
        set %%a=%%b
    )
) else (
    cls
    echo Welcome! What is your name?
    set /p playername=Name: 
    set clicks=0
    set upgrade1=0
)

:: === UPDATE TITLE WITH PLAYER NAME ===
title %playername%'s Clicker Game

:: === MAIN MENU ===
:menu
cls
echo ================================
echo      %playername%'s Clicker Game
echo ================================
echo.
echo Clicks: %clicks%
echo.
echo [1] CLICK
echo [2] UPGRADES
echo [3] ADMIN
echo [X] CLOSE GAME
echo.
set /p choice=Choose: 

if /i "%choice%"=="1" goto click
if /i "%choice%"=="2" goto upgrades
if /i "%choice%"=="3" goto adminlogin
if /i "%choice%"=="x" goto close
goto menu

:: === CLICK ===
:click
set /a gain=1+upgrade1
set /a clicks+=gain
goto menu

:: === UPGRADE MENU ===
:upgrades
cls
echo ========= UPGRADES =========
echo.
echo Upgrade 1: +1 click per press
echo Level: %upgrade1%
set /a cost=upgrade1*10+10
echo Cost: %cost%
echo.
echo [B] Buy Upgrade
echo [R] Return
echo.
set /p uchoice=Choose: 

if /i "%uchoice%"=="b" (
    if %clicks% GEQ %cost% (
        set /a clicks-=cost
        set /a upgrade1+=1
    ) else (
        echo Not enough clicks!
        pause
    )
)
goto menu

:: === ADMIN LOGIN ===
:adminlogin
cls

:: Check if running as Administrator
net session >nul 2>&1
if %errorlevel%==0 (
    echo You do know that administrator has the word admin in it...
    timeout /t 2 >nul
    goto admin
)

echo ===== ADMIN LOGIN =====
echo.
set /p try=Enter password: 

if "%try%"=="%adminpass%" goto admin
echo Wrong password!
pause
goto menu

:: === ADMIN PANEL ===
:admin
cls
echo ===== ADMIN PANEL =====
echo.
echo [1] Add 1000 clicks
echo [2] Reset upgrades
echo [3] Reset ALL progress
echo [R] Return
echo.
set /p adm=Choose: 

if "%adm%"=="1" (
    set /a clicks+=1000
    goto admin
)

if "%adm%"=="2" (
    set upgrade1=0
    goto admin
)

if "%adm%"=="3" (
    set clicks=0
    set upgrade1=0
    goto admin
)

goto menu

:: === SAVE & EXIT ===
:close
echo playername=%playername%>save.dat
echo clicks=%clicks%>>save.dat
echo upgrade1=%upgrade1%>>save.dat
exit
