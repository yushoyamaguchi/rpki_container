# 2023/1/18
## やったこと1
aptの何かが壊れていてupdateできなかったので、原因となるリポジトリをsource.listから消した
## やったこと2
```
curl --insecure http://krill.example.org/ta/ta.tal >> /tal/ta.tal

routinator -v --config /etc/routinator/routinator.conf update
```
でkrillとroutinatorの疎通を確かめるも、
```
[WARN] RRDP https://krill.example.org/rrdp/notification.xml: error sending request for url (https://krill.example.org/rrdp/notification.xml): error trying to connect: tcp connect error: Connection refused (os error 111)
[WARN] rsync://krill.example.org/repo/ta/0/86ABB44EA89B7DE2DA912575E7D67BCB4EA1FB2C.mft: no valid manifest found.
```
というエラーが出る
<br>
上はca側のポート開放の問題？

<br>
1回caをtestbedにしてから試してみる
<br>
ちなみに、routinatorサーバの/var/lib/routinator/rpki-cache/rsync/krill.example.org/ta/ta.cerにrsync://krill.example.org/repo/ta/0/86ABB44EA89B7DE2DA912575E7D67BCB4EA1FB2C.mftこのマニフェストが載ってる
<br>

このcerは、krillサーバ側の/mnt/volume_ams3_03/repository/ta/ta.cerと一致
### 目標
cerにURI:rsync://krill.example.org/repo/ta/0/F51A2616440B832DAC4FED28567CA5095A8811A5.mftと入っている。
このmftはkrillサーバの/var/lib/krill/data/repo/rsync/current/ta/0/F51A2616440B832DAC4FED28567CA5095A8811A5.mftを指している。
ここを一致させるのが目標！！


```
root@rp:/# find / -name "*.cer"
/var/lib/routinator/rpki-cache/rsync/krill.example.org/ta/ta.cer
/var/lib/routinator/rpki-cache/rsync/krill.example.org/repo/ta/0/5057DE931BC4163822769ED5ECD23B94E7004A5F.cer
```
taじゃなくてtestbedの方のmftを見に行っているのはなぜ？->
routinator updateをした時、下のcerが入る。　　この中に、謎のmftが書いてある。


## 疑惑
```
rsync://krill.example.org/repo/ta/0/
```
にアクセスしたときに、
```
/var/lib/krill/data/repo/rsync/current/ta/0/
```
ここにアクセスできてない？

## ためしてだめだったこと

/etc/nginx/sites-enabled/krill.example.org
```
location /ta {
    root /var/lib/krill/data/repo/rsync/current;
}
```

/etc/krill.conf
```
data_dir = "/mnt/volume_ams3_03/
```


## もう一つの課題
routinatorの設定の永続化方法  
場合によってはinitがすでにあるversionに変える

# rsync解決！
rysncd.confのパスを書き換えたらいけた！


# 230430
/etc/routinatorの下のconfigはroutinatorデーモンからきちんと読まれていそう
->localhost以外を開いたところ、読まないように変わっちゃうみたい(0513)
<br>
full_rsyncはrpとR1でRTRを張って実験したい

# 0513
# rpで手動でRTRサーバを立ち上げた後R1に手動で設定を入れた
```
   Network          Next Hop            Metric LocPrf Weight Path
N*  10.1.0.0/24      10.1.0.2                 0     20      0 65002 ?
N*>                  0.0.0.0                  0         32768 ?
V*> 192.168.1.0/24   0.0.0.0                  0         32768 ?
V*> 192.168.2.0/24   10.1.0.2                 0             0 65002 ?
```

```
R1# show rpki prefix-table 
host: 192.168.1.1 port: 3323
RPKI/RTR prefix table
Prefix                                   Prefix Length  Origin-AS
192.168.1.0                                 24 -  24        65001
192.168.2.0                                 24 -  24        65002
Number of IPv4 Prefixes: 2
Number of IPv6 Prefixes: 0
```

肝心の192.168.2.0/24のLocalPrefが設定されてない...が、Validにはなってる！
<br>
-> 答え:route-mapの横の数字はsec numberで、低いものから適用されていく
match条件がないroute-mapは全経路に適用されるため、Valid経路がこちらに適用されちゃってた

## route-map適用コマンド
``` 
neighbor 10.1.0.1 route-map rpki in
```
って打った時にThe route-map 'rpki' does not exist.になる問題の調査
<br>
-> 答え:その時はエラーメッセージが出るが、後々rpkiというroute-mapができた時には、このneighborコマンドそのroute-mapに適用されるから、問題ない(先打っといてもOK)