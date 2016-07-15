@ECHO OFF

rem 以下必须以管理员权限运行
rem 删除安装过的服务
cd /d %~dp0
set curpath=%cd%
set binpath=%curpath%\bin

rem 停止ES服务
call service.bat stop
echo "elasticsearch-service-x86 service has been stopped!"

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
start /wait %nssmpath% stop kibana 
echo "kibana service has been stopped!"

rem 停止logstash服务
pushd %logstash_bin_path%
start /wait net stop logstash
popd

echo "logstash service has been stopped!"

rem 删除对应的三个服务
sc delete elasticsearch-service-x86
sc delete kibana
sc delete logstash

echo "elasticsearch-service-x86 service has been deleted!"
echo "kibana service has been deleted!"
echo "logstash service has been deleted!"

rem 删除日志文件夹下的所有文件
cd /d %~dp0
set curpath=%cd%
set logpath=%curpath%\logs
pushd %logpath%
del /q /s %logpath%\*.*
popd

pause
