#!/bin/bash
appDir="/opt/java"
getUrl="https:/mirrors.huaweicloud.com/java/jdk/8u202-b08/jdk-8u202-linux-x64.tar.gz"
zipName="jdk-8u202-linux-x64.tar.gz"
fileName="jdk8"

# 路径不存在则新建,存在则清空数据
if [ ! -d "${appDir}" ]; then
  mkdir -p ${appDir}
else
  rm -rf ${appDir}/*
fi
# 下载到指定目录,静默解压
wget -P ${appDir} ${getUrl} && tar -zxvf ${appDir}/${zipName} -C ${appDir} > /dev/null 2>&1
# 移除压缩包
rm ${appDir}/${zipName}

#清理原有$PATH中的java记录
export PATH=$(echo $PATH | tr ':' '\n' | grep -v "/opt/java" | tr '\n' ':' | sed 's/:$//')

exportPath="export PATH=\$JAVA_HOME/bin:\$PATH"

# 若配置过,直接替换为最新环境变量
if grep -q "export JAVA_HOME=" /etc/profile; then
    sed -i "s#\(export JAVA_HOME=\).*#\1$appDir/$fileName#" /etc/profile
    # 没有export配置PATH则追加相应参数
    exportPath="export PATH=\$JAVA_HOME/bin:\$PATH"
    if ! grep -q -x "$exportPath" /etc/profile; then
        # 匹配内容有路径/, 需改用定界符
        sed "\#export JAVA_HOME=$appDir/$fileName#a $exportPath" /etc/profile
    fi
else 
    #初次配置,直接写入环境变量
    echo "export JAVA_HOME=$appDir/$fileName" >> /etc/profile
    echo $exportPath >> /etc/profile
fi

#环境变量生效
source /etc/profile

echo "=================================== JDK VERSION INFO ========================================="
java -version
echo "=============================================================================================="
#Shell环境与外部一致
bash
