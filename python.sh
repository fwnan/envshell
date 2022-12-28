#!/bin/bash

#安装目录和压缩包下载目录
INSTALL_PATH="/opt/python3"
​
#创建目录结构
mkdir -p ${INSTALL_PATH}

DOWNLOAD=python/3.9.9/Python-3.9.9.tgz
VERSION=Python-3.9.9

#下载国内镜像到指定目录
wget -P ${INSTALL_PATH} https://registry.npmmirror.com/-/binary/${DOWNLOAD}
​
#跳转到该目录后解压
cd ${INSTALL_PATH} && tar -zxvf ${VERSION}.tgz
​
#进入Python源码文件夹
cd ${INSTALL_PATH}/${VERSION}
​
#安装依赖
yum -y install zlib-devel bzip2-devel openssl-devel ncurses-devel sqlite-devel readline-devel tk-devel gdbm-devel db4-devel libpcap-devel xz-devel
​
#配置编译的安装目录, 设置启用ssl.
./configure --prefix=${INSTALL_PATH} --with-ssl
​
#编译并安装
make && make install
​
#建立python3和pip3软链接
ln -s ${INSTALL_PATH}/bin/python3 /usr/bin/python3 && ln -s ${INSTALL_PATH}/bin/pip3 /usr/bin/pip3
​
#输出配置情况
python3 -V && pip3 -V
​
#生成配置文件, 配置pip3为阿里云镜像源
pip3 config set global.index-url https://mirrors.aliyun.com/pypi/simple/
​
#测试Pip3镜像是否可用
pip3 install virtualenv
