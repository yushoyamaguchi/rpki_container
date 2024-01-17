# 状態
## OpenBGPDのトポロジ状態
上から1,2,3,5
4も1の下

## ASPA
- 3の上は5
- 2の上は1か3

# メモ
3の上は5のASPAだけでもinvalidになった
<br>
downstreamをinvalidとならなかったのは、draftを読み間違えてASPAのオブジェクトが不適切なものになっていたため
<br>
RTRサーバと繋がずにaspa-setを指定しても、うまく検証できていないように見えた