#!/bin/bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

curPath=`pwd`
rootPath=$(dirname "$curPath")
rootPath=$(dirname "$rootPath")
serverPath=$(dirname "$rootPath")


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

	if [ ! -d {openLSDir}/openlitespeed-${VERSION} ];then
		cd ${openLSDir} && tar -zxvf openlitespeed-${VERSION}.src.tgz
	fi

	cd ${openLSDir}/openlitespeed-${VERSION} && ./configure \
	--prefix=$serverPath/openlitespeed 

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
