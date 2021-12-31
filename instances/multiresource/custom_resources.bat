@echo off
if exist ..\System32 goto :eof
if exist .\init_instance.bat goto :eof
:: This file allows you to create custom universal resources alongside the normal defaults.

:: To add a universal resource, first add its resource name to the rmdir command here. You'll need to uncomment it if you're adding your first one.
:: The resource name should be the same as the folder the resource replaces in the minecraft game directory.
rmdir figura

:: Next, copy this command to the empty space below and uncomment it. Replace <resourceName> in the command with the resource name you added in the previous step.
:: mklink /D <resourceName> ..\..\universal_resources\<resourceName>
mklink /D figura ..\..\universal_resources\figura




:: And you're done! All you need to do now is create a folder with that resource name in your universal resources directory.
:: Don't add anything after this line.
echo Custom resource links created (if any exist).
:eof