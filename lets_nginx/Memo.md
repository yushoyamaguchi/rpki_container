# 0603
## access
```
curl localhost:8080
curl --insecure https://localhost:44300
```

## commands
```
certbot --nginx -d krill.example.org --register-unsafely-without-email --agree-tos
certbot --nginx -d krill.yamaguchi.com --register-unsafely-without-email --agree-tos
```

エラーが出た。
nginxの設定ファイルとの兼ね合いをもう少し調べる。

## 懸念
Let's Encryptはローカル環境では使えないかも...
自己署名証明書を使うしかないかもしれない。
