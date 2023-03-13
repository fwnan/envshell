::保证中文正常显示
chcp 65001

@echo off
::颜色显示
color 0a

echo 已在执行目录下备份初始环境变量，文件名：defaultPath.log
echo %PATH% >> defaultPath.log
echo ==========================================================
echo [准备配置预设环境变量:Java,Maven,Node,Python,Git等]
echo ==========================================================
echo.
::用于重置恢复的环境变量
set BASE_PATH=C:\WINDOWS\system32;C:\WINDOWS;C:\WINDOWS\System32\Wbem;C:\WINDOWS\System32\WindowsPowerShell\v1.0\;C:\WINDOWS\System32\OpenSSH\;C:\Program Files\Docker\Docker\resources\bin;C:\ProgramData\DockerDesktop\version-bin;C:\Users\gnef\AppData\Local\Microsoft\WindowsApps;
::echo 默认用于重置的环境变量：%BASE_PATH%

echo ==========================================================
echo [当前全局变量已被重置，准备写入预设环境变量......]
echo ==========================================================
setx /m PATH ""

set JAVA=D:\developer\jdk20
set MAVEN=D:\developer\maven3.8.7
set NODEJS=D:\developer\nodejs
set PYTHON=D:\developer\Python\Python310
set GIT_TMP=D:\developer\Git
set GIT=%GIT_TMP%\bin;%GIT_TMP%\mingw64\bin;%GIT_TMP%\mingw64\libexec\git-core	

::直接覆盖同名全局变量
setx /m JAVA_HOME %JAVA%
setx /m MAVEN_HOME %MAVEN%
setx /m NODE_HOME %NODEJS%
setx /m PYTHON_HOME %PYTHON%
setx /m GIT_HOME %GIT%

echo ==========================================================
echo [当前预设环境路径，若要自行新增，请参照脚本自行调整处理]
echo ==========================================================
echo Java:%JAVA_HOME%
echo Maven:%MAVEN_HOME%
echo Node:%NODE_HOME%
echo PYTHON:%PYTHON_HOME%
echo GIT:%GIT_HOME%
echo ==========================================================


::环境变量名称太长，换行处理
set PREFIX=.;%%JAVA_HOME%%\bin;%%MAVEN_HOME%%\bin;^
%%NODE_HOME%%\;^
%%PYTHON_HOME%%\;%%PYTHON_HOME%%\Scripts\;^
%%GIT_HOME%%


::正式设置环境
setx /m PATH "%PREFIX%;%BASE_PATH%"

echo ==========================================================
echo 环境配置完毕, 准备输出配置结果............
echo ==========================================================
java -version
git --version
python --version
node -v
call mvn -v
color 0a
echo 环境配置结果输出完毕，检查配置是否有效=================================


::cmd /k  ping 192.168.1.1
pause
