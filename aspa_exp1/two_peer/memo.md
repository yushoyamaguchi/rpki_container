# OpenBGPDの挙動
peerやcustomerから受け取った、オリジンが隣接するそのASにない経路は転送しない。
roleを空欄にすると転送するようになった。

- 再配布のポリシーの問題？
- ASPA的な問題？

Lフラグがついているから？

# OpenBGPDのflag
- A: Anounced 他のASにアナウンスしている
- L: Local?