# 以管理员权限运行
if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
	Write-Host "请以管理员权限运行此脚本，正在尝试重新启动..." -ForegroundColor Yellow
    Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
    Exit
}

Write-Host "===保留旧环境变量值在桌面文件==="
$desktop = [Environment]::GetFolderPath("Desktop")
"$env:Path" + "`n" >> ${desktop}\oldPath.txt

Write-Host "===准备配置Java,MAVEN,Nodejs,Python等常见环境==="
# 设置各开发环境的目录(指向本地已下载好的文件目录)
$dir="D:\dev";$java="${dir}\jdk21";$maven="${dir}\apache-maven-3.9.9";$nodejs="${dir}\nodejs";$python="${dir}\Python"
$go="${dir}\go";$mingw="${dir}\mingw64";$git="${dir}\Git";$adb="${dir}\android-sdk\platform-tools"

# 设置系统变量名, setx更快且兼容更好. 优于 [Environment]::SetEnvironmentVariable($pJava, $java, "Machine")
cmd.exe /c "setx /m  JAVA      `"$java`""
cmd.exe /c "setx /m  MAVEN     `"$maven`""
cmd.exe /c "setx /m  NODEJS    `"$nodejs`""
cmd.exe /c "setx /m  PYTHON    `"$python`""
cmd.exe /c "setx /m  GOROOT    `"$go`""
cmd.exe /c "setx /m  GIT       `"$git`""
cmd.exe /c "setx /m  MINGW     `"$mingw`""
cmd.exe /c "setx /m  ADB       `"$adb`""

# 构造开发环境变量目录
$appPath = ".;%JAVA%\bin;%MAVEN%\bin;%NODEJS%;%PYTHON%\;%PYTHON%\Scripts;%GOROOT%\bin;%ADB%;%GIT%\bin;%MINGW%\bin"
# 系统原始环境目录
$sysPath = ";%SystemRoot%\system32;%SystemRoot%;%SystemRoot%\System32\Wbem;%SYSTEMROOT%\System32\WindowsPowerShell\v1.0\;%SYSTEMROOT%\System32\OpenSSH\;"
#完整的系统环境变量Path
$finalPath = "${appPath}${sysPath}"
Write-Host "finalPath: $finalPath"
#设置Path
cmd.exe /c "setx /m PATH $finalPath"

#C:\Windows\System32\OpenSSH\;
Write-Host "===开发环境检查==="
java --version
mvn -v
$rsNode = node -v; $rsNpm = npm -v; Write-Host "node=$rsNode ,npm=$rsNpm"
python --version; python -m pip --version
go version
git --version
gcc --version
adb version
 
Read-Host "Press Enter any key to exit"
