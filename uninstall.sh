#!/bin/bash
printf "\033c"

node="v14.19.1"
arch=$(uname -m)
mcsmanager_install_path="/opt/mcsmanager"
zh=$([[ $(locale -a) =~ "zh" ]] && echo 1; export LANG=zh_CN.UTF-8 || echo 0)

Red_Error() {
  echo '================================================='
  printf '\033[1;31;40m%b\033[0m\n' "$@"
  echo '================================================='
  exit 1
}

echo_cyan() {
  printf '\033[1;36m%b\033[0m\n' "$@"
}

Uninstall_Node() {
  if [ "$zh" == 1 ];
    then echo_cyan "[-] 卸载 Node 环境... "
    else echo_cyan "[-] Uninstall Node environment... "
  fi

  rm -rf "$node_install_path"

  sleep 3
}

Uninstall_MCSManager() {
  if [ "$zh" == 1 ];
    then echo_cyan "[-] 卸载 MCSManager..."
    else echo_cyan "[-] Uninstall MCSManager..."
  fi

  rm -rf ${mcsmanager_install_path}

  sleep 3
}

Remove_Service() {
  if [ "$zh" == 1 ];
    then echo_cyan "[-] 移除 MCSManager 服务..."
    else echo_cyan "[-] Remove MCSManager service..."
  fi

  systemctl disable mcsm-daemon.service --now
  systemctl disable mcsm-web.service --now
  rm -f /etc/systemd/system/mcsm-daemon.service
  rm -f /etc/systemd/system/mcsm-web.service
  systemctl daemon-reload

  sleep 3
}


# ----------------- 程序启动 -----------------

# 删除 Shell 脚本自身
rm -f "$0"

# 检查执行用户权限
if [ "$(whoami)" != "root" ]; then
  if [ "$zh" == 1 ];
    then Red_Error "[x] 请使用 root 权限执行 MCSManager 卸载命令！"
    else Red_Error "[x] Please execute the MCSManager uninstallation command with root permission!"
  fi
fi

echo_cyan "+----------------------------------------------------------------------
| MCSManager Uninstaller
+----------------------------------------------------------------------
| Copyright © 2022 MCSManager All rights reserved. (Maybe)
+----------------------------------------------------------------------
| Shell Uninstall Script by Huaji_MUR233
+----------------------------------------------------------------------
"

# 环境检查
if [ "$arch" == x86_64 ]; then
  arch=x64
  #echo "[-] x64 architecture detected"
elif [ $arch == aarch64 ]; then
  arch=arm64
  #echo "[-] 64-bit ARM architecture detected"
elif [ $arch == arm ]; then
  arch=armv7l
  #echo "[-] 32-bit ARM architecture detected"
elif [ $arch == ppc64le ]; then
  arch=ppc64le
  #echo "[-] IBM POWER architecture detected"
elif [ $arch == s390x ]; then
  arch=s390x
  #echo "[-] IBM LinuxONE architecture detected"
fi

# 定义变量 Node 安装目录
node_install_path="/opt/node-$node-linux-$arch"

# MCSManager 未安装
if [ ! -d "$mcsmanager_install_path" ]; then
  printf "\033c"
  if [ "$zh" == 1 ];
      then Red_Error "未检测到安装在 \"$mcsmanager_install_path\" 的 MCSManager
本卸载脚本仅支持卸载使用官方安装脚本安装的 MCSManager"
      else Red_Error "MCSManager installed at \"$mcsmanager_install_path\" not detected
This uninstall script only supports uninstalling MCSManager installed using the official installation script"
  fi
fi

# 移除 MCSManager 后台服务
Remove_Service

# 卸载 MCSManager
Uninstall_MCSManager

# 卸载 Node 环境
Uninstall_Node

printf "\033c"
echo_cyan Goodbye!
