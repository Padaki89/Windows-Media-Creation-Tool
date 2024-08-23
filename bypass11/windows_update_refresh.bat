@echo off
title WINDOWS UPDATE REFRESH

:: Elevate with native shell
>nul reg add hkcu\software\classes\.Admin\shell\runas\command /f /ve /d "cmd /x /d /r set \"f0=%%2\"& call \"%%2\" %%3" & set _= %*
>nul fltmc || if "%f0%" neq "%~f0" (
    cd.>"%temp%\runas.Admin"
    start "%~n0" /high "%temp%\runas.Admin" "%~f0" "%_:"=""%"
    exit /b
)

:: Stop pending updates
for /f "tokens=6 delims=[]. " %%b in ('ver') do set /a BUILD=%%b
set KILL=& set UPDATE=windowsupdatebox updateassistant updateassistantcheck windows10upgrade windows10upgraderapp
for %%w in (dism setuphost tiworker usoclient sihclient wuauclt culauncher sedlauncher osrrb ruximics ruximih disktoast eosnotify musnotification musnotificationux musnotifyicon monotificationux mousocoreworker %UPDATE%) do call set KILL=/im %%w.exe %%KILL%%
taskkill /f %KILL% 2>nul & dism /cleanup-wim & bitsadmin /reset /allusers
for %%w in (msiserver wuauserv bits usosvc dosvc cryptsvc) do start /min cmd /d /x /c net stop %%w /y
taskkill /f %KILL% /im systemsettings.exe 2>nul & timeout 7 /nobreak >nul

:: Clear update logs
set "DATA=%ProgramData%"
set "LOG=%SystemRoot%\Logs\WindowsUpdate"
set "SRC=%SystemDrive%\$WINDOWS.~BT\Sources"
del /f /s /q "%DATA%\USOShared\Logs\*" "%DATA%\USOPrivate\UpdateStore\*" "%DATA%\Microsoft\Network\Downloader\*" >nul 2>nul
powershell -nop -c "try { $null=Get-WindowsUpdateLog -LogPath $env:temp\WU.log -ForceFlush -Confirm:$false -ea 0 } catch {}" >nul
rmdir /s /q "%LOG%" "%ProgramFiles%\UNP" "%SystemRoot%\SoftwareDistribution" "%SystemDrive%\Windows.old\Cleanup" >nul 2>nul
if exist "%SRC%\setuphost.exe" if exist "%SRC%\setupprep.exe" (
    start "cleanup" /wait "%SRC%\setupprep.exe" /cleanup /quiet
)

:: Remove forced upgraders and update remediators
call "%SystemRoot%\UpdateAssistant\Windows10Upgrade.exe" /ForceUninstall 2>nul
call "%SystemDrive%\Windows10Upgrade\Windows10UpgraderApp.exe" /ForceUninstall 2>nul
msiexec /X {1BA1133B-1C7A-41A0-8CBF-9B993E63D296} /qn 2>nul && echo;Removed osrss
msiexec /X {8F2D6CEB-BC98-4B69-A5C1-78BED238FE77} /qn 2>nul && echo;Removed rempl, ruxim
msiexec /X {0746492E-47B6-4251-940C-44462DFD74BB} /qn 2>nul && echo;Removed CUAssistant
msiexec /X {76A22428-2400-4521-96AF-7AC4A6174CA5} /qn 2>nul && echo;Removed UpdateAssistant

:: Start update services
net start bits /y
net start wuauserv /y
net start usosvc /y 2>nul
start /min UsoClient RefreshSettings

echo;
echo AveYo: Run again or reboot if there are still pending files or services
pause
exit /b
