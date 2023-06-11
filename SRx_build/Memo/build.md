# Quagga-SRxのbuild
./configureがうまいこと成功すれば、あとはmakeとmake installでいける気がしてる。
# SRx-Crypto-API
SRx-Crypto-APIはBGPsec用のものっぽいから、外してもビルドしてもいいかもしれない。(できるなら)

# 豆知識
## bootstrap.sh
bootstrap.shは、configureを生成するためのスクリプト。configure.acを元にconfigureを生成する。
## configure
configureは、configure.acを元にMakefileを生成する。