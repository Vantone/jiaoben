# 工具合集
## 1 docker内地中转站
docker.dadunode.com
### 1.1 适合撸毛的docker镜像
/// docker版本windows
https://hub.docker.com/r/dockurr/windows

`
docker pull  docker.dadunode.com/dockurr/windows:latest
docker run -itd  --name 'windows' -p 8006:8006 --device=/dev/kvm --cap-add NET_ADMIN --stop-timeout 120 dockurr/windows
`

/// docker版本chrome

## 2 github内地中转
git.dadunode.com
