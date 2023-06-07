# 0602
## 
nginxを使った443の通信自体はできている

## 
routinator.confにIPアドレス直打ちしてるの忘れない

## エラーメッセージ
routinator側
```
[WARN] RRDP https://krill.example.org/rrdp/notification.xml: error sending request for url (https://krill.example.org/rrdp/notification.xml): error trying to connect: invalid peer certificate contents: invalid peer certificate: UnknownIssuer
[INFO] RRDP https://krill.example.org/rrdp/notification.xml: Update failed and there is no current copy.
```

## 
```--rrdp-root-cert=rootCA.crt```をつけると、そもそもtaのところを見に行ってくれなくなる

## ToDo
まずはLet's Encryptで証明書を取得し、それを使ってnginxの設定をする
<br>
routinatorサーバをインターネット繋いだ状態でも、5個の実在のCAに対して取りにいかなくする
-> Let's encryptはその後じゃないとめんどい？

# 0607
## rrdpの問題点
自己署名証明書を使ったrrdp通信自体はできてそう。
krill側のrrdpサーバ的なのがまずい？
<br>
krillのrrdpの閲覧場所変えたらいけた！
rootCA.crtとcert.pemのどちらを指定しても通信できた！


## ToDo
- rrdpの続き
- ASPA試す