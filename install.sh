#!/bin/bash

beginnIng="
        ===== ===== ===== ===== ===== ===== ===== ===== ===== =====
				V2ray安装
				
        此脚本用于安装V2ray的kcp模式或者WebSocket反代模式
				
        此脚本只适用CentOS和Fedora。
				
	运行脚本前先确保当前是最高权限状态，否则先运行sudo su

        ===== ===== ===== ===== ===== ===== ===== ===== ===== =====
        输入 Y 继续安装，输入 n 退出安装，或者按 Ctrl + C 结束。
"

prepareInstall(){
  echo -e "${beginnIng}"
  while true; do
    read -p "是否安装V2ray代理? [Y/n]" yN
    case ${yN} in 
      [yY]* ) echo -e "\n 确定安装 \n "; v2rayInstaller; break; exit 0;;
      [nN]* ) echo -e "\n 已经退出安装 \n"; exit 0;;
      * ) echo -e "\n 请输入 Y 或者 n \n";;
    esac
  done
}

v2rayInstaller(){
  	echo -e "\n ===== 安装v2ray ===== \n"
  	bash <(curl -L -s https://install.direct/go.sh)
  	while true; do
		echo "支持安装的代理方式:" 
		echo -e "\n 1. KCP模式"
		echo -e "\n 2. WebSocket模式"
		read -p "请输入你想要使用的代理方式:" aMethod
		case ${aMethod} in
			1 ) 
			bash <(curl -L -s https://raw.githubusercontent.com/Rickdroid/V2ray-Installer-WSandKCP/master/kcp.sh); break; exit 0;;
			2 ) 
			bash <(curl -L -s https://raw.githubusercontent.com/Rickdroid/V2ray-Installer-WSandKCP/master/websocks.sh); break; exit 0;;
			* ) echo -e "\n 请输入 1 或者 2 \n" ;;
		esac
  done
}

prepareInstall
