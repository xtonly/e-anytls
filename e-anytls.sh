#!/bin/bash

#====================================================================================
#
#          FILE: sb_manager.sh
#
#         USAGE: bash sb_manager.sh
#
#   DESCRIPTION: A comprehensive, multilingual script for installing, configuring,
#                managing Sing-box (VLESS + Vision + Reality).
#                (Fixes: Updated command 'reality-keypair' for v1.12+)
#
#====================================================================================

# --- Color Definitions ---
GREEN="\033[32m"
RED="\033[31m"
YELLOW="\033[33m"
BLUE="\033[34m"
PLAIN="\033[0m"

# --- Global Variables ---
SB_INSTALL_PATH="/usr/local/bin/sing-box"
SB_CONFIG_DIR="/usr/local/etc/sing-box"
SB_CONFIG_FILE="$SB_CONFIG_DIR/config.json"
NODE_INFO_FILE="$SB_CONFIG_DIR/node_info.conf"
SERVICE_FILE="/etc/systemd/system/sing-box.service"

# --- Embedded Language Functions ---

load_lang_en() {
    export ERROR_MUST_BE_ROOT="Error: This script must be run as root!"
    export PRESS_ENTER_TO_CONTINUE="Press [Enter] to return..."
    export DETECTING_IP="Detecting server public IP address..."
    export ERROR_IP_DETECTION_FAILED="Failed to detect public IP. Please check your network or try again later."
    export SERVER_IP_IS="Server Public IP:"
    export INSTALLING_SB=">>> Installing Sing-box..."
    export SB_ALREADY_INSTALLED="Sing-box is already installed. An update/reinstall will be performed."
    export ERROR_SB_INSTALL_FAILED="Sing-box installation failed! Please check your network."
    export SUCCESS_SB_INSTALLED="Sing-box installed/updated successfully!"
    export CONFIGURING_SB=">>> Configuring Sing-box (VLESS-Vision-Reality)..."
    export PROMPT_PORT="Enter Service Port (default 54321): "
    export PROMPT_SNI="Enter a destination domain (default: www.microsoft.com): "
    export ERROR_KEY_GENERATION_FAILED="Error: Failed to extract KeyPair from Sing-box output!"
    export WRITING_CONFIG="Writing server configuration file..."
    export SUCCESS_CONFIG_WRITTEN="Server configuration written successfully!"
    export CONFIGURING_FIREWALL="Configuring firewall..."
    export SUCCESS_SB_STARTED="Sing-box started successfully!"
    export ERROR_SB_START_FAILED="Sing-box failed to start! Please use menu option to view logs."
    export ERROR_NODE_FILE_NOT_FOUND="Node information file not found. Please perform the installation first."
    export NODE_INFO_HEADER="====================== Your Node Information ======================"
    export VLESS_NODE_LINK="[VLESS + Vision + REALITY Node Link]"
    export NODE_INFO_FOOTER="================================================================="
    export PROMPT_UNINSTALL_CONFIRM="Are you sure you want to uninstall Sing-box? (y/N): "
    export UNINSTALL_CANCELLED="Uninstall operation canceled."
    export SUCCESS_SB_UNINSTALLED="Sing-box has been successfully uninstalled!"
    export UPDATING_SB=">>> Checking for Sing-box Updates..."
    export RESTARTING_SB_AFTER_UPDATE="Restarting Sing-box service to apply updates..."
    export SUCCESS_SB_UPDATED="Sing-box has been updated and restarted successfully!"
    export SB_ENABLED_ON_BOOT="Sing-box auto-start on boot has been enabled."
    export SB_DISABLED_ON_BOOT="Sing-box auto-start on boot has been disabled."
    export MENU_HEADER_1="================================================================="
    export MENU_HEADER_2="          Sing-box Management Script (AnyTLS/Reality)"
    export MENU_OPTION_1="Install and Configure Sing-box"
    export MENU_OPTION_2="View Node Information"
    export MENU_OPTION_3="Enable Auto-start on Boot"
    export MENU_OPTION_4="Disable Auto-start on Boot"
    export MENU_OPTION_5="View Sing-box Status and Logs"
    export MENU_OPTION_6="Service Management"
    export MENU_OPTION_0="Exit Script"
    export PROMPT_MENU_CHOICE="Please enter an option: "
    export SB_SERVICE_RESTARTED="Sing-box service has been restarted."
    export SB_SERVICE_STOPPED="Sing-box service has been stopped."
    export VIEWING_LOGS="Viewing real-time Sing-box logs, press Ctrl+C to exit..."
    export ERROR_INVALID_OPTION="Invalid option, please enter a correct number."
    export SUBMENU_SERVICE_MANAGEMENT_HEADER="--- Service Management Menu ---"
    export SUBMENU_OPTION_1="Update Sing-box Core"
    export SUBMENU_OPTION_2="Restart Sing-box Service"
    export SUBMENU_OPTION_3="Stop Sing-box Service"
    export SUBMENU_OPTION_4="Uninstall Sing-box"
    export SUBMENU_OPTION_0="Return to Main Menu"
}

load_lang_zh() {
    export ERROR_MUST_BE_ROOT="错误：此脚本必须以 root 身份运行！"
    export PRESS_ENTER_TO_CONTINUE="按 [Enter] 键返回..."
    export DETECTING_IP="正在检测服务器公网 IP 地址..."
    export ERROR_IP_DETECTION_FAILED="自动检测公网 IP 失败。请检查网络或稍后重试。"
    export SERVER_IP_IS="服务器公网 IP:"
    export INSTALLING_SB=">>> 正在安装 Sing-box..."
    export SB_ALREADY_INSTALLED="Sing-box 已安装。将执行更新/重装操作。"
    export ERROR_SB_INSTALL_FAILED="Sing-box 安装失败！请检查网络连接。"
    export SUCCESS_SB_INSTALLED="Sing-box 安装/更新成功！"
    export CONFIGURING_SB=">>> 正在为您配置 Sing-box (VLESS-Vision-Reality)..."
    export PROMPT_PORT="请输入服务端口 (默认 54321): "
    export PROMPT_SNI="请输入伪装域名 (SNI) (默认为 www.microsoft.com): "
    export ERROR_KEY_GENERATION_FAILED="错误：无法从 Sing-box 输出中提取密钥对！"
    export WRITING_CONFIG="正在写入服务器配置文件..."
    export SUCCESS_CONFIG_WRITTEN="服务器配置写入成功！"
    export CONFIGURING_FIREWALL="正在配置防火墙..."
    export SUCCESS_SB_STARTED="Sing-box 已成功启动！"
    export ERROR_SB_START_FAILED="Sing-box 启动失败！请使用菜单选项查看日志以定位问题。"
    export ERROR_NODE_FILE_NOT_FOUND="未找到节点信息文件。请先执行安装与配置。"
    export NODE_INFO_HEADER="====================== 您的节点信息 ======================"
    export VLESS_NODE_LINK="[VLESS + Vision + REALITY 节点链接]"
    export NODE_INFO_FOOTER="=========================================================="
    export PROMPT_UNINSTALL_CONFIRM="您确定要卸载 Sing-box 吗？(y/N): "
    export UNINSTALL_CANCELLED="卸载操作已取消。"
    export SUCCESS_SB_UNINSTALLED="Sing-box 已成功卸载！"
    export UPDATING_SB=">>> 正在检查 Sing-box 更新..."
    export RESTARTING_SB_AFTER_UPDATE="正在重启 Sing-box 服务以应用更新..."
    export SUCCESS_SB_UPDATED="Sing-box 更新并重启成功！"
    export SB_ENABLED_ON_BOOT="Sing-box 开机自启已设置。"
    export SB_DISABLED_ON_BOOT="Sing-box 开机自启已取消。"
    export MENU_HEADER_1="=========================================================="
    export MENU_HEADER_2="          Sing-box 全功能管理脚本 (AnyTLS/Reality)"
    export MENU_OPTION_1="安装并配置 Sing-box"
    export MENU_OPTION_2="查看节点信息"
    export MENU_OPTION_3="设置开机自启"
    export MENU_OPTION_4="取消开机自启"
    export MENU_OPTION_5="查看运行状态与日志"
    export MENU_OPTION_6="服务管理"
    export MENU_OPTION_0="退出脚本"
    export PROMPT_MENU_CHOICE="请输入选项: "
    export SB_SERVICE_RESTARTED="Sing-box 服务已重启。"
    export SB_SERVICE_STOPPED="Sing-box 服务已停止。"
    export VIEWING_LOGS="正在查看 Sing-box 实时日志，按 Ctrl+C 退出..."
    export ERROR_INVALID_OPTION="无效选项，请输入正确的数字。"
    export SUBMENU_SERVICE_MANAGEMENT_HEADER="--- 服务管理菜单 ---"
    export SUBMENU_OPTION_1="更新 Sing-box 内核"
    export SUBMENU_OPTION_2="重启 Sing-box 服务"
    export SUBMENU_OPTION_3="停止 Sing-box 服务"
    export SUBMENU_OPTION_4="卸载 Sing-box"
    export SUBMENU_OPTION_0="返回主菜单"
}

select_language() {
    echo -e "${BLUE}Please select a language / 请选择语言:${PLAIN}"
    echo "1. English"
    echo "2. 中文"
    read -rp "Enter your choice [1-2]: " lang_choice

    case $lang_choice in
        1) load_lang_en ;;
        2) load_lang_zh ;;
        *) echo -e "${RED}Invalid selection, defaulting to English.${PLAIN}"; load_lang_en ;;
    esac
}

# --- Function Definitions ---

color_echo() { echo -e "${!1}${2}${PLAIN}"; }
check_root() { if [ "$EUID" -ne 0 ]; then color_echo RED "$ERROR_MUST_BE_ROOT"; exit 1; fi; }
pause() { read -rp "$PRESS_ENTER_TO_CONTINUE"; }

url_encode() {
    local string="$1"
    local encoded=""
    local char
    for (( i=0; i<${#string}; i++ )); do
        char=${string:i:1}
        case "$char" in
            [-_.~a-zA-Z0-9]) encoded+="$char" ;;
            *) encoded+=$(printf '%%%02X' "'$char") ;;
        esac
    done
    echo "$encoded"
}

get_public_ip() {
    color_echo YELLOW "$DETECTING_IP"
    PUBLIC_IP=$(curl -s -4 --connect-timeout 5 https://ifconfig.me || curl -s -4 --connect-timeout 5 https://api.ipify.org)
    if [ -z "$PUBLIC_IP" ]; then
        color_echo RED "$ERROR_IP_DETECTION_FAILED"
        exit 1
    fi
    color_echo GREEN "$SERVER_IP_IS $PUBLIC_IP"
}

install_singbox_core() {
    color_echo BLUE "$INSTALLING_SB"
    
    # Install dependencies
    apt-get update -y >/dev/null 2>&1
    apt-get install -y curl wget tar openssl jq >/dev/null 2>&1

    if [ -f "$SB_INSTALL_PATH" ]; then color_echo GREEN "$SB_ALREADY_INSTALLED"; fi

    ARCH=$(uname -m)
    VERSION=$(curl -s https://api.github.com/repos/SagerNet/sing-box/releases/latest | grep '"tag_name":' | sed -E 's/.*"v([^"]+)".*/\1/')
    
    if [[ -z "$VERSION" ]]; then
        color_echo RED "Failed to fetch latest version tag. Please check network."
        return 1
    fi

    if [[ $ARCH == "x86_64" ]]; then
        PLATFORM="linux-amd64"
    elif [[ $ARCH == "aarch64" ]]; then
        PLATFORM="linux-arm64"
    else
        color_echo RED "Unsupported Architecture: $ARCH"
        exit 1
    fi

    DOWNLOAD_URL="https://github.com/SagerNet/sing-box/releases/download/v${VERSION}/sing-box-${VERSION}-${PLATFORM}.tar.gz"
    
    echo "Downloading: $DOWNLOAD_URL"
    wget -O sing-box.tar.gz "$DOWNLOAD_URL" >/dev/null 2>&1
    if [ $? -ne 0 ]; then
        color_echo RED "$ERROR_SB_INSTALL_FAILED"
        return 1
    fi

    tar -zxvf sing-box.tar.gz >/dev/null 2>&1
    
    # Stop service if running before overwriting
    systemctl stop sing-box >/dev/null 2>&1

    # Find where it unpacked
    if [ -d "sing-box-${VERSION}-${PLATFORM}" ]; then
        cp "sing-box-${VERSION}-${PLATFORM}/sing-box" "$SB_INSTALL_PATH"
    else
        # Fallback search if folder structure changes
        find . -name sing-box -type f -exec cp {} "$SB_INSTALL_PATH" \;
    fi

    chmod +x "$SB_INSTALL_PATH"
    
    # Cleanup
    rm -rf sing-box.tar.gz "sing-box-${VERSION}-${PLATFORM}"
    
    color_echo GREEN "$SUCCESS_SB_INSTALLED"
}

configure_and_generate() {
    install_singbox_core
    color_echo BLUE "$CONFIGURING_SB"
    
    # 1. 基础配置
    mkdir -p "$SB_CONFIG_DIR"
    read -rp "$PROMPT_PORT" LISTEN_PORT; LISTEN_PORT=${LISTEN_PORT:-54321}
    read -rp "$PROMPT_SNI" SNI; SNI=${SNI:-www.microsoft.com}

    # 2. 生成 UUID
    UUID=$($SB_INSTALL_PATH generate uuid)
    echo "UUID Generated: $UUID"

    # 3. 生成 KeyPair (已修正命令为 reality-keypair)
    color_echo YELLOW "Generating KeyPair..."
    
    # 获取原始输出，包含 2>&1 以防 stderr
    # FIX: V1.12+ uses 'reality-keypair' instead of 'x25519-keypair'
    RAW_KEYS=$($SB_INSTALL_PATH generate reality-keypair 2>&1)
    
    # 使用更通用的方式解析：以冒号为分隔符，取第二部分，并删除所有空格
    PRIVATE_KEY=$(echo "$RAW_KEYS" | grep -i "Private Key" | awk -F ":" '{print $2}' | tr -d ' ')
    PUBLIC_KEY=$(echo "$RAW_KEYS" | grep -i "Public Key" | awk -F ":" '{print $2}' | tr -d ' ')
    SHORT_ID=$(openssl rand -hex 8)

    # 4. 检查是否生成成功，如果失败打印调试信息
    if [[ -z "$PRIVATE_KEY" || -z "$PUBLIC_KEY" ]]; then
        color_echo RED "$ERROR_KEY_GENERATION_FAILED"
        echo "================ DEBUG INFO ================"
        echo -e "Raw Output from sing-box:\n$RAW_KEYS"
        echo "============================================"
        echo "If you see the help menu above, the command syntax might have changed again."
        return 1
    fi

    color_echo GREEN "Keys generated successfully."
    color_echo YELLOW "$WRITING_CONFIG"
    
    # 5. 写入配置文件
    cat > "$SB_CONFIG_FILE" <<EOF
{
  "log": {
    "level": "info",
    "timestamp": true
  },
  "inbounds": [
    {
      "type": "vless",
      "tag": "vless-in",
      "listen": "::",
      "listen_port": $LISTEN_PORT,
      "users": [
        {
          "name": "user1",
          "uuid": "$UUID",
          "flow": "xtls-rprx-vision"
        }
      ],
      "tls": {
        "enabled": true,
        "server_name": "$SNI",
        "reality": {
          "enabled": true,
          "handshake": {
            "server": "$SNI",
            "server_port": 443
          },
          "private_key": "$PRIVATE_KEY",
          "short_id": ["$SHORT_ID"]
        }
      }
    }
  ],
  "outbounds": [
    {
      "type": "direct",
      "tag": "direct"
    }
  ]
}
EOF

    # 6. 配置 Systemd 服务
    cat > "$SERVICE_FILE" <<EOF
[Unit]
Description=sing-box service
Documentation=https://sing-box.sagernet.org
After=network.target nss-lookup.target

[Service]
CapabilityBoundingSet=CAP_NET_ADMIN CAP_NET_BIND_SERVICE
AmbientCapabilities=CAP_NET_ADMIN CAP_NET_BIND_SERVICE
User=root
ExecStart=$SB_INSTALL_PATH run -c $SB_CONFIG_FILE
Restart=on-failure
RestartSec=10s
LimitNOFILE=infinity

[Install]
WantedBy=multi-user.target
EOF

    systemctl daemon-reload

    # 7. 保存节点信息
    get_public_ip
    SERVER_HOSTNAME=$(hostname)
    
    cat > "$NODE_INFO_FILE" <<EOF
LISTEN_PORT="${LISTEN_PORT}"
UUID="${UUID}"
PUBLIC_KEY="${PUBLIC_KEY}"
SHORT_ID="${SHORT_ID}"
SNI="${SNI}"
SERVER_IP="${PUBLIC_IP}"
HOSTNAME="${SERVER_HOSTNAME}"
EOF

    color_echo GREEN "$SUCCESS_CONFIG_WRITTEN"
    
    # 8. 防火墙与启动
    color_echo YELLOW "$CONFIGURING_FIREWALL"
    if command -v ufw &>/dev/null; then 
        ufw allow ${LISTEN_PORT}/tcp >/dev/null 2>&1
        ufw allow ${LISTEN_PORT}/udp >/dev/null 2>&1
    elif command -v firewall-cmd &>/dev/null; then 
        firewall-cmd --permanent --add-port=${LISTEN_PORT}/tcp >/dev/null 2>&1
        firewall-cmd --permanent --add-port=${LISTEN_PORT}/udp >/dev/null 2>&1
        firewall-cmd --reload >/dev/null 2>&1
    fi

    systemctl enable sing-box >/dev/null 2>&1
    systemctl restart sing-box
    
    if systemctl is-active --quiet sing-box; then 
        color_echo GREEN "$SUCCESS_SB_STARTED"
    else 
        color_echo RED "$ERROR_SB_START_FAILED"
        return 1
    fi
    
    view_links
}

view_links() {
    if [ ! -f "$NODE_INFO_FILE" ]; then color_echo RED "$ERROR_NODE_FILE_NOT_FOUND"; return; fi
    source "$NODE_INFO_FILE"

    NAME_ENCODED=$(url_encode "${HOSTNAME}-Vision")
    # Construct standard VLESS link
    VLESS_LINK="vless://${UUID}@${SERVER_IP}:${LISTEN_PORT}?encryption=none&flow=xtls-rprx-vision&security=reality&sni=${SNI}&fp=chrome&pbk=${PUBLIC_KEY}&sid=${SHORT_ID}&type=tcp#${NAME_ENCODED}"

    color_echo GREEN "$NODE_INFO_HEADER"
    color_echo YELLOW "$VLESS_NODE_LINK"; echo "${VLESS_LINK}"
    echo ""
    echo -e "SNI:        ${YELLOW}${SNI}${PLAIN}"
    echo -e "Public Key: ${YELLOW}${PUBLIC_KEY}${PLAIN}"
    echo -e "Short ID:   ${YELLOW}${SHORT_ID}${PLAIN}"
    echo -e "UUID:       ${YELLOW}${UUID}${PLAIN}"
    color_echo GREEN "$NODE_INFO_FOOTER"
}

uninstall_singbox() {
    read -rp "$PROMPT_UNINSTALL_CONFIRM" confirm
    if [[ "${confirm,,}" != "y" ]]; then color_echo YELLOW "$UNINSTALL_CANCELLED"; return; fi
    
    systemctl stop sing-box
    systemctl disable sing-box
    rm -f "$SERVICE_FILE"
    systemctl daemon-reload
    
    rm -rf "$SB_CONFIG_DIR"
    rm -f "$SB_INSTALL_PATH"
    
    color_echo GREEN "$SUCCESS_SB_UNINSTALLED"
}

show_service_menu() {
    while true; do
        clear
        color_echo GREEN "$MENU_HEADER_1"
        color_echo GREEN "       $SUBMENU_SERVICE_MANAGEMENT_HEADER"
        color_echo GREEN "$MENU_HEADER_1"
        echo -e "  ${BLUE}1. $SUBMENU_OPTION_1"
        echo -e "  ${BLUE}2. $SUBMENU_OPTION_2"
        echo -e "  ${BLUE}3. $SUBMENU_OPTION_3"
        echo -e "  ${YELLOW}4. $SUBMENU_OPTION_4"
        echo -e "  ${PLAIN}0. $SUBMENU_OPTION_0"
        color_echo GREEN "$MENU_HEADER_1"
        read -rp "$PROMPT_MENU_CHOICE [0-4]: " choice

        case $choice in
            1) install_singbox_core; systemctl restart sing-box; pause ;;
            2) systemctl restart sing-box; color_echo GREEN "$SB_SERVICE_RESTARTED"; sleep 2 ;;
            3) systemctl stop sing-box; color_echo GREEN "$SB_SERVICE_STOPPED"; sleep 2 ;;
            4) uninstall_singbox; pause ;;
            0) return ;;
            *) color_echo RED "$ERROR_INVALID_OPTION"; sleep 2 ;;
        esac
    done
}


show_menu() {
    clear
    color_echo GREEN "$MENU_HEADER_1"; color_echo GREEN "$MENU_HEADER_2"; color_echo GREEN "$MENU_HEADER_1"
    echo -e "  ${BLUE}1. $MENU_OPTION_1"
    echo -e "  ${BLUE}2. $MENU_OPTION_2"
    echo -e "  ${BLUE}3. $MENU_OPTION_3"
    echo -e "  ${BLUE}4. $MENU_OPTION_4"
    echo -e "  ${BLUE}5. $MENU_OPTION_5"
    echo -e "  ${YELLOW}6. $MENU_OPTION_6"
    echo -e "  ${PLAIN}0. $MENU_OPTION_0"
    color_echo GREEN "$MENU_HEADER_1"
    read -rp "$PROMPT_MENU_CHOICE [0-6]: " choice

    case $choice in
        1) configure_and_generate; pause ;;
        2) view_links; pause ;;
        3) systemctl enable sing-box >/dev/null 2>&1; color_echo GREEN "$SB_ENABLED_ON_BOOT"; sleep 2 ;;
        4) systemctl disable sing-box >/dev/null 2>&1; color_echo GREEN "$SB_DISABLED_ON_BOOT"; sleep 2 ;;
        5) color_echo YELLOW "$VIEWING_LOGS"; journalctl -u sing-box -f --no-pager; pause ;;
        6) show_service_menu ;;
        0) exit 0 ;;
        *) color_echo RED "$ERROR_INVALID_OPTION"; sleep 2 ;;
    esac
}

# --- Script Entry Point ---
check_root
select_language
while true; do show_menu; done
