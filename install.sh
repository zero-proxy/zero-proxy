#!/bin/bash
#
# https://github.com/zero-proxy/zero-proxy
#
# Copyright (c) 2022. Released under the MIT License.

# constants
cert_dir="certificate"
config="config.json"
bin="zero-proxy_linux"
base_url="https://raw.githubusercontent.com/zero-proxy/zero-proxy/master"

# detect OS
if grep -qs "ubuntu" /etc/os-release; then
  os="ubuntu"
elif [[ -e /etc/debian_version ]]; then
  os="debian"
elif [[ -e /etc/almalinux-release || -e /etc/rocky-release || -e /etc/centos-release ]]; then
  os="centos"
elif [[ -e /etc/fedora-release ]]; then
  os="fedora"
else
  echo "不支持当前系统，仅支持的操作系统为Ubuntu, Debian, AlmaLinux, Rocky Linux, CentOS, Fedora."
  exit
fi

function ensure_env() {
  echo "install required commands and ensure environments"
  if [[ "$os" = "debian" || "$os" = "ubuntu" ]]; then
    sudo apt-get update
    sudo apt-get install -y curl
    sudo apt-get install -y jq

    # disable firewall
    sudo ufw disable
  elif [[ "$os" = "centos" ]]; then
    sudo yum install -y curl
    sudo yum install -y jq

    # disable firewall
    sudo systemctl stop firewalld
  else
    # else, OS must be Fedora
    sudo dnf install -y curl
    sudo dnf install -y jq
  fi
}

function ensure_nvm() {
  if [ -n "$NVM_DIR" ] and  [ -f "$NVM_DIR/nvm.sh" ]; then
    echo "nvm is installed, skipping"
  else
    # install nvm
    echo "installing nvm"
    if ! curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash; then
      echo "failed to install nvm, please install node.js manually"
      exit
    fi
    source ~/.nvm/nvm.sh
  fi
}

function ensure_node() {
  if which node >/dev/null; then
    echo "node is installed, skipping"
  else
    # we use nvm to install node
    ensure_nvm

    # install node.js
    echo "installing node.js"
    nvm install 16
    nvm alias default 16
    nvm use default
  fi
}

function ensure_pm2() {
  if which pm2 >/dev/null; then
    echo "pm2 is installed, skipping"
  else
    echo "installing pm2"
    sudo chown -R $(whoami) ~/.npm
    npm install pm2 -g
    echo "initiate pm2-logrotate"
    pm2 install pm2-logrotate
    pm2 set pm2-logrotate:max_size 20M
    pm2 set pm2-logrotate:compress false
    pm2 set pm2-logrotate:retain 10
  fi
}

function install_env() {
  ensure_env
  ensure_node
  ensure_pm2
}

function install_zero_proxy() {
  if [ ! -d "$cert_dir" ]; then
    echo "downloading certificate"
    mkdir $cert_dir
    curl -o $cert_dir/server.crt $base_url/certificate/server.crt
    curl -o $cert_dir/server.key $base_url/certificate/server.key
  fi
  if [ ! -f "$config" ]; then
    echo "downloading config"
    curl -o $config $base_url/config.json
  fi

  if [ ! -f "$bin" ]; then
    echo "downloading $bin"
    curl -o $bin $base_url/zero-proxy_linux
    chmod u+x $bin
  fi
}

function install() {
  install_env
  install_zero_proxy
}

function uninstall_zero_proxy() {
  rm -rf $cert_dir
  rm -rf logs
  rm -rf db
  rm $config
  rm $bin
}

function uninstall_pm2() {
  echo "uninstalling pm2"
  pm2 delete zero-proxy
  pm2 delete pm2-logrotate
  pm2 uninstall pm2-logrotate
  npm uninstall -g pm2
}

function uninstall_node() {
  echo "uninstalling node.js"
  # nvm uninstall 16
}

function uninstall_nvm() {
  echo "uninstalling nvm"
  rm -rf $NVM_DIR ~/.npm ~/.bower
}

function uninstall() {
  uninstall_zero_proxy
  uninstall_pm2
  uninstall_node
  uninstall_nvm
}

function start() {
  echo "starting zero proxy"
  pm2 start pm2-logrotate
  pm2 start $bin --name zero-proxy -e logs/zero-proxy-error.log -o logs/zero-proxy-out.log
}

function stop() {
  echo "stoping zero proxy"
  pm2 stop zero-proxy
  pm2 stop pm2-logrotate
}

function restart() {
  echo "restarting zero proxy"
  pm2 restart pm2-logrotate
  pm2 restart zero-proxy
}

function update() {
  echo "updating zero proxy"
  latest_bin_md5=$(curl -s $base_url/version.json | jq -r '.md5')
  echo "md5 of lastest version is $latest_bin_md5"
  current_bin_md5=($(md5sum $bin))
  echo "md5 of current version is $current_bin_md5"

  if [ "$latest_bin_md5" == "$current_bin_md5" ]; then
    echo "Already up to date"
    exit
  fi

  # else, remove current bin
  tmp_bin="zero-proxy_tmp"
  if ! curl -o $tmp_bin $base_url/zero-proxy_linux; then
    echo "failed to download latest version, exit"
    exit
  fi
  rm $bin
  mv $tmp_bin $bin
  chmod u+x $bin

  # reset service
  pm2 delete zero-proxy
  start
}

clear
while :; do
  echo
  echo "Welcome to Zero Proxy"
  echo
  echo "1. 安装"
  echo "2. 卸载"
  echo "3. 启动"
  echo "4. 关闭"
  echo "5. 重启"
  echo "6. 更新"
  read -p "$(echo -e "请选择 [1-6]:")" choose
  case $choose in
  1)
    install
    start
    break
    ;;
  2)
    stop
    uninstall
    break
    ;;
  3)
    start
    break
    ;;
  4)
    stop
    break
    ;;
  5)
    restart
    break
    ;;
  6)
    update
    break
    ;;
  *)
    echo "输入错误，请重新选择命令"
    ;;
  esac
done
