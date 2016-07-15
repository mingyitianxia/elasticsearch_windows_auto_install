@ECHO OFF

rem 以下必须以管理员权限运行
rem 运行安装过的服务
cd /d %~dp0
set curpath=%cd%
set binpath=%curpath%\bin

rem 停止ES服务
call service.bat start
echo [1] elasticsearch-service-x86 service has been started!

set kibana_bin_path=%curpath%\kibana-4.5.1-windows\bin
set logstash_bin_path=%curpath%\logstash-2.3.3\bin
rem 判定操作系统是32bit还是64bit？
set nssmpath=%curpath%\nssm-2.24\winxx
if exist %windir%\SysWOW64 ( 
set nssmpath=%curpath%\nssm-2.24\win64\nssm.exe
) else (
set nssmpath=%curpath%\nssm-2.24\win32\nssm.exe 
)

rem 停止kibana服务
start /wait %nssmpath% start kibana 
echo [2] kibana service has been started!

rem 停止logstash服务
pushd %logstash_bin_path%
start /wait net start logstash
popd

echo [3] logstash service has been started!

for /l %%i in (1,1,1000) do (
 echo ffff>nul
)

pause