#!/bin/bash

# 将逗号替换为空格
# array=${value//,/ }

# 将字符串转为数组,数组元素会以字符串中的空格作为分割
# array=($value)


# 定义一个关联数组,关联数组可以用字符串作为键名,bash版本需要升级,mac默认为3.x,早已过时
declare -A env_config
declare mysql_cmd_string

# 读取配置文件到变量中
readEnvFile()
{
  # 获取文件内容,并将以"#"开头的行过滤掉
  env_content=($(grep -v '^#' .env | xargs))

  # 将.env配置文件内容读取到变量中
  for line in ${env_content[*]}; do
    cell=(${line//=/ })
    env_config[${cell[0]}]=${cell[1]}
  done

  # 读取mysql下的.env配置信息
  mysql_env_content=($(grep -v '^#' ./mysql/.env | xargs))

  for line in ${mysql_env_content[*]}; do
    cell=(${line//=/ })
    env_config[${cell[0]}]=${cell[1]}
  done

  # 如果mysql下的.env配置里有DB_DATABASE则执行创建数据库命令
  if [[ ${env_config[DB_DATABASE]} != "" ]]; then
    mysql_cmd_string="CREATE DATABASE ${env_config[DB_DATABASE]};"
  fi

  # 如果mysql下的.env配置里有DB_USERNAME和DB_PASSWORD则执行创建用户并授权用户
  if [[ ${env_config[DB_USERNAME]} != "" && ${env_config[DB_PASSWORD]} != "" ]]; then
    mysql_cmd_string=$mysql_cmd_string"
    CREATE USER '${env_config[DB_USERNAME]}'@'%' IDENTIFIED BY '${env_config[DB_PASSWORD]}';
    CREATE USER '${env_config[DB_USERNAME]}'@'localhost' IDENTIFIED BY '${env_config[DB_PASSWORD]}';
    ALTER USER '${env_config[DB_USERNAME]}'@'%' IDENTIFIED WITH mysql_native_password BY '${env_config[DB_PASSWORD]}';
    ALTER USER '${env_config[DB_USERNAME]}'@'localhost' IDENTIFIED WITH mysql_native_password BY '${env_config[DB_PASSWORD]}';
    GRANT ALL PRIVILEGES ON *.* TO '${env_config[DB_USERNAME]}'@'%' WITH GRANT OPTION;
    GRANT ALL PRIVILEGES ON *.* TO '${env_config[DB_USERNAME]}'@'localhost' WITH GRANT OPTION;"
  fi
}

# 给MySQL中用户授权,指定用户可远程访问
privilegeMysqlUsers()
{
  delay=10
  echo "等待Mysql服务启动，延时"$delay"s..."
  sleep "$delay"s

  # 在bash中不能加入-t参数,否则会报"the input device is not a TTY"
  # 在远程服务上执行的命令块,"remot_command"可自定义
  # 必须跟在 docker exec 命令行后面
  docker exec -i lnmpr-mysql bash << remot_command
    mysql -uroot -p${env_config[MYSQL_ROOT_PASSWORD]}
    ALTER USER 'root'@'%' IDENTIFIED WITH mysql_native_password BY '${env_config[MYSQL_ROOT_PASSWORD]}';
    $mysql_cmd_string
    FLUSH PRIVILEGES;
    exit
remot_command

  echo "MySQL用户授权完成。lnmpr服务容器已启动，您可以访问 http://localhost:${env_config[NGINX_PORT_LOCAL]} 查看"
}

readEnvFile

case $1 in

  "up" )
    # 以守护模式启动,在后台运行
    docker-compose up -d --build
    privilegeMysqlUsers
    ;;

  "reup" )
      docker-compose down
      docker-compose up -d --build
      privilegeMysqlUsers
    ;;

  * )
    docker-compose $1
    ;;

esac
