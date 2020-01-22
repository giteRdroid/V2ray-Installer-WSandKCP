
# V2ray-Installer-WSandKCP English
This script made from Uncle Dong's script,but it had been modified,it can build project V with KCP or WebSocks into your server

## This script only be used in CentOS and Fedora,other system can't use this script to install

## Install
Please use this command

    bash <(curl -L -s https://raw.githubusercontent.com/Rickdroid/V2ray-Installer-WSandKCP/master/install.sh)

this script can only build for server,you can fill the configuration in your client application

## Attention
If you use WebSocks,you should made your domain available before you install

If you are using caddy to run your website,you should backup your caddy.conf,because this script will lose your configuration

----

# V2ray-Installer-WSandKCP Chinese
本脚本基于栋叔的脚本制作而来，魔改了原来的脚本内容，实现快速搭建基于KCP或者WebSocks代理梯子

## 本脚本仅测试通过CentOS和Fedora，其他系统请不要使用，特别是基于Debian的

## 使用方法:
运行以下命令安装

    bash <(curl -L -s https://raw.githubusercontent.com/Rickdroid/V2ray-Installer-WSandKCP/master/install.sh)

本脚本仅支持服务器端搭建，客户端请另外修改配置文件。

## 注意事项
选择WebSocks方式一定要先解析了域名再使用脚本安装

如果你在使用caddy建站，那么请先备份保存以下自己caddy的配置文件，工具安装过程原站点配置信息100%丢失

脚本比较简陋，仅适合个人使用，以后有机会有精力有时间有条件再慢慢完善。

----

# V2ray-Installer-WS and KCP about Nginx Chinese
以上脚本及相关由小R酱收集制作，下面主要用于记录如何使用`Nginx`作为WebService。实现WebSocket+TLS+Nginx搭建梯子。

## TLS （证书获取及安装）
TLS 是证书认证机制，所以使用 TLS 需要证书，证书也有免费付费的，同样的这里使用免费证书，证书认证机构为 Let's Encrypt。
证书的生成有许多方法，这里使用的是比较简单的方法：使用 acme.sh 脚本生成。<br>
>  ### 安装 acme.sh
>> 安装`acme.sh`依赖项：<br>
>> ```sudo apt-get -y install netcat```<br>

>> 执行以下命令，`acme.sh` 会安装到 `~/.acme.sh` 目录下。<br>
>> ``` curl  https://get.acme.sh | sh```<br>
>  ### 使用acme.sh生成证书<br>
>> 生成证书时，脚本会临时监听80端口，需要先解除占用。(`mydomain.me`为证书名称，可自行修改。)<br>
>> ```sudo ~/.acme.sh/acme.sh --issue -d mydomain.me --standalone -k ec-256```
> ###  安装证书和密钥
>> 将证书和密钥安装到 `/etc/v2ray` 中：<br>
>> * ECC 证书：	```sudo ~/.acme.sh/acme.sh --installcert -d mydomain.me --fullchainpath /etc/v2ray/v2ray.crt --keypath /etc/v2ray/v2ray.key --ecc```<br>
>> * RSA 证书：	```sudo ~/.acme.sh/acme.sh --installcert -d mydomain.me --fullchainpath /etc/v2ray/v2ray.crt --keypath /etc/v2ray/v2ray.key```<br>
> （PS：无论什么情况，密钥(即上面的v2ray.key)都不能泄漏，如果你不幸泄漏了密钥，可以使用 acme.sh 将原证书吊销，再生成新的证书，吊销方法请自行参考 acme.sh 的手册）<br>

## Nginx配置
懒得写脚本了，亲，请自行在`nginx.conf`中添加以下代码（按自己需要修改即可）：
```
server {
  listen 443 ssl;
  ssl on;	# 如果Nginx无法重启或启动（报警告），请删除或注释掉此行
  ssl_certificate       /etc/v2ray/v2ray.crt;	# 证书的路径
  ssl_certificate_key   /etc/v2ray/v2ray.key;	# 密钥的路径
  ssl_protocols         TLSv1 TLSv1.1 TLSv1.2;
  ssl_ciphers           HIGH:!aNULL:!MD5;
  server_name           mydomain.me;	# 域名，与V2ray配置中一样
    location /ray { 			# 与 V2Ray 配置中的 path 保持一致
      if ($http_upgrade != "websocket") {	# WebSocket协商失败时返回404
          return 404;
      }
      proxy_redirect off;
      proxy_pass http://127.0.0.1:10000; 	# 假设WebSocket监听在环回地址的10000端口上
      proxy_http_version 1.1;
      proxy_set_header Upgrade $http_upgrade;
      proxy_set_header Connection "upgrade";
      proxy_set_header Host $host;
      # Show real IP in v2ray access.log
      proxy_set_header X-Real-IP $remote_addr;
      proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    }
}
```