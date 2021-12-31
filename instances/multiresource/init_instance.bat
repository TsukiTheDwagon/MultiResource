@echo off
title MultiResource - Setup New Instance
if exist ..\System32 goto :direct_open_error
if exist .\init_instance.bat goto :direct_open_error
if exist ..\setup_finished goto :eof
echo Setting up instance %INST_NAME%...
copy ..\..\multiresource\universal_resources\default_files .
mklink /D dummy_link ..\..\multiresource\universal_resources\dummy_link
IF %ERRORLEVEL% EQU 0 (
    ECHO Script has sufficient permission to make symbolic links. Proceeding...
) ELSE (
    ECHO You need to enable developer mode in the settings for this script to create symbolic links.
    ECHO Turn developer mode on in your settings, then try opening the instance again from MultiMC.
    PAUSE
    exit 1
)
rmdir texturepacks resourcepacks screenshots shaderpacks dummy_link
mklink /D resourcepacks ..\..\multiresource\universal_resources\resourcepacks
mklink /D texturepacks ..\..\multiresource\universal_resources\texturepacks
mklink /D screenshots ..\..\multiresource\universal_resources\screenshots
mklink /D shaderpacks ..\..\multiresource\universal_resources\shaderpacks
echo Universal resource links created.
call ..\..\multiresource\custom_resources.bat
set "reply=y"
set /p "reply=Is this install safe to load vanilla worlds? (This will add the universal saves resource.) [y/n]: "
if /i not "%reply%" == "y" goto :saves-skip
rmdir saves
mklink /D saves ..\..\multiresource\universal_resources\saves
echo Universal save resource link created.
:saves-skip
set "reply=y"
set /p "reply=Do you want this install to share mod configs with other installs? (This will add the universal config resource.) [y/n]: "
if /i not "%reply%" == "y" goto :config-skip
rmdir config
mklink /D config ..\..\multiresource\universal_resources\config
:config-skip
echo Initial resource setup finished on %date% %time%> ..\setup_finished
echo Your new instance has now been set up. If you want to redo this setup, simply delete setup_finished from the instance folder.
pause
goto :end
:direct_open_error
echo This batch file is not supposed to be run directly from Explorer. MultiMC runs this custom script when making a new instance.
pause
:end
exit