#! /bin/bash
# author Fwnan

separator="------------------------------------------------------------------------"
#项目的一级构建目录和代码存放目录
BUILD_DIR=/app
CODE_DIR=/codegit
#git地址
GIT_URL=???????????????????????????
#GIT默认分支master
GIT_BRANCH=master
#应用项目名称
APP_NAME=$(echo ${GIT_URL} | awk -F "/" '{print $NF}' | awk -F "." '{print $1}')
#应用的代码目录
APP_CODE_DIR=${CODE_DIR}/${APP_NAME}
#应用构建目录.若是前后端项目,最好两者一致,方便把构建产物放一起. 
APP_BUILD_DIR=${BUILD_DIR}/${APP_NAME}

#基础信息
base_info() {
    echo [基本参数]
    echo [项目: ${APP_NAME}]
    echo [构建目录:${BUILD_DIR}]
    echo [代码目录:${APP_CODE_DIR}]
    echo $separator
}
#检查基础公钥是否存在
check_pubkey() {
    echo 检查Git连接的SSH公钥情况
    rsa=~/.ssh/id_rsa.pub
    ed=~/.ssh/id_ed25519.pub
    if [ ! -f $rsa ] && [ ! -f $ed ]; then
        echo RSA与ed25519, 两个公钥文件均不存在, 请生成ssh-key!
        exit 1
    fi
    echo SSH公钥文件已生成
    [[ $(cat $rsa) == "" ]] && echo 请注意, rsa公钥内容为空,谨慎使用.
    [[ $(cat $ed) == "" ]] && echo 请注意, ed25519公钥内容为空,谨慎使用.
}
#检查npm环境
check_npm() {
    echo 检查npm
    if ! command -v npm &>/dev/null; then
        echo ERR:npm命令不存在, 请安装npm环境后再次执行.
        exit 1
    fi
    res=$(npm -v 2>&1)
    version=$(echo $res | cut -d "." -f -1)
    if [[ $version < 6 ]]; then
        echo 当前npm版本低于6, 请安装npm6以上版本.
        exit 1
    fi
    echo npm:${res}正常
}
#检查java和maven
check_java_maven() {
    echo 检查java环境和maven打包环境
}
# 检查基础打包环境
check() {
    echo [检查打包环境]
    check_npm
    check_pubkey
    echo $separator
}
#初始化基本目录: 承载应用目录和代码Git目录
init_dir() {
    if [ -d $BUILD_DIR ] && [ -d $CODE_DIR ]; then
        echo 应用的构建存放目录和代码存放目录已创建
    else
        echo 初始化所需目录
        if [ ! -d $BUILD_DIR ]; then
            mkdir -p $BUILD_DIR
            echo 创建应用构建存放目录:$BUILD_DIR
        fi
        if [ ! -d $CODE_DIR ]; then
            mkdir -p $CODE_DIR
            echo 创建应用代码存放目录:$CODE_DIR
        fi
    fi
    echo $separator
}
#更新代码
codeup() {
    out=""
    #项目目录不存在, 则直接git clone, 会生成一个项目目录
    if [ ! -d "${APP_CODE_DIR}" ]; then
        out=$(git clone $GIT_URL "${APP_CODE_DIR}" 2>&1)
    else
        cd $APP_CODE_DIR
        out=$(git pull 2>&1)
    fi
    #grep静默文本查询  -q: 0:找到. 1没找到.  也可以使用-w, 若匹配则返回内容, 没有则返回空字符串
    echo $out | grep -q 'fatal: Could not read from remote repository'
    if [ $? == 0 ]; then
        echo $out
        echo ${APP_NAME}代码拉取失败,请检查代码仓库${GIT_URL}公钥是否匹配当前SSH公钥.
        exit
    fi
    echo ${APP_NAME}代码更新完毕, 当前分支:$(git rev-parse --abbrev-ref HEAD)
    echo $separator
}
#代码打包构建
pack() {
    cd ${APP_CODE_DIR}
    #如果有遗留,先删除再打包
    if [ -d "dist" ]; then
        rm -rf dist
    fi
    # 安装依赖后, 执行生产环境打包
    npm install --registry=https://registry.npmmirror.com
    npm run build:prod
    echo $separator
}
#迁移打包产物
move() {
    echo 迁移最新的构建dist产物, 统一放置在${APP_BUILD_DIR}目录
    if [ ! -d "${APP_CODE_DIR}/dist" ]; then
        echo ${APP_CODE_DIR}/dist不存在, 请检查执行流程或重试.
        exit 1
    fi
    cd $APP_BUILD_DIR
    #备份dist -> 删除dist -> 迁移最新dist
    cp -r dist distlast
    rm -rf dist
    mv ${APP_CODE_DIR}/dist dist
    echo $separator
}


#分支切换
checkout() {
    echo 切换${APP_CODE_DIR}分支在打包, 指定分支:$1
    echo 当前分支: ??? 待完善.
    echo 切换完毕!
}
help() {
    echo [SCRIPT USAGE]
    echo check  检查环境和输出参数
    echo codeup 更新代码
    echo pack   编译打包
    echo run    执行
    echo $separator
}
#启动默认的执行流程
run() {
    echo "[流程:输出信息->初始化目录->检查环境->代码更新->编译打包]"
    base_info
    init_dir
    check
    codeup
    pack
    move
    echo ${APP_NAME}编译打包完成,请前往${APP_BUILD_DIR}查看.
    echo $separator
}
case $1 in
check)
    check
    ;;
codeup)
    codeup
    ;;
pack)
    pack
    ;;
bak)
    bak
    ;;
help)
    help
    ;;
*)
    run
    ;;
esac

