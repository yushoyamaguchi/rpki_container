# 鍵の種類

CANAME.keyが秘密鍵
公開鍵は証明書(cer)に埋め込まれている
証明書を変換したものをpemと呼んでいる


# SIA(Subject Information Access)

rsyncするディレクトリの場所
マニフェスト(発行したファイル一覧)の場所
rrdpのURI(rrdpはrsyncに変わるプロトコル)

http://oid-info.com/index.html
に対応するオブジェクトid(左辺の数値の並び)の番号が書かれている


# その他

asns
自分の下に入っているasすべて

# RPKIツリーの親子の情報について
リソース証明書の拡張フィールドで表す。
自分の子の情報はSIA(Subject Information Access)に、自分の親の情報はAIA(Authority Information Access)に格納する。
つまり親子関係は、証明書を作る時点で確定していなければならない？
新たに自分の下にCAができたら、証明書作り直し？