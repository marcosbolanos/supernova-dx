#!/usr/bin/bash

echo "::group:: ===$(basename "$0")==="

set -eoux pipefail

# Enable automatic updates
systemctl enable bootc-fetch-apply-updates.timer
systemctl enable bootc-fetch-apply-updates.service

# Create an override to avoid auto-rebooting when auto-updating
# This removes the --apply flag, enabling the default behaviour of staging
mkdir -p /etc/systemd/system/bootc-fetch-apply-updates.service.d
cat >/etc/systemd/system/bootc-fetch-apply-updates.service.d/no-apply.conf <<'EOF'
[Service]
ExecStart=
ExecStart=/usr/bin/bootc upgrade --quiet
EOF

# Enable/start needed services
systemctl enable podman.socket
systemctl enable docker.service
systemctl enable docker.socket
systemctl enable tailscaled.service

sed -i 's@enabled=1@enabled=0@g' /etc/yum.repos.d/vscode.repo
sed -i 's@enabled=1@enabled=0@g' /etc/yum.repos.d/docker-ce.repo
dnf5 -y copr disable phracek/PyCharm
sed -i 's@enabled=1@enabled=0@g' /etc/yum.repos.d/fedora-cisco-openh264.repo
# NOTE: we won't use dnf5 copr plugin for ublue-os/akmods until our upstream provides the COPR standard naming

for i in /etc/yum.repos.d/rpmfusion-*; do
  sed -i 's@enabled=1@enabled=0@g' "$i"
done

run_if_systemd() {
  if [ -d /run/systemd/system ]; then
    "$@"
  else
    echo "::warning::systemd not running; skipping $*"
  fi
}

run_if_systemd systemctl start docker
run_if_systemd systemctl start tailscaled

echo "::endgroup::"
