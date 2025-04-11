#!/bin/bash
#/usr/local需要配置环境变量才有权限,最好选择/opt或者/usr
appDir="/opt/nodejs"
getUrl="https://mirrors.aliyun.com/nodejs-release/v22.14.0/node-v22.14.0-linux-x64.tar.gz"
fileName="node-v22.14.0-linux-x64"
zipName="$fileName.tar.gz"

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

#清理原有$PATH中的node记录
export PATH=$(echo $PATH | tr ':' '\n' | grep -v "/opt/node" | tr '\n' ':' | sed 's/:$//')

exportPath="export PATH=\$NODEJS/bin:\$PATH"

# 若配置过,直接替换为最新环境变量
if grep -q "export NODEJS=" /etc/profile; then
    sed -i "s#\(export NODEJS=\).*#\1$appDir/$fileName#" /etc/profile
    # 没有export配置PATH则追加相应参数
    if ! grep -q -x "$exportPath" /etc/profile; then
        # 匹配内容有路径/, 需改用定界符
        sed "\#export NODEJS=$appDir/$fileName#a $exportPath" /etc/profile
    fi
else 
    #初次配置,直接写入环境变量
    echo "export NODEJS=$appDir/$fileName" >> /etc/profile
    echo $exportPath >> /etc/profile
fi

#环境变量生效
source /etc/profile

echo "================================= NODE & NPM VERSION INFO ===================================="
node -v && npm -v
#npm设置阿里镜像源, 验证地址
npm config set registry http://registry.npmmirror.com --global && npm config get registry
echo "=============================================================================================="
#Shell环境与外部一致
bash
