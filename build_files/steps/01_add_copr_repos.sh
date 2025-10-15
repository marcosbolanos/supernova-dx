# Install the plugin to enable COPR repos
dnf5 install -y 'dnf5-command(copr)'

dnf -y copr enable ganto/lxc4

#umoci
dnf -y copr enable ganto/umoci

#ublue-os staging
dnf -y copr enable ublue-os/staging

#ublue-os packages
dnf -y copr enable ublue-os/packages

#karmab-kcli
dnf -y copr enable karmab/kcli

# Kvmfr module
dnf -y copr enable hikariknight/looking-glass-kvmfr

# Podman-bootc
dnf -y copr enable gmaglione/podman-bootc
