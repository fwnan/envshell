#!/bin/bash

#安装目录和压缩包下载目录
INSTALL_PATH="/usr/local/node"

#Node版本信息
DOWN_VSN="latest-v18.x/node-v18.12.1.tar.xz"
NODE_VSN="node-v18.12.1"

#创建目录结构
mkdir -p ${INSTALL_PATH}

#下载Node国内镜像到指定目录
wget -P ${INSTALL_PATH} https://registry.npmmirror.com/-/binary/node/${DOWN_VSN}

#1.解压成tar 2.tar文件解压成文件夹
xz -d ${INSTALL_PATH}/${NODE_VSN}.tar.xz 
tar -xvf ${INSTALL_PATH}/${NODE_VSN}.tar

#配置软链接, 全局可使用命令
ln -s ${INSTALL_PATH}/${NODE_VSN}/bin/node /usr/bin/node
ln -s ${INSTALL_PATH}/${NODE_VSN}/bin/npm /usr/bin/npm

#查询node版本和npm版本
node --version && npm --version

#NPM设置为阿里镜像源(官方地址: https://registry.npmjs.org/)
npm config set registry http://registry.npmmirror.com

#验证镜像源地址
npm config get registry
