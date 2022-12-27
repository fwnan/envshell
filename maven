#!/bin/bash

#安装目录
INSTALL_PATH="/opt/maven"
MAVEN_TAR_GZ=apache-maven-3.8.6-bin.tar.gz
MAVEN_DIR_NAME=apache-maven-3.8.6

#没有maven安装目录则新建,否则进行备份
if [ ! -d "${INSTALL_PATH}/${MAVEN_DIR_NAME}" ]; then
    mkdir -p ${INSTALL_PATH}
else
    #备份老目录信息
    mvDir=${INSTALL_PATH}/${MAVEN_DIR_NAME}$(date +"%Y%m%d%H%M%S")
    echo "备份目录=${mvDir}"
    mkdir -p ${mvDir}
    #备份后重新创建目录
    mv ${INSTALL_PATH}/${MAVEN_DIR_NAME} ${mvDir}
    mkdir -p ${INSTALL_PATH}
fi

MAVEN_TAR_GZ=apache-maven-3.8.6-bin.tar.gz

#没有遗留maven压缩包则重新下载
if [ ! -f "${INSTALL_PATH}/${MAVEN_TAR_GZ}" ]; then
    wget -P ${INSTALL_PATH} https://mirrors.tuna.tsinghua.edu.cn/apache/maven/maven-3/3.8.6/binaries/${MAVEN_TAR_GZ}
    echo "下载maven3.8.6成功, 等待解压安装..."
else
    echo "已有maven二进制安装包,准备解压安装..."
fi

#解压目录中maven压缩包到对应目录
tar -zxvf ${INSTALL_PATH}/${MAVEN_TAR_GZ} -C ${INSTALL_PATH}

# /etc/profile 之前设置过, 重新覆盖
if [ ${MAVEN_HOME} ]; then
    echo -e "环境变量已存在, MAVEN_HOME=${MAVEN_HOME} 本次不执行MAVEN变量重复写入, 自行替换\n"
else
    echo "export MAVEN_HOME=${INSTALL_PATH}/apache-maven-3.8.6" >>/etc/profile
    echo "export PATH=\$PATH:\$MAVEN_HOME/bin" >>/etc/profile
    echo -e "设置maven全局环境变量完成\n"
fi

#刷新系统环境文件并且使其生效(shell脚本中需要通过bash刷新生效)
source /etc/profile

echo "==========maven配置完毕,查看版本信息================"
mvn -v
echo "=================================================="
#刷新脚本环境与外部linux一致
bash
