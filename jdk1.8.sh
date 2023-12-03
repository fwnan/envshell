#!/bin/bash

#安装目录
INSTALL_PATH="/opt/java"
#下载地址,压缩包,JDK目录名
JDK_URL="https:/mirrors.huaweicloud.com/java/jdk/8u202-b08/jdk-8u202-linux-x64.tar.gz"
JDK_TAR="jdk-8u202-linux-x64.tar.gz"
JDK_NAME="jdk8"

#目录不存在,创建指定目录,否则移除目录内容
if [ ! -d "${INSTALL_PATH}" ]; then
  mkdir -p ${INSTALL_PATH}
else
  rm -rf ${INSTALL_PATH}/*
fi

#移动到空内容的安装目录
cd ${INSTALL_PATH}

#下载JDK
wget ${JDK_URL}
#静默解压
tar -zxvf ${JDK_TAR} > /dev/null 2>&1

#jdk解压目录改名
mv jdk1.8.0_202 ${JDK_NAME}

#删除${INSTALL_PATH}的压缩包
find ${INSTALL_PATH} -type f \( -name "*.tar" -o -name "*.gz" \) -delete

#重定向输出环境变量文件
echo "export JAVA_HOME=${INSTALL_PATH}/${JDK_NAME}" >> /etc/profile
echo "export PATH=\$JAVA_HOME/bin:\$PATH" >> /etc/profile

#刷新环境变量
source /etc/profile
java -version
#执行bash,让shell环境与外部linux一致
bash
