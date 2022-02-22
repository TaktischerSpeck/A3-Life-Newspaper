COLOR 0A
set dirGit=C:\GIT\Arma3\A3-Life-Newspaper
set dirServer=C:\Program Files (x86)\Steam\steamapps\common\Arma 3 Server
set PBOManager=C:\Program Files\PBO Manager v.1.4 beta
set mpspace=C:\Users\TaktischerSpeck\AppData\Local\Arma 3\MPMissionsCache

powershell -C "Get-Process | Where-Object { $_.MainWindowTitle -like 'Arma 3*port 2302*' } | Stop-Process"
powershell -C "Get-Process | Where-Object { $_.MainWindowTitle -like 'Arma 3' } | Stop-Process"
timeout 1
powershell -C "Get-Process | Where-Object { $_.MainWindowTitle -like 'Arma 3*port 2302*' } | Stop-Process"
powershell -C "Get-Process | Where-Object { $_.MainWindowTitle -like 'Arma 3' } | Stop-Process"

cd %dirGit%

del "%dirServer%\config\server.cfg" /f /q
xcopy "%dirGit%\config\server.cfg" "%dirServer%\config" /y

del "%dirServer%\@life_server\Addons\life_server.pbo" /f /q
"%PBOManager%\PBOConsole.exe" -pack "%dirGit%\life_server" "%dirServer%\@life_server\Addons\life_server.pbo"

del "%dirServer%\@life_hc\Addons\life_hc.pbo" /f /q
"%PBOManager%\PBOConsole.exe" -pack "%dirGit%\life_hc" "%dirServer%\@life_hc\Addons\life_hc.pbo"

del "%dirServer%\mpmissions\Altis_Life.Altis.pbo" /f /q
"%PBOManager%\PBOConsole.exe" -pack "%dirGit%\Altis_Life.Altis" "%dirServer%\mpmissions\Altis_Life.Altis.pbo"

del "%mpspace%\Altis_Life.Altis.pbo" /f /q
xcopy "%dirServer%\mpmissions\Altis_Life.Altis.pbo" "%mpspace%\" /y

sc start MariaDB

set exe=arma3server_x64.exe
set exehc=arma3server_x64.exe
set mod=
set smod=@extDB3;@life_server;
set hcmod=@extDB3;@life_hc;
set port=2302
set mem=8192
set C=6
set T=7
set profiles=Server_Logs
set config=%dirServer%\config\server.cfg
set cfg=%dirServer%\config\basic.cfg
set bepath=%dirServer%\battleye

cd %dirServer%

start "" "%dirServer%\%exe%" -name=Mountain-Valley-RPG -enableHT -exThreads=7 -autoInit -mod="%mod%" -serverMod="%smod%" -port=%port% -maxmem=%mem% -profiles="%profiles%" -config="%config%" -cfg="%cfg%" -bepath="%bepath%" -loadMissionToMemory
start "" "%dirServer%/%exehc%" -client -name=Mountain-Valley-RPG-HC -profiles=Server_HC_Logs -nosound -enableHT -exThreads=7 -maxmem=%mem% -mod="%hcmod%" -connect=127.0.0.1 -port=%port% -mod="%mod%"

exit