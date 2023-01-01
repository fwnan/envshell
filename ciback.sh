#! /bin/bash
# author Fwnan

separator="------------------------------------------------------------------------"
#项目的一级构建目录和代码目录
BUILD_DIR=/app
CODE_DIR=/codegit
GIT_URL=??????????????????
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
    echo [编译模块:${COMPILE_SERVICES}]
    echo $separator
}

err() {
    echo -e "\033[31m $1 \033[0m"
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

#检查java和maven
check_java_maven() {
    echo 检查java和maven
    if ! command -v java &>/dev/null; then
        err "java命令不可用,请安装Java"
        exit 1
    fi
    if ! command -v mvn &>/dev/null; then
        err "mvn命令不可用,请安装Maven"
        exit 1
    fi
}
# 检查基础打包环境
check() {
    echo [检查打包环境]
    check_pubkey
    check_java_maven
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
    echo ${APP_NAME}代码更新完毕,当前分支:$(git rev-parse --abbrev-ref HEAD)
    echo $separator
}
#代码打包构建
pack() {
    cd ${APP_CODE_DIR}
    #先清理旧包后执行
    mvn clean
    mvn package -Dmaven.test.skip=true -Dmaven.javadoc.skip=true -P prod
    echo $separator
}
#迁移编译jar包到构建目录
move() {
    echo 迁移编译jar, 统一放置在${APP_BUILD_DIR}目录
    if [ ! -d $APP_BUILD_DIR ]; then
        mkdir -p $APP_BUILD_DIR
        echo 初次构建${APP_NAME}, 创建对应的构建目录
    fi
    cd $APP_BUILD_DIR

    #把编译好的服务模块(一般是对外服务), 统一转移到应用构建目录中, 会直接复制.
    COMPILE_SERVICES="ruoyi-admin,ruoyi-extend/ruoyi-monitor-admin,ruoyi-extend/ruoyi-xxl-job-admin"
    #把指定模块jar包全部复制到应用构建目录, 强制覆盖(ps:xargs中使用通配符, 需sh -c 来执行命令)
    echo ${COMPILE_SERVICES} | tr -d "[:space:]" | xargs -d "," -n 1 -I {} sh -c "cp -f ${APP_CODE_DIR}/{}/target/*.jar ."
    echo "[对外服务模块的jar包复制完成, 输出应用目录文件情况]"
    ls -lh
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
    echo pack   构建打包
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

