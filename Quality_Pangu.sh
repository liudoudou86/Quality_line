#!/bin/sh
# Author:lz


echo -e "********************************************* \c " 
echo -e "\033[32m数据库备份自动测试脚本\033[0m \c"
echo -e "********************************************* "

function check_mysql_full(){
	echo -e "测试开始：mysql数据库全量自动备份测试"
	dir_check=1
	crontab_check=1
	crontab_status=1
	file_check=1
	check_bak_dir=/opt/db_backup_data/mysql1
    check_bak_file=$check_bak_dir/full
	check_bak_sh=/opt/db_backup_tool/mysql1
	check_crontab_mysqlbak="/opt/db_backup_tool/mysql1/backup_full.sh > /var/log/dbbak_cron_log.log 2>&1 &"
	if [ -d $check_bak_dir -a  -d $check_bak_file -a -d $check_bak_sh ];then
		echo -e "备份目录存在！"
		dir_check=0
		crontab_list=`crontab -l`
		if [[ "${crontab_list:9}" =~ "$check_crontab_mysqlbak" ]] ;then
			echo -e "定时备份任务已配置！"
			crontab_check=0
			ps -e | grep crond > /dev/null 2>&1			
			if [ $? -eq 0  ]; then
				echo -e "定时备份任务程序cron已启动"
				crontab_status=0
			fi
		fi
		
		count=`ls $check_bak_file |wc -w`
		if [ $count -gt 0 -a $count -le 1 ] ;then
			file_check=0
		fi
	fi
	if [ $dir_check -eq 0 ] && [ $crontab_check -eq 0 ] && [ $crontab_status -eq 0 ] && [ $file_check -eq 0 ];then 
		echo -e  "执行结果：\c"
		echo -e "\033[32m通过\033[0m\n"

	fi
	if  [ $dir_check -eq 1 ] || [ $crontab_check -eq 1 ] || [ $crontab_status -eq 1 ] || [ $file_check -eq 1 ];then
		echo -e  "执行结果：\c"
		echo -e "\033[31m失败\033[0m"
		if  [ $dir_check -eq 1 ];then
			echo -e "\033[31m备份目录不存在\033[0m\n"
		elif  [ $crontab_check -eq 1 ];then
			echo -e "\033[31m定时备份任务未配置\033[0m\n"
		elif [ $crontab_status -eq 1 ];then
			echo -e "\033[31m定时备份任务程序cron未启动\033[0m\n"
		elif [ $file_check -eq 1 ];then
			echo -e "\033[31m备份文件夹无文件或文件数大于1\033[0m\n"
		fi
	fi
}


function check_mysql_incremental(){
	echo -e "测试开始：mysql数据库增量自动备份测试"
	dir_check=1
	crontab_check=1
	crontab_status=1
	file_check=1
	check_bak_dir=/opt/db_backup_data/mysql1
    check_bak_file=$check_bak_dir/increment
	check_bak_sh=/opt/db_backup_tool/mysql1
	check_crontab_mysqlbak="/opt/db_backup_tool/mysql1/backup_incremental.sh > /var/log/dbbak_cron_log.log 2>&1 &"
	if [ -d $check_bak_dir -a  -d $check_bak_file -a -d $check_bak_sh ];then
		echo -e "备份目录存在！"
		dir_check=0
		crontab_list=`crontab -l`
		if [[ "${crontab_list:9}" =~ "$check_crontab_mysqlbak" ]] ;then
			echo -e "定时备份任务已配置！"
			crontab_check=0
			ps -e | grep crond > /dev/null 2>&1			
			if [ $? -eq 0  ]; then
				echo -e "定时备份任务程序cron已启动"
				crontab_status=0
			fi
		fi
		
		count=`ls $check_bak_file |wc -w`
		if [ $count -gt 0 -a $count -le 4 ] ;then
			file_check=0
		fi
	fi
	if [ $dir_check -eq 0 ] && [ $crontab_check -eq 0 ] && [ $crontab_status -eq 0 ] && [ $file_check -eq 0 ];then 
		echo -e  "执行结果：\c"
		echo -e "\033[32m通过\033[0m\n"

	fi
	if  [ $dir_check -eq 1 ] || [ $crontab_check -eq 1 ] || [ $crontab_status -eq 1 ] || [ $file_check -eq 1 ];then
		echo -e  "执行结果：\c"
		echo -e "\033[31m失败\033[0m"
		if  [ $dir_check -eq 1 ];then
			echo -e "\033[31m备份目录不存在\033[0m\n"
		elif  [ $crontab_check -eq 1 ];then
			echo -e "\033[31m定时备份任务未配置\033[0m\n"
		elif [ $crontab_status -eq 1 ];then
			echo -e "\033[31m定时备份任务程序cron未启动\033[0m\n"
		elif [ $file_check -eq 1 ];then
			echo -e "\033[31m备份文件夹无文件或文件数大于4\033[0m\n"
		fi
	fi
}


function check_cassandra_bak(){
	echo -e "测试开始：cassandra数据库全量自动备份测试"
	dir_check=1
	crontab_check=1
	crontab_status=1
	file_check=1
	check_bak_dir=/opt/td_elassandra/elassandra/data/cassandra/data/system/schema_keyspaces-b0f2235744583cdb9631c43e59ce3676/
    check_bak_file=$check_bak_dir/snapshots
	check_bak_sh=/opt/td-file-backup
	check_crontab_mysqlbak="/usr/bin/sh /opt/td-file-backup/backups.sh Full_backup >> /opt/td-file-backup/timer.log"
    # TODO:存在其他路径，需要补充
	if [ -d $check_bak_dir -a  -d $check_bak_file -a -d $check_bak_sh ];then
		echo -e "备份目录存在！"
		dir_check=0
		crontab_list=`crontab -l`
		if [[ "${crontab_list:9}" =~ "$check_crontab_mysqlbak" ]] ;then
			echo -e "定时备份任务已配置！"
			crontab_check=0
			ps -e | grep crond > /dev/null 2>&1			
			if [ $? -eq 0  ]; then
				echo -e "定时备份任务程序cron已启动"
				crontab_status=0
			fi
		fi
		
		count=`ls $check_bak_file |wc -w`
		if [ $count -gt 0 -a $count -le 1 ] ;then
			file_check=0
		fi
	fi
	if [ $dir_check -eq 0 ] && [ $crontab_check -eq 0 ] && [ $crontab_status -eq 0 ] && [ $file_check -eq 0 ];then 
		echo -e  "执行结果：\c"
		echo -e "\033[32m通过\033[0m\n"

	fi
	if  [ $dir_check -eq 1 ] || [ $crontab_check -eq 1 ] || [ $crontab_status -eq 1 ] || [ $file_check -eq 1 ];then
		echo -e  "执行结果：\c"
		echo -e "\033[31m失败\033[0m"
		if  [ $dir_check -eq 1 ];then
			echo -e "\033[31m备份目录不存在\033[0m\n"
		elif  [ $crontab_check -eq 1 ];then
			echo -e "\033[31m定时备份任务未配置\033[0m\n"
		elif [ $crontab_status -eq 1 ];then
			echo -e "\033[31m定时备份任务程序cron未启动\033[0m\n"
		elif [ $file_check -eq 1 ];then
			echo -e "\033[31m备份文件夹无文件或文件数大于3\033[0m\n"
		fi
	fi
}

check_mysql_full
check_mysql_incremental
check_cassandra_bak

echo -e "********************************************* \c " 
echo -e "\033[32m守护进程自动测试脚本\033[0m \c"
echo -e "********************************************* "

function java_tomcat_daemon(){
  echo -e "测试开始："
  check_time=0
  java_tomcat_pid=`ps -ef | grep "/opt/apache-tomcat/jre/bin/java_tomcat" | grep -v grep | awk '{print $2}'`
  sleep 1
  echo -e "开始杀死tomcat进程！进程号：$java_tomcat_pid"
  kill -9 $java_tomcat_pid
  sleep 1
  java_tomcat_pid=`ps -ef | grep "/opt/apache-tomcat/jre/bin/java_tomcat" | grep -v grep | awk '{print $2}'`
  if [ "$java_tomcat_pid" == "" ];then
      echo -e "进程已杀死！"
      echo -e "等待守护进程启动...\c"
      while true
      do
          java_tomcat_pid=`ps -ef | grep "/opt/apache-tomcat/jre/bin/java_tomcat" | grep -v grep | awk '{print $2}'`
          if [ -n "$java_tomcat_pid" ];then
              echo -e "\n进程已启动！进程号：$java_tomcat_pid\c"
              break
          fi
          sleep 1
          ((check_time++))
          echo -e ".\c"
      done
      echo -e ",等待时间$check_time秒！"
      echo -e "测试结束：\c"
      echo -e "\033[32m通过\033[0m\n"	
  else
      echo -e "杀死进程异常！"
      echo -e "测试结束：\c"
      echo -e "\033[31m失败\033[0m\n"
  fi
}


function java_cassandra_daemon(){
  echo -e "测试开始："
  check_time=0
  java_cassandra_pid=`ps -ef | grep "/opt/td_elassandra/elassandra/jre/bin/java_cassandra" | grep -v grep | awk '{print $2}'`
  sleep 1
  echo -e "开始杀死cassandra进程！进程号：$java_cassandra_pid"
  kill -9 $java_cassandra_pid
  sleep 1
  java_cassandra_pid=`ps -ef | grep "/opt/td_elassandra/elassandra/jre/bin/java_cassandra" | grep -v grep | awk '{print $2}'`
  if [ "$java_cassandra_pid" == "" ];then
      echo -e "进程已杀死！"
      echo -e "等待守护进程启动...\c"
      while true
      do
          java_cassandra_pid=`ps -ef | grep "/opt/td_elassandra/elassandra/jre/bin/java_cassandra" | grep -v grep | awk '{print $2}'`
          if [ -n "$java_cassandra_pid" ];then
              echo -e "\n进程已启动！进程号：$java_cassandra_pid\c"
              break
          fi
          sleep 1
          ((check_time++))
          echo -e ".\c"
      done
      echo -e ",等待时间$check_time秒！"
      echo -e "测试结束：\c"
      echo -e "\033[32m通过\033[0m\n"	
  else
      echo -e "杀死进程异常！"
      echo -e "测试结束：\c"
      echo -e "\033[31m失败\033[0m\n"
  fi
}


function mysqld_daemon(){
  echo -e "测试开始："
  check_time=0
  mysqld_pid=`ps -ef | grep "/opt/mysql/bin/mysqld" | grep -v grep | awk '{print $2}'`
  sleep 1
  echo -e "开始杀死mysqld进程！进程号：$mysqld_pid"
  kill -9 $mysqld_pid
  sleep 1
  mysqld_pid=`ps -ef | grep "/opt/mysql/bin/mysqld" | grep -v grep | awk '{print $2}'`
  if [ "$mysqld_pid" == "" ];then
      echo -e "进程已杀死！"
      echo -e "等待守护进程启动...\c"
      while true
      do
          mysqld_pid=`ps -ef | grep "/opt/mysql/bin/mysqld" | grep -v grep | awk '{print $2}'`
          if [ -n "$mysqld_pid" ];then
              echo -e "\n进程已启动！进程号：$mysqld_pid\c"
              break
          fi
          sleep 1
          ((check_time++))
          echo -e ".\c"
      done
      echo -e ",等待时间$check_time秒！"
      echo -e "测试结束：\c"
      echo -e "\033[32m通过\033[0m\n"	
  else
      echo -e "杀死进程异常！"
      echo -e "测试结束：\c"
      echo -e "\033[31m失败\033[0m\n"
  fi
}


function nginx_sercurity_daemon(){
  echo -e "测试开始："
  check_time=0
  nginx_sercurity_pid=`ps -ef | grep "nginx: master process" | grep -v grep | awk '{print $2}'`
  sleep 1
  echo -e "开始杀死nginx进程！进程号：$nginx_sercurity_pid"
  pkill nginx
  sleep 1
  nginx_sercurity_pid=`ps -ef | grep "nginx: master process" | grep -v grep | awk '{print $2}'`
  if [ "$nginx_sercurity_pid" == "" ];then
      echo -e "进程已杀死！"
      echo -e "等待守护进程启动...\c"
      while true
      do
          nginx_sercurity_pid=`ps -ef | grep "nginx: master process" | grep -v grep | awk '{print $2}'`
          if [ -n "$nginx_sercurity_pid" ];then
              echo -e "\n进程已启动！进程号：$nginx_sercurity_pid\c"
              break
          fi
          sleep 1
          ((check_time++))
          echo -e ".\c"
      done
      echo -e ",等待时间$check_time秒！"
      echo -e "测试结束：\c"
      echo -e "\033[32m通过\033[0m\n"	
  else
      echo -e "杀死进程异常！"
      echo -e "测试结束：\c"
      echo -e "\033[31m失败\033[0m\n"
  fi
}


function redis_server_daemon(){
  echo -e "测试开始："
  check_time=0
  redis_server_pid=`ps -ef | grep "/opt/redis/bin/redis-server" | grep -v grep | awk '{print $2}'`
  sleep 1
  echo -e "开始杀死redis进程！进程号：$redis_server_pid"
  kill -9 $redis_server_pid
  sleep 1
  redis_server_pid=`ps -ef | grep "/opt/redis/bin/redis-server" | grep -v grep | awk '{print $2}'`
  if [ "$redis_server_pid" == "" ];then
      echo -e "进程已杀死！"
      echo -e "等待守护进程启动...\c"
      while true
      do
          redis_server_pid=`ps -ef | grep "/opt/redis/bin/redis-server" | grep -v grep | awk '{print $2}'`
          if [ -n "$redis_server_pid" ];then
              echo -e "\n进程已启动！进程号：$redis_server_pid\c"
              break
          fi
          sleep 1
          ((check_time++))
          echo -e ".\c"
      done
      echo -e ",等待时间$check_time秒！"
      echo -e "测试结束：\c"
      echo -e "\033[32m通过\033[0m\n"	
  else
      echo -e "杀死进程异常！"
      echo -e "测试结束：\c"
      echo -e "\033[31m失败\033[0m\n"
  fi
}


function beam_daemon(){
  echo -e "测试开始："
  check_time=0
  beam_pid=`ps -ef | grep "/opt/rabbitmq/erlang/lib/erlang/erts-10.7/bin/beam.smp" | grep -v grep | awk '{print $2}'`
  sleep 1
  echo -e "开始杀死rabbitMQ进程！进程号：$beam_pid"
  kill -9 $beam_pid
  sleep 1
  beam_pid=`ps -ef | grep "/opt/rabbitmq/erlang/lib/erlang/erts-10.7/bin/beam.smp" | grep -v grep | awk '{print $2}'`
  if [ "$beam_pid" == "" ];then
      echo -e "进程已杀死！"
      echo -e "等待守护进程启动...\c"
      while true
      do
          beam_pid=`ps -ef | grep "/opt/rabbitmq/erlang/lib/erlang/erts-10.7/bin/beam.smp" | grep -v grep | awk '{print $2}'`
          if [ -n "$beam_pid" ];then
              echo -e "\n进程已启动！进程号：$beam_pid\c"
              break
          fi
          sleep 1
          ((check_time++))
          echo -e ".\c"
      done
      echo -e ",等待时间$check_time秒！"
      echo -e "测试结束：\c"
      echo -e "\033[32m通过\033[0m\n"	
  else
      echo -e "杀死进程异常！"
      echo -e "测试结束：\c"
      echo -e "\033[31m失败\033[0m\n"
  fi
}


function consul_server_daemon(){
  echo -e "测试开始："
  check_time=0
  consul_server_pid=`ps -ef | grep "/opt/consul/bin/consul-server" | grep -v grep | awk '{print $2}'`
  sleep 1
  echo -e "开始杀死consul-server进程！进程号：$consul_server_pid"
  kill -9 $consul_server_pid
  sleep 1
  consul_server_pid=`ps -ef | grep "/opt/consul/bin/consul-server" | grep -v grep | awk '{print $2}'`
  if [ "$consul_server_pid" == "" ];then
      echo -e "进程已杀死！"
      echo -e "等待守护进程启动...\c"
      while true
      do
          consul_server_pid=`ps -ef | grep "/opt/consul/bin/consul-server" | grep -v grep | awk '{print $2}'`
          if [ -n "$consul_server_pid" ];then
              echo -e "\n进程已启动！进程号：$consul_server_pid\c"
              break
          fi
          sleep 1
          ((check_time++))
          echo -e ".\c"
      done
      echo -e ",等待时间$check_time秒！"
      echo -e "测试结束：\c"
      echo -e "\033[32m通过\033[0m\n"	
  else
      echo -e "杀死进程异常！"
      echo -e "测试结束：\c"
      echo -e "\033[31m失败\033[0m\n"
  fi
}


function consul_template_daemon(){
  echo -e "测试开始："
  check_time=0
  consul_template_pid=`ps -ef | grep "/opt/consul/bin/consul-template" | grep -v grep | awk '{print $2}'`
  sleep 1
  echo -e "开始杀死consul-template进程！进程号：$consul_template_pid"
  kill -9 $consul_template_pid
  sleep 1
  consul_template_pid=`ps -ef | grep "/opt/consul/bin/consul-template" | grep -v grep | awk '{print $2}'`
  if [ "$consul_template_pid" == "" ];then
      echo -e "进程已杀死！"
      echo -e "等待守护进程启动...\c"
      while true
      do
          consul_template_pid=`ps -ef | grep "/opt/consul/bin/consul-template" | grep -v grep | awk '{print $2}'`
          if [ -n "$consul_template_pid" ];then
              echo -e "\n进程已启动！进程号：$consul_template_pid\c"
              break
          fi
          sleep 1
          ((check_time++))
          echo -e ".\c"
      done
      echo -e ",等待时间$check_time秒！"
      echo -e "测试结束：\c"
      echo -e "\033[32m通过\033[0m\n"	
  else
      echo -e "杀死进程异常！"
      echo -e "测试结束：\c"
      echo -e "\033[31m失败\033[0m\n"
  fi
}


function authorityserver_daemon(){
  echo -e "测试开始："
  check_time=0
  authorityserver_pid1=`ps -ef | grep "/opt/java-service/jdk-1.8-openj9/bin/authorityserver" | grep -v grep | awk '{print $2}'`
  sleep 1
  echo -e "开始杀死authorityserver进程！进程号：$authorityserver_pid1"
  kill -9 $authorityserver_pid1
  sleep 1
  authorityserver_pid2=`ps -ef | grep "/opt/java-service/jdk-1.8-openj9/bin/authorityserver" | grep -v grep | awk '{print $2}'`
  if [ "$authorityserver_pid1" != "$authorityserver_pid2" ];then
      echo -e "进程已杀死！"
      echo -e "等待守护进程启动...\c"
      while true
      do
          authorityserver_pid2=`ps -ef | grep "/opt/java-service/jdk-1.8-openj9/bin/authorityserver" | grep -v grep | awk '{print $2}'`
          if [ -n "$authorityserver_pid2" ];then
              echo -e "\n进程已启动！进程号：$authorityserver_pid2\c"
              break
          fi
          sleep 1
          ((check_time++))
          echo -e ".\c"
      done
      echo -e ",等待时间$check_time秒！"
      echo -e "测试结束：\c"
      echo -e "\033[32m通过\033[0m\n"	
  else
      echo -e "杀死进程异常！"
      echo -e "测试结束：\c"
      echo -e "\033[31m失败\033[0m\n"
  fi
}


function databusserver_daemon(){
  echo -e "测试开始："
  check_time=0
  databusserver_pid1=`ps -ef | grep "/opt/java-service/jdk-1.8-openj9/bin/databusserver" | grep -v grep | awk '{print $2}'`
  sleep 1
  echo -e "开始杀死databusserver进程！进程号：$databusserver_pid1"
  kill -9 $databusserver_pid1
  sleep 1
  databusserver_pid2=`ps -ef | grep "/opt/java-service/jdk-1.8-openj9/bin/databusserver" | grep -v grep | awk '{print $2}'`
  if [ "$databusserver_pid1" != "$databusserver_pid2" ];then
      echo -e "进程已杀死！"
      echo -e "等待守护进程启动...\c"
      while true
      do
          databusserver_pid2=`ps -ef | grep "/opt/java-service/jdk-1.8-openj9/bin/databusserver" | grep -v grep | awk '{print $2}'`
          if [ -n "$databusserver_pid2" ];then
              echo -e "\n进程已启动！进程号：$databusserver_pid2\c"
              break
          fi
          sleep 1
          ((check_time++))
          echo -e ".\c"
      done
      echo -e ",等待时间$check_time秒！"
      echo -e "测试结束：\c"
      echo -e "\033[32m通过\033[0m\n"	
  else
      echo -e "杀死进程异常！"
      echo -e "测试结束：\c"
      echo -e "\033[31m失败\033[0m\n"
  fi
}


function deviceAdapter_daemon(){
  echo -e "测试开始："
  check_time=0
  deviceAdapter_pid1=`ps -ef | grep "/opt/java-service/jdk-1.8-openj9/bin/deviceAdapter" | grep -v grep | awk '{print $2}'`
  sleep 1
  echo -e "开始杀死deviceAdapter进程！进程号：$deviceAdapter_pid1"
  kill -9 $deviceAdapter_pid1
  sleep 1
  deviceAdapter_pid2=`ps -ef | grep "/opt/java-service/jdk-1.8-openj9/bin/deviceAdapter" | grep -v grep | awk '{print $2}'`
  if [ "$deviceAdapter_pid1" != "$deviceAdapter_pid2" ];then
      echo -e "进程已杀死！"
      echo -e "等待守护进程启动...\c"
      while true
      do
          deviceAdapter_pid2=`ps -ef | grep "/opt/java-service/jdk-1.8-openj9/bin/deviceAdapter" | grep -v grep | awk '{print $2}'`
          if [ -n "$deviceAdapter_pid2" ];then
              echo -e "\n进程已启动！进程号：$deviceAdapter_pid2\c"
              break
          fi
          sleep 1
          ((check_time++))
          echo -e ".\c"
      done
      echo -e ",等待时间$check_time秒！"
      echo -e "测试结束：\c"
      echo -e "\033[32m通过\033[0m\n"	
  else
      echo -e "杀死进程异常！"
      echo -e "测试结束：\c"
      echo -e "\033[31m失败\033[0m\n"
  fi
}


function doorscreen_daemon(){
  echo -e "测试开始："
  check_time=0
  doorscreen_pid1=`ps -ef | grep "/opt/java-service/jdk-1.8-openj9/bin/doorscreen" | grep -v grep | awk '{print $2}'`
  sleep 1
  echo -e "开始杀死doorscreen进程！进程号：$doorscreen_pid1"
  kill -9 $doorscreen_pid1
  sleep 1
  doorscreen_pid2=`ps -ef | grep "/opt/java-service/jdk-1.8-openj9/bin/doorscreen" | grep -v grep | awk '{print $2}'`
  if [ "$doorscreen_pid1" != "$doorscreen_pid2" ];then
      echo -e "进程已杀死！"
      echo -e "等待守护进程启动...\c"
      while true
      do
          doorscreen_pid2=`ps -ef | grep "/opt/java-service/jdk-1.8-openj9/bin/doorscreen" | grep -v grep | awk '{print $2}'`
          if [ -n "$doorscreen_pid2" ];then
              echo -e "\n进程已启动！进程号：$doorscreen_pid2\c"
              break
          fi
          sleep 1
          ((check_time++))
          echo -e ".\c"
      done
      echo -e ",等待时间$check_time秒！"
      echo -e "测试结束：\c"
      echo -e "\033[32m通过\033[0m\n"	
  else
      echo -e "杀死进程异常！"
      echo -e "测试结束：\c"
      echo -e "\033[31m失败\033[0m\n"
  fi
}


function licenseserver_daemon(){
  echo -e "测试开始："
  check_time=0
  licenseserver_pid1=`ps -ef | grep "/opt/java-service/jdk-1.8-openj9/bin/licenseserver" | grep -v grep | awk '{print $2}'`
  sleep 1
  echo -e "开始杀死licenseserver进程！进程号：$licenseserver_pid1"
  kill -9 $licenseserver_pid1
  sleep 1
  licenseserver_pid2=`ps -ef | grep "/opt/java-service/jdk-1.8-openj9/bin/licenseserver" | grep -v grep | awk '{print $2}'`
  if [ "$licenseserver_pid1" != "$licenseserver_pid2" ];then
      echo -e "进程已杀死！"
      echo -e "等待守护进程启动...\c"
      while true
      do
          licenseserver_pid2=`ps -ef | grep "/opt/java-service/jdk-1.8-openj9/bin/licenseserver" | grep -v grep | awk '{print $2}'`
          if [ -n "$licenseserver_pid2" ];then
              echo -e "\n进程已启动！进程号：$licenseserver_pid2\c"
              break
          fi
          sleep 1
          ((check_time++))
          echo -e ".\c"
      done
      echo -e ",等待时间$check_time秒！"
      echo -e "测试结束：\c"
      echo -e "\033[32m通过\033[0m\n"	
  else
      echo -e "杀死进程异常！"
      echo -e "测试结束：\c"
      echo -e "\033[31m失败\033[0m\n"
  fi
}


function TdServerCache_daemon(){
  echo -e "测试开始："
  check_time=0
  TdServerCache_pid1=`ps -ef | grep "/opt/java-service/jdk-1.8-openj9/bin/TdServerCache" | grep -v grep | awk '{print $2}'`
  sleep 1
  echo -e "开始杀死TdServerCache进程！进程号：$TdServerCache_pid1"
  kill -9 $TdServerCache_pid1
  sleep 1
  TdServerCache_pid2=`ps -ef | grep "/opt/java-service/jdk-1.8-openj9/bin/TdServerCache" | grep -v grep | awk '{print $2}'`
  if [ "$TdServerCache_pid1" != "$TdServerCache_pid2" ];then
      echo -e "进程已杀死！"
      echo -e "等待守护进程启动...\c"
      while true
      do
          TdServerCache_pid2=`ps -ef | grep "/opt/java-service/jdk-1.8-openj9/bin/TdServerCache" | grep -v grep | awk '{print $2}'`
          if [ -n "$TdServerCache_pid2" ];then
              echo -e "\n进程已启动！进程号：$TdServerCache_pid2\c"
              break
          fi
          sleep 1
          ((check_time++))
          echo -e ".\c"
      done
      echo -e ",等待时间$check_time秒！"
      echo -e "测试结束：\c"
      echo -e "\033[32m通过\033[0m\n"	
  else
      echo -e "杀死进程异常！"
      echo -e "测试结束：\c"
      echo -e "\033[31m失败\033[0m\n"
  fi
}


function TdServerEasy7_daemon(){
  echo -e "测试开始："
  check_time=0
  TdServerEasy7_pid1=`ps -ef | grep "/opt/java-service/jdk-1.8-openj9/bin/TdServerEasy7" | grep -v grep | awk '{print $2}'`
  sleep 1
  echo -e "开始杀死TdServerEasy7进程！进程号：$TdServerEasy7_pid1"
  kill -9 $TdServerEasy7_pid1
  sleep 1
  TdServerEasy7_pid2=`ps -ef | grep "/opt/java-service/jdk-1.8-openj9/bin/TdServerEasy7" | grep -v grep | awk '{print $2}'`
  if [ "$TdServerEasy7_pid1" != "$TdServerEasy7_pid2" ];then
      echo -e "进程已杀死！"
      echo -e "等待守护进程启动...\c"
      while true
      do
          TdServerEasy7_pid2=`ps -ef | grep "/opt/java-service/jdk-1.8-openj9/bin/TdServerEasy7" | grep -v grep | awk '{print $2}'`
          if [ -n "$TdServerEasy7_pid2" ];then
              echo -e "\n进程已启动！进程号：$TdServerEasy7_pid2\c"
              break
          fi
          sleep 1
          ((check_time++))
          echo -e ".\c"
      done
      echo -e ",等待时间$check_time秒！"
      echo -e "测试结束：\c"
      echo -e "\033[32m通过\033[0m\n"	
  else
      echo -e "杀死进程异常！"
      echo -e "测试结束：\c"
      echo -e "\033[31m失败\033[0m\n"
  fi
}


function file_JService_daemon(){
  echo -e "测试开始："
  check_time=0
  file_JService_pid1=`ps -ef | grep "/opt/FileServer/jre/bin/file_JService" | grep -v grep | awk '{print $2}'`
  sleep 1
  echo -e "开始杀死file_JService进程！进程号：$file_JService_pid1"
  kill -9 $file_JService_pid1
  sleep 1
  file_JService_pid2=`ps -ef | grep "/opt/FileServer/jre/bin/file_JService" | grep -v grep | awk '{print $2}'`
  if [ "$file_JService_pid1" != "$file_JService_pid2" ];then
      echo -e "进程已杀死！"
      echo -e "等待守护进程启动...\c"
      while true
      do
          file_JService_pid2=`ps -ef | grep "/opt/FileServer/jre/bin/file_JService" | grep -v grep | awk '{print $2}'`
          if [ -n "$file_JService_pid2" ];then
              echo -e "\n进程已启动！进程号：$file_JService_pid2\c"
              break
          fi
          sleep 1
          ((check_time++))
          echo -e ".\c"
      done
      echo -e ",等待时间$check_time秒！"
      echo -e "测试结束：\c"
      echo -e "\033[32m通过\033[0m\n"	
  else
      echo -e "杀死进程异常！"
      echo -e "测试结束：\c"
      echo -e "\033[31m失败\033[0m\n"
  fi
}


java_tomcat_daemon
java_cassandra_daemon
mysqld_daemon
nginx_sercurity_daemon
redis_server_daemon
beam_daemon
consul_server_daemon
consul_template_daemon
authorityserver_daemon
databusserver_daemon
deviceAdapter_daemon
doorscreen_daemon
licenseserver_daemon
TdServerCache_daemon
TdServerEasy7_daemon
file_JService_daemon
