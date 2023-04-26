


# TALとは

talファイルとは、Krill等の認証局のURLが分かるように、Routinatorとかに設置するもの
つまり、ここにドメイン名を載せるなら、DNS立てる必要がある

# admin_token

admin_tokenは/etc/krill.confに書く

# Routinatorでの名前解決
routinator運用コンテナにkrill.example.orgの名前解決情報を入れ込む->hostsファイルに1行付け足すだけ
routinatorのtalの中身をKrillで生成したものに変える
(confをいじる必要性があるかも？)
routinatorのconfに書いてあるrepository_dirって何？

# 証明書とROAの登録
任意のアドレスの証明書の発行と登録の仕方
roaは krillc roa で発行
署名に必要な秘密鍵はどこ？ -> 秘密鍵はopensslコマンドで証明書を発行した際に、同時に発行できる
それに対応する公開鍵が入った証明書はどこ？ -> cerファイルの中に公開鍵が入っている


routinator側は、証明書とroaを取ってくる場所をそれぞれどこで設定するのか(証明書はtalの通りだと思うがroaは？)
->routinatorは証明書の中にあるSIA(Subject Information Access)を見て、roaをどこに取りに行くかを判断する

# Krill内の構造

https://localhost:3000/ta でアクセスしてるのはどこ？
/var/lib/krill/data/repo/rsync/current/ta/0/っぽいけど違った
curlとかのアクセスごとに計算して出力してるっぽい
<br>
230426追記:krillバックエンドというところらしい...



ta.cerとかいつ生成してる？
アクセスごとに生成




# コマンド

https://localhost:3000/rfc8181/testbed/ 

http://localhost:8080