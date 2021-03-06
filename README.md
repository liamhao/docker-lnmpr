# docker-lnmpr
搭建一个`Larave`+`Nginx`+`MySQL`+`PHP`+`Redis`自动化的`Docker`部署程序

## 优势
- 一键启动容器，资源占用小。
- 包含`PHP 8.0`、`MySQL 8.0`、`Redis`、`Nginx`开发环境，启动后立即可用，无需其他操作。
- 根据`.env`配置文件生成容器，可自行配置所需服务版本。
- `PHP`服务默认会安装`pdo_mysql`和`redis`和`pcntl`扩展，免去手动操作。
> `pcntl`扩展是因为`laravel/horizon`扩展包需要用到

## 使用
1. 安装`Docker`和`Docker Compose`两个程序。可参考[这里](https://docs.docker.com/compose/install)
2. 下载本项目到本地。
```bash
$ git clone https://github.com/liamhao/docker-lnmpr.git
```
3. 进入项目目录，复制一份配置文件，并根据自己的需求进行修改
```bash
$ cd docker-lnmpr

$ cp .env.example .env

$ cp mysql/.env.example mysql/.env
```
4. 项目中访问`MySQL`和`Redis`服务，需要修改`Laravel`项目中的`.env`文件。将`DB_HOST`的值改为`lnmpr-mysql`，`REDIS_HOST`的值改为`lnmpr-redis`
```bash
DB_HOST=lnmpr-mysql

REDIS_HOST=lnmpr-redis
```
5. 执行启动程序。此过程需要通过网络下载资源，启动时间会根据您当前的网络状况而定。出现`[Warning]`提示可以忽略。
```bash
$ chmod 777 lnmpr.sh

$ ./lnmpr.sh up
```
6. 完成啦！可以访问`localhost`看下效果了～

## 注意事项

- `Mac`系统下:
如果报错`Mounts denied: approving /path/to/work: file does not exist`。需要打开`Docker`的设置面板，点击`Experimental Features`标签，关闭`Use gRPC FUSE for file sharing`选项

- 修改挂载的文件路径后，需要执行`./lnmpr.sh reup`才会生效，此命令会删除已生成的容器，然后重新构建容器。**容器内的数据会丢失**

- 如果修改`php`服务的端口映射`PHP_PORT_DOCKER`参数，需要同步修改`default.conf`中`fastcgi_pass`后面对应的端口号

- 一定要保证 **`NGINX_WORK_DIR_DOCKER`** 和 **`PHP_WORK_DIR_DOCKER`** 的值保持一致，否则会出现静态文件可以正常访问，但`php`文件却访问不到

- 配置文件中不能有空格，空格后的信息将被忽略

- 在执行类似`php artisan migrate`的命令时，需要进入`lnmpr-php`容器内执行命令
```bash
$ docker exec -it lnmpr-php bash

root@66472e3dff92:/var/www/html# php artisan migrate
```

## 常用命令

- ./lnmpr.sh reup
> 重建，将已有的容器删除，重新读取配置文件，生成新容器

- ./lnmpr.sh up
> 新建，读取配置文件，生成新容器

- ./lnmpr.sh down
> 删除，将已有的容器删除

- ./lnmpr.sh restart
> 重启，相当于`stop`后执行`start`

- ./lnmpr.sh stop
> 停止运行中的容器

- ./lnmpr.sh start
> 启动存在的容器

- 其他相关命令参考[docker](https://docs.docker.com/engine/reference/commandline/cli)和[docker-compose](https://docs.docker.com/compose/reference/overview/)

## 配置信息

### .env

- **`Nginx`相关**
    + **NGINX_VERSION**
    > `Nginx`服务版本
    + **NGINX_PORT_LOCAL**
    > 本机端口映射，用来接收网络请求，访问本机`NGINX_PORT_LOCAL`端口会转发到`Nginx`服务容器中的`NGINX_PORT_DOCKER`端口
    + **NGINX_PORT_DOCKER**
    > `Nginx`服务容器端口，用来接收网络请求
    + **NGINX_CONF_LOCAL**
    > 本机的`conf.d`文件夹位置，建议保持默认，用来配置`Nginx`服务
    + **NGINX_CONF_DOCKER**
    > `Nginx`服务容器中的`conf.d`配置文件位置，建议保持默认，用来配置`Nginx`服务
    + **NGINX_WORK_DIR_LOCAL**
    > 本机静态页文件位置，支持相对路径和绝对路径
    + **NGINX_WORK_DIR_DOCKER**
    > `Nginx`服务容器静态页文件位置，建议保持默认

- **`MySQL`相关**
    + **MYSQL_VERSION**
    > `MySQL`服务版本
    + **MYSQL_PORT_LOCAL**
    > 本机端口映射，用来接收网络请求，访问本机`MYSQL_PORT_LOCAL`端口会转发到`MySQL`服务容器中的`MYSQL_PORT_DOCKER`端口
    + **MYSQL_PORT_DOCKER**
    > `MySQL`服务容器端口，用来接收网络请求
    + **MYSQL_ROOT_PASSWORD**
    > `MySQL`服务容器初始化时，需要提供`root`账户的默认密码，用来设置`root`账户的默认密码
    + **MYSQL_DATA_LOCAL**
    > 本机数据库文件位置映射，用来保存数据库数据，防止重建容器后被数据库被删除
    + **MYSQL_DATA_DOCKER**
    > `MySQL`服务数据库文件位置

- **`PHP`相关**
    + **PHP_VERSION**
    > `PHP`服务版本
    + **PHP_WORK_DIR_LOCAL**
    > 本机项目文件位置，支持相对路径和绝对路径
    + **PHP_WORK_DIR_DOCKER**
    > `PHP`服务容器项目文件位置，支持相对路径和绝对路径，建议保持默认
    + **PHP_PORT_LOCAL**
    > 本机端口映射，用来接收网络请求，访问本机`PHP_PORT_LOCAL`端口会转发到`PHP`服务容器中的`PHP_PORT_DOCKER`端口
    + **PHP_PORT_DOCKER**
    > `PHP`服务容器端口，用来接收网络请求

- **`Redis`相关**
    + **REDIS_VERSION**
    > `Redis`服务版本
    + **REDIS_PORT_LOCAL**
    > 本机端口映射，用来接收网络请求，访问本机`REDIS_PORT_LOCAL`端口会转发到`Redis`服务容器中的`REDIS_PORT_DOCKER`端口
    + **REDIS_PORT_DOCKER**
    > `Redis`服务容器端口，用来接收网络请求

### mysql/.env

- **`Laravel`相关**
    + **DB_DATABASE**
    > 同`Laravel`项目中`.env`文件中`DB_DATABASE`参数的值。在`MySQL`容器启动后会自动创建此`DB_DATABASE`
    + **DB_USERNAME**
    > 同`Laravel`项目中`.env`文件中`DB_USERNAME`参数的值。在`MySQL`容器启动后会自授权此`DB_USERNAME`
    + **DB_PASSWORD**
    > 同`Laravel`项目中`.env`文件中`DB_PASSWORD`参数的值。在`MySQL`容器启动后会自动授权`DB_USERNAME`用户以`DB_PASSWORD`登陆