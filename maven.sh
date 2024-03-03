#!/bin/bash

# install dir
INSTALL_PATH="/opt/maven"

# maven zip
MAVEN_URL="https://archive.apache.org/dist/maven/maven-3/3.9.6/binaries/apache-maven-3.9.6-bin.tar.gz"
MAVEN_TAR="apache-maven-3.9.6-bin.tar.gz"
MAVEN_DIR="apache-maven-3.9.6"

# 安装路径不存在则新建, 存在则清空目录数据
if [ ! -d "${INSTALL_PATH}" ]; then
  mkdir -p ${INSTALL_PATH}
else
  rm -rf ${INSTALL_PATH}/*
fi

cd ${INSTALL_PATH} 

#下载maven到安装目录, 原地解压
wget ${MAVEN_URL} && tar -zxvf ${MAVEN_TAR} -C ${INSTALL_PATH} > /dev/null 2>&1
#wget -P ${INSTALL_PATH} ${MAVEN_URL} && tar -zxvf ${INSTALL_PATH}/${MAVEN_TAR} -C ${INSTALL_PATH} > /dev/null 2>&1
#移除下载包
rm ${MAVEN_TAR}

#重定向输出环境变量文件
echo "export MAVEN_HOME=${INSTALL_PATH}/${MAVEN_DIR}" >> /etc/profile
echo "export PATH=\$PATH:\$MAVEN_HOME/bin" >> /etc/profile

#更新环境变量值
sudo sed -i 's#\(export MAVEN_HOME=\).*#\1${INSTALL_PATH}/${MAVEN_DIR}#' /etc/profile

#sudo sed -i 's/MAVEN_HOME=".*"/MAVEN_HOME="'"${INSTALL_PATH}/${MAVEN_DIR}"'"/g' /etc/source
#sudo sed -i 's/PATH=".*"/PATH="'"$PATH:$MAVEN_HOME/bin"'"/g' /etc/source

#刷新环境变量
source /etc/profile
echo "==============MAVEN VERSION=============="
mvn -v
bash
