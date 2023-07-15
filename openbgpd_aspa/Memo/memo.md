# routinatorのcommit番号
```
2b450d0
```
のコミットだと、ASPAの通信をkrillとできた

## 理由
ASPAのnew verにRoutinatorだけ対応しているため。
krill ver14になったら、Routinatorも最新にしないといけない。

# ASPAの状態が?になる理由
R1にて、どれがproviderでどれがcustomerかを設定する必要がある？
## show set
aspa-setを指定してもダメだったので、上の仮説に至った。(RTR経由でも認識自体はできているっぽいの+aspa-set使っても状態は?のままだった)