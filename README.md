# Aurora + Cosmic = Supernova

This is my custom immutable linux image, based on packages used by Aurora DX, but using the Cosmic dekstop environment. It's based on the latest Fedora Cosmic Atomic image from quay.io, and adds system-level packages such as Distrobox, Docker, VSCode, or Qemu on top. 

If you want to try it, you can freely switch to it from any bootc-enabled linux distro by doing: 
```
sudo bootc switch ghcr.io/marcosbolanos/supernova-dx:latest
```