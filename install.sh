#!/bin/bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

curPath=`pwd`
rootPath=$(dirname "$curPath")
rootPath=$(dirname "$rootPath")
serverPath=$(dirname "$rootPath")


_os=`uname`
if [ ${_os} == "Darwin" ]; then
	OSNAME='macos'
elif grep -Eqi "CentOS" /etc/issue || grep -Eq "CentOS" /etc/*-release; then
	OSNAME='centos'
elif grep -Eqi "Fedora" /etc/issue || grep -Eq "Fedora" /etc/*-release; then
	OSNAME='fedora'
elif grep -Eqi "Rocky" /etc/issue || grep -Eq "Rocky" /etc/*-release; then
	OSNAME='rocky'
elif grep -Eqi "AlmaLinux" /etc/issue || grep -Eq "AlmaLinux" /etc/*-release; then
	OSNAME='alma'
elif grep -Eqi "Debian" /etc/issue || grep -Eq "Debian" /etc/*-release; then
	OSNAME='debian'
elif grep -Eqi "Ubuntu" /etc/issue || grep -Eq "Ubuntu" /etc/*-release; then
	OSNAME='ubuntu'
elif grep -Eqi "Raspbian" /etc/issue || grep -Eq "Raspbian" /etc/*-release; then
	OSNAME='raspbian'
else
	OSNAME='unknow'
fi


if [ "${OSNAME}" == "debian" ] || [ "${OSNAME}" == "ubuntu" ];then
	apt update -y
	apt install -y build-essential
	apt install -y rcs libpcre3-dev libexpat1-dev libssl-dev libgeoip-dev libudns-dev zlib1g-dev libxml2 libxml2-dev libpng-dev openssl git
fi

if [ "${OSNAME}" == "centos" ] || [ "${OSNAME}" == "fedora" ] || [ "${OSNAME}" == "rocky" ] || [ "${OSNAME}" == "alma" ] ;then
	yum install -y epel-release
	yum install -ygcc gcc-c++ make autoconf glibc rcs git
	yum install -y pcre-devel openssl-devel expat-devel geoip-devel zlib-devel udns-devel
fi


action=$1
type=$2

VERSION=$2
install_tmp=${rootPath}/tmp/mw_install.pl
openLSDir=${serverPath}/source/openlitespeed

# if id www &> /dev/null ;then 
#     echo "www UID is `id -u www`"
#     echo "www Shell is `grep "^www:" /etc/passwd |cut -d':' -f7 `"
# else
#     groupadd www
# 	useradd -g www -s /sbin/nologin www
# fi

# cd /www/server/mdserver-web/plugins/openlitespeed && /bin/bash install.sh install 1.7.16

Install_app()
{
	mkdir -p ${openLSDir}
	echo '正在安装脚本文件...' > $install_tmp

	if [ ! -f ${openLSDir}/openlitespeed-${VERSION}.src.tgz ];then
		wget -O ${openLSDir}/openlitespeed-${VERSION}.src.tgz https://openlitespeed.org/packages/openlitespeed-${VERSION}.src.tgz
	fi

	if [ ! -d ${openLSDir}/openlitespeed-${VERSION} ];then
		cd ${openLSDir} && tar -zxvf openlitespeed-${VERSION}.src.tgz
	fi

	cd ${openLSDir}/openlitespeed-${VERSION} && ./configure \
	--prefix=$serverPath/openlitespeed \
	--with-zlib=${serverPath}/lib/zlib

	make && make install && make clean

	if [ -d $serverPath/openlitespeed ];then
		echo "${VERSION}" > $serverPath/openlitespeed/version.pl
    fi
	echo '安装完成' > $install_tmp
}

Uninstall_app()
{
	rm -rf $serverPath/openlitespeed
	
	if [ -f /lib/systemd/system/openlitespeed.service ];then
		rm -rf /lib/systemd/system/openlitespeed.service
	fi
	echo '卸载完成' > $install_tmp
}

action=$1
if [ "${1}" == 'install' ];then
	Install_app
else
	Uninstall_app
fi
