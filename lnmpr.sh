#!/bin/bash

# 将逗号替换为空格
# array=${value//,/ }

# 将字符串转为数组,数组元素会以字符串中的空格作为分割
# array=($value)

if [ "$1" = "up" ]
then

# 获取文件内容,并将以"#"开头的行过滤掉
env_content=($(grep -v '^#' .env | xargs))

# 定义一个关联数组,关联数组可以用字符串作为键名,bash版本需要升级,mac默认为3.x,早已过时
declare -A env_config

# 将.env配置文件内容读取到变量中
for line in ${env_content[*]}
do
  cell=(${line//=/ })
  env_config[${cell[0]}]=${cell[1]}
done

# 以守护模式启动,在后台运行
docker-compose up -d --build

# 在bash中不能加入-t参数,否则会报"the input device is not a TTY"
# 在远程服务上执行的命令块,"remot_command"可自定义
# 必须跟在 docker exec 命令行后面
# msyql登陆命令需要写全参数,否则会因为默认的my.conf中bind_address=127.0.0.1
# docker exec -i lnmpr-mysql bash << remot_command

# mysql -hlocalhost -uroot -p${env_config[MYSQL_ROOT_PASSWORD]} --port=${env_config[MYSQL_PORT_DOCKER]}

# ALTER USER 'root'@'%' IDENTIFIED WITH mysql_native_password BY "${env_config[MYSQL_ROOT_PASSWORD]}";

# FLUSH PRIVILEGES;

# exit

# remot_command

  
else
  docker-compose $1
fi


