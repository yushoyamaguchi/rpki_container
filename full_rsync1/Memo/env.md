# テストベット環境の証明書
全てのIPアドレス・全てのAS番号
```
            sbgp-ipAddrBlock: critical
                IPv4:
                  0.0.0.0/0
                IPv6:
                  ::/0

            sbgp-autonomousSysNum: critical
                Autonomous System Numbers:
                  0-4294967295
```

# tinetについて
docker execは-itをつけなかったらインタラクティブモードにならないため、それを利用する

# nohup
多分nohupの仕様なんだけど、docker execコマンドが終わっても標準出力が画面に続いてしまう。

