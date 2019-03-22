
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
