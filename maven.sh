#!/bin/bash
INSTALL_PATH="/opt/maven"
# maven zip
MAVEN_URL="https://mirrors.aliyun.com/apache/maven/maven-3/3.9.6/binaries/apache-maven-3.9.6-bin.tar.gz"
MAVEN_TAR="apache-maven-3.9.6-bin.tar.gz"
MAVEN_DIR="apache-maven-3.9.6"

# 路径不存在则新建,存在则清空数据
if [ ! -d "${INSTALL_PATH}" ]; then
  mkdir -p ${INSTALL_PATH}
else
  rm -rf ${INSTALL_PATH}/*
fi

# 下载到安装目录,静默解压
wget -P ${INSTALL_PATH}/${MAVEN_URL} && tar -zxvf ${INSTALL_PATH}/${MAVEN_TAR} -C ${INSTALL_PATH} > /dev/null 2>&1
# 移除压缩包
rm $INSTALL_PATH}/${MAVEN_TAR}

#清理原有$PATH环境中的maven信息
export PATH=$(echo $PATH | tr ':' '\n' | grep -v "maven" | tr '\n' ':' | sed 's/:$//')

# 如果有MAVEN_HOME, 直接替换为最新环境变量
if grep -q "export MAVEN_HOME=" /etc/profile; then
    sed -i "s#\(export MAVEN_HOME=\).*#\1$INSTALL_PATH/$MAVEN_DIR#" /etc/profile

    # 找不到Maven的环境配置PATH,追加MAVEN_HOME到PATH
    ENV_MAVEN_PATH="export PATH=\$MAVEN_HOME/bin:\$PATH"
    if ! grep -q -x "$ENV_MAVEN_PATH" /etc/profile; then
        # 匹配内容有路径/, 需改用定界符
        sed "\#export MAVEN_HOME=$INSTALL_PATH/$MAVEN_DIR#a ${ENV_MAVEN_PATH}" /etc/profile
    fi
else 
    #初次配置,直接写入环境变量
    echo "export MAVEN_HOME=${INSTALL_PATH}/${MAVEN_DIR}" >> /etc/profile
    echo "export PATH=\$MAVEN_HOME/bin:\$PATH" >> /etc/profile
fi

#刷新环境变量
source /etc/profile
echo "===================================== MAVEN VERSION INFO ====================================="
mvn -v
echo "=============================================================================================="
bash
