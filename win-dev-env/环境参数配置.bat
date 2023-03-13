::保证中文正常显示
chcp 65001
@echo off

echo -----------------------------------------------------------
echo 配置常用环境镜像:npm, git, python
echo -----------------------------------------------------------

echo 配置GIT用户信息完毕=======================
::设置全局GIT用户名以及邮箱
git config --global user.name "GitUser"
git config --global user.email diyuser@gmail.com

echo 查看GIT配置列表==========================
git config --list   

echo NPM配置为国内镜像源=======================
npm config set registry http://registry.npmmirror.com --global


echo Python配置国内镜像源


echo Maven设置为国内镜像源
echo 把预置好的模板文件直接替换


pause
