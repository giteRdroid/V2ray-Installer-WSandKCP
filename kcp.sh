#!/bin/bash

kcpInstaller(){
	getConfig
	userInput
	firewalldOpen	
	messageOutput
	endInstall
}

getConfig(){
	cd /etc/v2ray
	rm -rf /etc/v2ray/config.json
	wget https://raw.githubusercontent.com/Rickdroid/V2ray-Installer-WSandKCP/master/Config/config-mkcp.json
	mv /etc/v2ray/config-mkcp.json /etc/v2ray/config.json 
}

userInput(){
	read -p "输入alterID(可不填，不填默认16):" alterID
	alteridGet
	read -p "输入kcp使用的端口:" port
	portGet
	uuidSet=`cat /proc/sys/kernel/random/uuid`
	uuidGet
	ipGet=`curl ifconfig.me`
}

firewalldOpen(){
  	firewall-cmd --permanent --add-port=${port}/tcp --add-port=${port}/udp
  	firewall-cmd --reload
	systemctl start firewalld
  	echo "${port}端口已经放行"
}

portGet(){
	sed -i "s/9393/${port}/g" /etc/v2ray/config.json
}

alteridGet(){
	if [ -n "${alterID}" ]
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

messageOutput(){
	messOut="
	安装完成，请到v2rayNG或者v2rayN填入下面的信息
	————————————————————————————————————————————————
	别名(remarks)：kcp
	地址(address)：${ipGet}
	端口(port)：${port}
	用户ID(id)：${uuidSet}
	额外ID(alterId)：${alterID}         //可以填其他值，但不能大于服务端的设置
	加密方式(security)：auto
	传输协议(network)：kcp
	功能设置（不清楚则保持默认值）
	伪装类型(type)：none
	伪装域名host(host/ws host/h2 host)：         //此项留空
	path(ws path/h2 path)：         //此项留空
	底层传输安全TLS：         //此项留空
	"
}

endInstall(){
  	systemctl enable v2ray
  	systemctl restart v2ray	
	mkdir /root/v2raymessage/
	touch /root/v2raymessage/kcp.txt
	echo "${messOut}" > /root/v2raymessage/kcp.txt
	echo "${messOut}"
	exit
}

kcpInstaller
