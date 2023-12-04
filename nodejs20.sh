#!/bin/bash

#安装目录. 注: /usr/local目录需要配置环境变量才有权限执行命令,最好选择/opt或者/usr
INSTALL_PATH="/opt/nodejs"
#下载地址, NODE最终安装名
NODEJS_URL="https://mirrors.aliyun.com/nodejs-release/v20.10.0/node-v20.10.0-linux-x64.tar.xz"
NODE_NAME="node-v20.10.0-linux-x64"

#目录不存在,创建指定目录,否则移除
if [ ! -d "${INSTALL_PATH}" ]; then
  mkdir -p ${INSTALL_PATH}
else
  rm -rf ${INSTALL_PATH}
fi

#下载Nodejs
wget -P ${INSTALL_PATH} ${NODEJS_URL}

cd ${INSTALL_PATH}
#1.解压成tar 2.tar文件解压成文件夹. 静默解压
xz -d ${NODE_NAME}.tar.xz > /dev/null 2>&1
tar -xvf ${NODE_NAME}.tar > /dev/null 2>&1

#删除当前目录的压缩包
find . -type f \( -name "*.tar" -o -name "*.xz" \) -delete

#配置软链接,全局可用命令
ln -sf ${INSTALL_PATH}/${NODE_NAME}/bin/node /usr/bin/node
ln -sf ${INSTALL_PATH}/${NODE_NAME}/bin/npm /usr/bin/npm

echo "===Node and Npm==="
#查询node版本和npm版本
node -v && npm -v
#npm设置阿里镜像源(https://registry.npmjs.org)
npm config set registry http://registry.npmmirror.com --global
#验证镜像源地址
npm config get registry
