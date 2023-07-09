#!/bin/bash

#安装目录和压缩包下载目录, 注: /usr/local目录需要配置环境变量才有权限执行命令,最好选择/opt或者/usr
INSTALL_PATH="/opt/nodejs"

#nodejs下载地址
WGET_NODE_URL=https://registry.npmmirror.com/-/binary/node/v20.4.0/node-v20.4.0-linux-x64.tar.xz

#node version
VERSION=node-v20.4.0-linux-x64

#创建目录
mkdir -p ${INSTALL_PATH}
#下载Node到指定目录
wget -P ${INSTALL_PATH} ${WGET_NODE_URL}

cd ${INSTALL_PATH}
#1.解压成tar 2.tar文件解压成文件夹
xz -d ${VERSION}.tar.xz && tar -xvf ${VERSION}.tar

#配置软链接,全局可用命令
ln -sf ${INSTALL_PATH}/${VERSION}/bin/node /usr/bin/node
ln -sf ${INSTALL_PATH}/${VERSION}/bin/npm /usr/bin/npm

#查询node版本和npm版本
node -v && npm -v

#npm设置阿里镜像源(https://registry.npmjs.org)
npm config set registry http://registry.npmmirror.com --global

#验证镜像源地址
npm config get registry
