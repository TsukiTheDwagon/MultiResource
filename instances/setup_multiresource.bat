@echo off
set arg1=%1
title MultiResource - Initial Setup
if "%arg1%" == "prelaunchretry" goto :prelaunch
echo This setup script will create and edit the necessary files for MultiResource to run in MultiMC.
echo ---
echo Testing if symbolic links can be created...
mklink dummy_link dummy_source
IF %ERRORLEVEL% EQU 0 (
    ECHO [INFO] Script has sufficient permission to make symbolic links. Proceeding...
) ELSE (
    ECHO [ERROR] You need to enable developer mode in the settings for this script to create symbolic links.
    ECHO [ERROR] Turn developer mode on in your settings, then run this setup script again. The install script will now close.
    goto :end
)
del dummy_link
echo ---
echo %cd%
set "reply=n"
set /p "reply=Are the instance folders and this batch file currently in your MultiMC instances folder listed above? [y/n]: "
if /i not "%reply%" == "y" goto :error
echo [INFO] Creating symbolic links (files)...
del multiresource_options_editor\.minecraft\options.txt multiresource_options_editor_of\.minecraft\options.txt multiresource_options_editor_of\.minecraft\optionsof.txt
mklink multiresource_options_editor\.minecraft\options.txt ..\..\multiresource\universal_resources\default_files\options.txt
mklink multiresource_options_editor_of\.minecraft\options.txt ..\..\multiresource\universal_resources\default_files\options.txt
mklink multiresource_options_editor_of\.minecraft\optionsof.txt ..\..\multiresource\universal_resources\default_files\optionsof.txt
echo [INFO] Creating symbolic links (directories)...
rmdir multiresource_open_shared_resources\.minecraft\resourcepacks multiresource_open_shared_resources\.minecraft\saves multiresource_open_shared_resources\.minecraft\screenshots multiresource_open_shared_resources\.minecraft\shaderpacks multiresource_open_shared_resources\.minecraft\texturepacks
mklink /D multiresource_open_shared_resources\.minecraft\resourcepacks ..\..\multiresource\universal_resources\resourcepacks
mklink /D multiresource_open_shared_resources\.minecraft\saves ..\..\multiresource\universal_resources\saves
mklink /D multiresource_open_shared_resources\.minecraft\screenshots ..\..\multiresource\universal_resources\screenshots
mklink /D multiresource_open_shared_resources\.minecraft\shaderpacks ..\..\multiresource\universal_resources\shaderpacks
mklink /D multiresource_open_shared_resources\.minecraft\texturepacks ..\..\multiresource\universal_resources\texturepacks
echo [INFO] Symbolic links created.
echo [INFO] Adding default pre-launch command to allow setting up instances...
:prelaunch
setlocal disableDelayedExpansion
copy ..\multimc.cfg ..\multimc.cfg.old
:Variables
set InputFile=..\multimc.cfg.old
set OutputFile=..\multimc.cfg
set "_strFind=PreLaunchCommand="
set "_strInsert=PreLaunchCommand=cmd.exe /c if not exist ..\\setup_finished start /wait ..\\..\\multiresource\\init_instance.bat"

:Replace
>"%OutputFile%" (
  for /f "usebackq delims=" %%A in ("%InputFile%") do (
    if "%%A" equ "%_strFind%" (echo %_strInsert%) else (echo %%A)
  )
)
comp /M ..\multimc.cfg ..\multimc.cfg.old > nul
if not errorlevel 1 goto :prelaunchfail
goto :next
:prelaunchfail
echo [ERROR] Could not set default pre-launch command, a command might already be set. To retry, run this batch file with 'setup_multiresource.bat prelaunchretry' to try again.
echo [ERROR] This pre-launch command is required for MultiResource to automatically set up MultiMC instances to use shared resources.
:next
echo [INFO] Install complete.
goto :end
:error
echo [ERROR] Please move the files to your MultiMC instances folder, then run this again. The install script will now close.
:end
pause