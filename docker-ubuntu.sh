sudo apt-get remove docker docker-engine docker.io 
sudo apt-get update
sudo apt-get -y install apt-transport-https ca-certificates curl gnupg lsb-release software-properties-common
curl -fsSL https://mirrors.aliyun.com/docker-ce/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://mirrors.aliyun.com/docker-ce/linux/ubuntu $(lsb_release -cs) stable"
sudo apt-get install -y docker-ce
systemctl start docker | service docker start
sudo docker ps
