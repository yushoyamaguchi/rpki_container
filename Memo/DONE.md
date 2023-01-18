# 2023/1/18
## やったこと1
aptの何かが壊れていてupdateできなかったので、原因となるリポジトリをsource.listから消した
## やったこと2
```
curl --insecure http://krill.example.org/ta/ta.tal >> /tal/ta.tal

routinator --config /etc/routinator/routinator.conf update
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

## もう一つの課題
routinatorの設定の永続化方法  
場合によってはinitがすでにあるversionに変える
