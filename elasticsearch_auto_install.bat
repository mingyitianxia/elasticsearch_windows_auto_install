@ECHO OFF
::set target dir
::set out=D:\testing
::copy the elasticsearch packet to C:/
::xcopy /e/c/h/z "%~pd0*.*" "%out%"
cd /d %~dp0
set curpath=%cd%
set logpath=%curpath%\logs

::echo "curpath=%curpath%"
::echo "logpath=%logpath%"


rem @for /F "tokens=2 delims=:" %%i in ('"ipconfig | findstr IPv4"') do set LOCAL_IP=%%i
rem @echo Detected: Local IP = [%LOCAL_IP%]

::get cur time
rem   取系统日期及时间，同时将时间转换为8位(8:16:00-->08:16:00).
set   CurDate=%date:~0,10%
set   CurTime=%time%
set   hh=%CurTime:~0,2%
if   /i   %hh%   LSS   10   ( set   hh=0%CurTime:~1,1% )
set   mm=%CurTime:~3,2%
set   ss=%CurTime:~6,2%
set   CurDateTime=%CurDate% %hh%:%mm%:%ss%
::echo %CurDateTime%

::delete auto_install log
::del  /s %logpath%\es_auto_install.log

rem 创建自动安装日志文件auto_install.log
::create auto_install log
set auto_install_log=%logpath%\es_auto_install.log
echo y | cacls "%auto_install_log%" /t /c /p everyone:f

type NUL > %auto_install_log%

echo "install_log=%auto_install_log%"

rem 检验是否安装了java jdk,如果没有需要手动安装
rem set javahome_path="c:\testing"
set jdk_path=%curpath%\JDK1.8.0_45
echo "jdk_path=%jdk_path%"
set java_home_path=C:\Program Files (x86)\Java\jdk1.8.0_45
if Defined JAVA_HOME (
  echo [%CurDateTime%]"The JDK already installed."  >> %auto_install_log%
) else (
  echo [%CurDateTime%]"The JDK does not installed." >> %auto_install_log%
  pushd %jdk_path%
  start /wait jdk-8u45-windows-i586.exe
  ::goto set_environment
  setx -m JAVA_HOME "C:\Program Files (x86)\Java\jdk1.8.0_45"
  setx -m CLASSPATH ".;%java_home_path%\lib\tools.jar;%java_home_path%\lib\dt.jar"
  setx -m PATH "%java_home_path%\bin;%PATH%"
  popd
)

rem :set_environment
rem 设置系统环境变量

set curlpath=%curpath%
rem 设置curl
if exist %windir%\SysWOW64 ( 
set curlpath=%curpath%\curl\win64
) else (
set curlpath=%curpath%\curl\win32
)
echo [%CurDateTime%]curlpath=%curlpath%
rem 设置CURL环境变量
setx -m CURL_HOME "%curlpath%"
setx -m PATH "%curlpath%;%PATH%"
	
:run
rem 第1步：以服务的形式安装ES
echo [%CurDateTime%]"STEP 1. Install ES As Service..."  
echo [%CurDateTime%]"STEP 1. Install ES As Service..."  >> %auto_install_log%  

::Enter path ..\\elasticsearch-2.3.3\bin
set es_bin_dir=%curpath%\bin
::echo %es_bin_dir%

rem bugs 2016-7-11
pushd %es_bin_dir%
echo [%CurDateTime%] >> %auto_install_log%  
call service.bat install  >> %auto_install_log%
popd


rem new add by ycy 2016-7-11
echo [%CurDateTime%]"installed 20%%....."

rem 到此，ES服务安装成功,异常退出代表安装失败，可通过日志排查。

rem 第2步：安装head插件
echo [%CurDateTime%]"STEP 2. Install Head plugin...."
echo [%CurDateTime%]"STEP 2. Install Head plugin...." >> %auto_install_log%
pushd %es_bin_dir%
echo es_bin_dir=%es_bin_dir%
echo [%CurDateTime%] >> %auto_install_log%  
::start /wait plugin install mobz/elasticsearch-head  >> %auto_install_log% 
popd



rem 第3步：安装kibanan插件
echo [%CurDateTime%]"STEP 3. Install Kibana plugin...."
echo [%CurDateTime%]"STEP 3. Install Kibana plugin...." >> %auto_install_log%

rem 判定操作系统是32bit还是64bit？
set nssmpath=%curpath%\nssm-2.24\winxx
if exist %windir%\SysWOW64 ( 
set nssmpath=%curpath%\nssm-2.24\win64\nssm.exe
) else (
set nssmpath=%curpath%\nssm-2.24\win32\nssm.exe 
)

echo [%CurDateTime%]%nssmpath% >> %auto_install_log%

rem 以服务的形式启动kibana
set kibana_bin_path=%curpath%\kibana-4.5.1-windows\bin\kibana.bat

echo [%CurDateTime%] >> %auto_install_log%

rem 2016-7-11 13:48
rem echo "nssmpath="%nssmpath%
rem echo "kibana_bin_path"=%kibana_bin_path%
start /wait %nssmpath% install kibana  %kibana_bin_path% 

rem new add by ycy 2016-7-11
echo [%CurDateTime%]"installed 50%%......"

rem 第4步：安装logstash插件
echo [%CurDateTime%]"STEP 4. Install Logstash plugin...."

set logstash_path=%curpath%\logstash-2.3.3
set logstash_bin=%logstash_path%\bin
set logstash_conf=%logstash_path%\conf.d
set logstash_stdout=%logstash_path%\stdout.log
set logstash_stderr=%logstash_path%\stderr.log

start /wait %nssmpath% install logstash %logstash_bin%\logstash.bat
start /wait %nssmpath% set logstash AppParameters agent --config %logstash_conf%
start /wait %nssmpath% set logstash AppDirectory %logstash_path%\install
start /wait %nssmpath% set logstash AppEnvironmentExtra "Java_HOME=%JAVA_HOME%"
start /wait %nssmpath% set logstash AppStdout %logstash_stdout%
start /wait %nssmpath% set logstash AppStderr %logstash_stderr%
start /wait %nssmpath% set logstash AppStdoutCreationDisposition 2
start /wait %nssmpath% set logstash AppStderrCreationDisposition 2
start /wait %nssmpath% set logstash AppStopMethodSkip 6


echo [%CurDateTime%]"STEP 5. Start Elasticsearch...."
echo [%CurDateTime%]"STEP 5. Start Elasticsearch...." >> %auto_install_log%
rem 第5步：启动ES
pushd %es_bin_dir%
echo [%CurDateTime%]%es_bin_dir%  >> %auto_install_log%  
call service.bat start  >> %auto_install_log%
popd

rem new add by ycy 2016-7-11
echo [%CurDateTime%]"installed 70%%......"
echo [%CurDateTime%]"STEP 6. Start Kibana..."
echo [%CurDateTime%]"STEP 6. Start Kibana...." >> %auto_install_log%
rem 第6步：启动kibana
echo [%CurDateTime%] >> %auto_install_log%
start /wait %nssmpath% start kibana 

rem new add by ycy 2016-7-11
echo [%CurDateTime%]"installed 90%%......"

echo [%CurDateTime%]"STEP 7. Start logstash..."
echo [%CurDateTime%]"STEP 7. Start logstash...." >> %auto_install_log%

rem 第7步：启动logstash
pushd %logstash_bin%
echo "logstash_bin=%logstash_bin%" >> %auto_install_log%
start /wait net start logstash
popd

rem new add by ycy 2016-7-11
echo [%CurDateTime%]"installed 100%%......"

start /wait explorer.exe open=http://localhost:9200/
start /wait explorer.exe open=http://localhost:9200/_plugin/head/
start /wait explorer.exe open=http://localhost:5601/

pause


