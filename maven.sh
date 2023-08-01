#!/bin/bash
#安装目录
INSTALL_PATH="/opt/maven"
#下载地址,压缩包,maven最终目录名
MAVEN_URL="https://dlcdn.apache.org/maven/maven-3/3.9.3/binaries/apache-maven-3.9.3-bin.tar.gz"
MAVEN_TAR="apache-maven-3.9.3-bin.tar.gz"
MAVEN_DIR="apache-maven-3.9.3"

#目录不存在,创建指定目录. 否则移除之前的Maven目录
if [ ! -d "${INSTALL_PATH}" ]; then
  mkdir -p ${INSTALL_PATH}
else
  rm -rf ${INSTALL_PATH}
fi

#下载Maven
wget -P ${INSTALL_PATH} ${MAVEN_URL}
#解压指定目录的maven压缩包
tar -zxvf ${INSTALL_PATH}/${MAVEN_TAR} -C ${INSTALL_PATH} > /dev/null 2>&1
#移除下载包
mv ${INSTALL_PATH}/${MAVEN_TAR} /dev/null

#重定向输出环境变量文件
echo "export MAVEN_HOME=${INSTALL_PATH}/${MAVEN_DIR}" >> /etc/profile
echo "export PATH=\$PATH:\$MAVEN_HOME/bin" >> /etc/profile
#刷新环境变量
source /etc/profile
echo "===Maven版本信息==="
mvn -v
#执行bash,让脚本环境与外部linux一致
bash
