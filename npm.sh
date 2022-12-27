#!/bin/bash

#安装目录和压缩包下载目录
INSTALL_PATH="/usr/local/node"

#创建目录结构
mkdir -p /usr/local/node

#下载Node国内镜像到指定目录
wget -P /usr/local/node https://npmmirror.com/mirrors/node/v16.18.1/node-v16.18.1-linux-x64.tar.xz

#解压成tar-> tar文件解压成文件夹 -> 更名
xz -d node-v16.18.1-linux-x64.tar.xz 
tar -xvf node-v16.18.1-linux-x64.tar
mv node-v16.18.1-linux-x64 node-v16.18

#配置软链接, 全局可使用命令
ln -s /usr/local/node/node-v16.18/bin/node /usr/bin/node
ln -s /usr/local/node/node-v16.18/bin/npm /usr/bin/npm

#查询node版本和npm版本
node --version && npm --version

#NPM设置为阿里镜像源(官方地址: https://registry.npmjs.org/)
npm config set registry http://registry.npmmirror.com

#验证镜像源地址
npm config get registry
