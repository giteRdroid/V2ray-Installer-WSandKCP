#!/bin/bash

useTips(){
	beforeTips="
ws代理方式是直接用Caddy+V2ray的方式进行反向代理，要注意以下两点内容
===================================================================
1. 如果你在使用caddy建站，那么请先备份保存以下自己caddy的配置文件，
工具安装过程中100%覆盖原来的信息，原来的信息100%丢失，所以安装前先
确认保存好自己的原配置信息（如果没有用caddy建站可忽略）
2. 请使用ws代理方式前，先确保用于反向代理的域名已经解析过了或者已经
通过了CDN的解析，如果域名没有进行DNS解析的话，将无法成功代理和使用"
	echo -e "${beforeTips}"
}

prepareInstall(){
	useTips
	read -p "确认使用ws代理? [Y/n]" -n 1 yN
	case ${yN} in 
    		[yY]* ) echo -e "\n 确定安装 \n "; wsInstall; break;;
  		[nN]* ) echo -e "\n 退出安装 \n"; exit;;
	esac
}

wsInstall(){
	caddyInstaller
	webSite
	getV2config
	getCaddyconfig
	userInput
	firewalldOpen	
	messageOutput
	endInstall
}

getV2config(){
	cd /etc/v2ray
	rm -rf /etc/v2ray/config.json
	wget https://raw.githubusercontent.com/Rickdroid/V2ray-Installer-WSandKCP/master/Config/config-ws%2Btls%2Bcdn.json
	mv /etc/v2ray/config-ws+tls+cdn.json /etc/v2ray/config.json 
}

getCaddyconfig(){
	cd /etc/caddy
	rm -rf caddy.conf
	wget https://raw.githubusercontent.com/Rickdroid/V2ray-Installer-WSandKCP/master/Config/caddy-ws.conf
	mv /etc/caddy/caddy-ws.conf /etc/caddy/caddy.conf 
}

caddyInstaller(){
 	echo -e "\n ===== 安装caddy ===== \n"
  	yum install caddy
}

userInput(){
  	read -p "输入你要使用的域名:" domainName
  	read -p "输入使用的path(请注意前面要输入\"/\"):" pathAgent
	read -p "输入网站的根目录(即站点路径),(请注意前面要输入\"/\"):" pathWebsite
	caddyGet
	read -p "输入alterID(可不填，不填默认16):" alterID
	alteridGet
	uuidSet=`cat /proc/sys/kernel/random/uuid`
	uuidGet
	pathwebGet
	ipGet=`curl ifconfig.me`
}

firewalldOpen(){
  	firewall-cmd --permanent --add-service=http --add-service=https
  	firewall-cmd --reload
	systemctl start firewalld
  	echo "${port}端口已经放行"
}

caddyGet(){
	sed -i "1c ${domainName} {" /etc/caddy/caddy.conf
	sed -i "s#/cadd2ray#${pathAgent}#g" /etc/caddy/caddy.conf
	sed -i "s/自定义端口号/9595/g" /etc/caddy/caddy.conf
	sed -i "s#/站点连接#${pathWebsite}#g" /etc/caddy/caddy.conf
}

alteridGet(){
	if [ -n "alterID" ]
	then
		sed -i "s/16/${alterID}/g" /etc/v2ray/config.json
	else
		sed -i "s/16/16/g" /etc/v2ray/config.json
		alterID=16
	fi
}

uuidGet(){
	sed -i "s/uuid/${uuidSet}/g" /etc/v2ray/config.json
}

pathwebGet(){
	sed -i "s#/cadd2ray#${pathAgent}#g" /etc/v2ray/config.json
}

webSite(){
	wget https://github.com/Rickdroid/V2ray-Installer-WSandKCP/raw/master/web/web.zip
	mkdir -p ${pathWebsite}
	unzip -d ${pathWebsite} web.zip
	rm -rf web.zip
}

messageOutput(){
	messOut="
	安装完成，请到v2rayNG或者v2rayN填入下面的信息
	配置信息位置：/root/v2raymessage/ws.txt
	————————————————————————————————————————————————
	别名(remarks)：ws
	地址(address)：${domainName}
	端口(port)：443
	用户ID(id)：${uuidSet}
	额外ID(alterId)：${alterID}         //可以填其他值，但不能大于服务端的设置
	加密方式(security)：auto
	传输协议(network)：ws
	功能设置（不清楚则保持默认值）
	伪装类型(type)：none
	伪装域名host(host/ws host/h2 host)：         //此项留空
	path(ws path/h2 path)：${pathAgent}
	底层传输安全：tls
	"
}

endInstall(){
  	systemctl enable v2ray
  	systemctl restart v2ray	
	systemctl enable caddy
  	systemctl restart caddy
	mkdir /root/v2raymessage/	
	touch /root/v2raymessage/ws.txt
	echo "${messOut}" > /root/v2raymessage/ws.txt
	echo "${messOut}"
	exit
}

prepareInstall
