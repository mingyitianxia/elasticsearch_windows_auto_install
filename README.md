# 1、Installation steps

In the installation path elasticsearch_win, right-click elasticsearch_auto_install.bat, run as an administrator, can complete a key installation.

# 2、Log position  path
.\logs\es_auto_install log

# 3、Verify successful installation 
Suggest using firefox browser visit: http://localhost:9200/, if successful, returns the following: 
{" name ":" node - 1 ", "cluster_name" : "my - application", "version" : {" number ":" 2.3.3 ", "build_hash" : "218 bdf10790eef486ff2c41a3df5cfa32dadcfde", "build_timestamp" : "the 2016-05-17 T15:40:04 Z", "build_snapshot" : false, "lucene_version" : "5.5.0}", "tagline" : "You Know, for the Search"}

# 4、Access address
Suggested to use firefox browser to access:  
1)the head plug-in access address: http://localhost:9200/_plugin/head/ 
2)kibana plug-in access address: http://localhost:5601

# 5、Delete services
Under the installation path elasticsearch_win, right-click elasticsearch_uninstall.bat, run as an administrator, can complete a key unloading service.

# 6、Uninstall
Under the installation path elasticsearch_win, double-click: unins000. Exe to complete unloading.
