#!/bin/bash

#安装目录
INSTALL_PATH="/opt/java"
#下载地址,压缩包,JDK目录名
JDK_URL="https://repo.huaweicloud.com/openjdk/17/openjdk-17_linux-x64_bin.tar.gz"
JDK_TAR="openjdk-17_linux-x64_bin.tar.gz"
JDK_NAME="jdk-17"

#目录不存在,创建指定目录,否则移除
if [ ! -d "${INSTALL_PATH}" ]; then
  mkdir -p ${INSTALL_PATH}
else
  rm -rf ${INSTALL_PATH}
fi

#下载JDK
wget -P ${INSTALL_PATH} ${JDK_URL}
#静默解压
tar -zxvf ${INSTALL_PATH}/${JDK_TAR} -C ${INSTALL_PATH} > /dev/null 2>&1
#删除压缩包
find . -type f \( -name "*.tar" -o -name "*.gz" \) -delete

#重定向输出环境变量文件
echo "export JAVA_HOME=${INSTALL_PATH}/${JDK_NAME}" >> /etc/profile
echo "export PATH=\$JAVA_HOME/bin:\$PATH" >> /etc/profile

#刷新环境变量
source /etc/profile
java -version
#执行bash,让shell环境与外部linux一致
bash
