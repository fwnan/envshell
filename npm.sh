#!/bin/bash

#安装目录和压缩包下载目录
#注: /usr/local目录需要配置环境变量才有权限执行命令,最好选择/opt或者/usr
INSTALL_PATH="/opt/node"

#创建目录结构
mkdir -p ${INSTALL_PATH}

DOWNLOAD=node/latest-v18.x/node-v18.12.1-linux-x64.tar.xz
VERSION=node-v18.12.1-linux-x64

#下载Node国内镜像到指定目录
wget -P ${INSTALL_PATH} https://registry.npmmirror.com/-/binary/${DOWNLOAD}

#1.解压成tar 2.tar文件解压成文件夹
cd ${INSTALL_PATH}
xz -d ${VERSION}.tar.xz 
tar -xvf ${VERSION}.tar 

#配置软链接, 全局可使用命令
ln -s ${INSTALL_PATH}/${VERSION}/bin/node /usr/bin/node
ln -s ${INSTALL_PATH}/${VERSION}/bin/npm /usr/bin/npm

#查询node版本和npm版本
node --version && npm --version

#NPM设置为阿里镜像源(官方地址: https://registry.npmjs.org/)
npm config set registry http://registry.npmmirror.com --global

#验证镜像源地址
npm config get registry
