#!/bin/bash
appDir=/opt/python3
getUrl=https://registry.npmmirror.com/-/binary/python/3.12.2/Python-3.12.2.tgz
zipName=Python-3.12.2.tgz
fileName=Python-3.12.2

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

#配置编译后的安装目录
cd $appDir/$fileName
./configure --prefix=$appDir

#编译并安装
make && sudo make install

#清理原有$PATH中的python记录
export PATH=$(echo $PATH | tr ':' '\n' | grep -v "/opt/python" | tr '\n' ':' | sed 's/:$//')

exportPath="export PATH=\$PYTHON/bin:\$PATH"

# 若配置过,直接替换为最新环境变量
if grep -q "export PYTHON=" /etc/profile; then
    sed -i "s#\(export PYTHON=\).*#\1$appDir/$fileName#" /etc/profile
    # 没有export配置PATH则追加相应参数
    exportPath="export PATH=\$PYTHON/bin:\$PATH"
    if ! grep -q -x "$exportPath" /etc/profile; then
        # 匹配内容有路径/, 需改用定界符
        sed "\#export PYTHON=$appDir/$fileName#a $exportPath" /etc/profile
    fi
else 
    #初次配置,直接写入环境变量
    echo "export PYTHON=$appDir/$fileName" >> /etc/profile
    echo $exportPath >> /etc/profile
fi

#环境变量生效
source /etc/profile

echo "=================================== Python VERSION INFO ======================================"
python3 -V && pip3 -V
# 配置pip3为阿里云镜像源
pip3 config set global.index-url https://mirrors.aliyun.com/pypi/simple/
echo "=============================================================================================="
#Shell环境与外部一致
bash
