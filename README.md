# elasticsearch_windows_auto_install
elasticsearch_windows_auto_install
（1）、【安装步骤】
在安装路径elasticsearch-win下，右键elasticsearch_auto_install.bat，点击：以管理员身份运行，即可完成一键安装。

（2）、【日志】
日志位置：.\\logs\\es_auto_install.log

（3）、【验证是否安装成功】
建议用火狐浏览器访问：http://localhost:9200/
若成功，会返回以下内容：
{
  "name" : "node-1",
  "cluster_name" : "my-application",
  "version" : {
  "number" : "2.3.3",
  "build_hash" : "218bdf10790eef486ff2c41a3df5cfa32dadcfde",
  "build_timestamp" : "2016-05-17T15:40:04Z",
  "build_snapshot" : false,
  "lucene_version" : "5.5.0"
  },
  "tagline" : "You Know, for Search"
}

（4）、【访问地址】
建议用火狐浏览器访问：
  【1】 head插件访问地址： http://localhost:9200/_plugin/head/
  【2】 kibana插件访问地址：http://localhost:5601

（5）、【删除服务】
在安装路径elasticsearch-win下，右键elasticsearch_uninstall.bat，点击：以管理员身份运行，即可完成一键卸载服务。

（6）、【卸载】
在安装路径elasticsearch-win下，双击：unins000.exe 即可完成卸载。
