echo > /etc/security/limits.d/dhcpd.conf

cat > /etc/security/limits.d/dhcpd.conf << 'EOF'
dhcpd   soft   nofile   65535
dhcpd   hard   nofile   65535
dhcpd   soft   nproc    4096
dhcpd   hard   nproc    4096
EOF

# === 2. 内核 UDP 优化 ===
echo > /etc/sysctl.d/99-dhcp.conf
cat > /etc/sysctl.d/99-dhcp.conf << 'EOF'
# ============================================
# PXE 大规模部署 - 3000 台并发优化
# Rocky 9 / 5.14+ 内核专用
# ============================================

# ---------- 文件系统 ----------
fs.file-max = 4194304
fs.nr_open = 2097152

# ---------- 进程 ----------
kernel.pid_max = 262144
kernel.threads-max = 524288
vm.overcommit_memory = 1

# ---------- 网络核心 ----------
net.core.somaxconn = 131072
net.core.netdev_max_backlog = 131072

# ---------- TCP ----------
net.ipv4.tcp_max_syn_backlog = 131072
net.ipv4.tcp_max_tw_buckets = 524288
net.ipv4.tcp_tw_reuse = 1
net.ipv4.tcp_fin_timeout = 3
net.ipv4.tcp_syn_retries = 2
net.ipv4.tcp_synack_retries = 2
net.ipv4.tcp_slow_start_after_idle = 0
net.ipv4.tcp_window_scaling = 1

# TCP 缓冲区
net.core.rmem_default = 33554432
net.core.wmem_default = 33554432
net.core.rmem_max = 134217728
net.core.wmem_max = 134217728
net.ipv4.tcp_rmem = 4096 1048576 67108864
net.ipv4.tcp_wmem = 4096 1048576 67108864
net.ipv4.tcp_mem = 786432 1048576 1572864

# ---------- UDP（DHCP + TFTP）----------
net.ipv4.udp_mem = 1048576 2097152 4194304
net.ipv4.udp_rmem_min = 131072
net.ipv4.udp_wmem_min = 131072

# ---------- 连接跟踪 ----------
net.netfilter.nf_conntrack_max = 4194304
net.netfilter.nf_conntrack_tcp_timeout_established = 300
net.netfilter.nf_conntrack_tcp_timeout_time_wait = 5
net.netfilter.nf_conntrack_tcp_timeout_close_wait = 5
net.netfilter.nf_conntrack_tcp_timeout_fin_wait = 5
net.netfilter.nf_conntrack_udp_timeout = 30

# ---------- BBR 拥塞控制 ----------
net.core.default_qdisc = fq
net.ipv4.tcp_congestion_control = bbr
EOF

sysctl --system



sysctl -p /etc/sysctl.d/99-dhcp.conf

