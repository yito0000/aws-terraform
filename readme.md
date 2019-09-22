### 概要
terraformを使ってAWSの以下のサービスの設定を行う
* VPC
* サブネット
* セキュリティグループ
* ルートテーブル
* インターネットゲートウェイ
* EC2

### あらかじめ準備しておくこと
* aws cliのインストール
* ec2で使用するキーペア

### 初めて使う場合
`variables.tf.sample` をコピーしてファイル名を `variables.tf` に変更し、変数を設定する
次に以下のコマンドを実行
```
$ terraform init
```

### 実行
確認
```
$ terraform plan
```

環境作成
```
$ terraform apply
```
作成後、sshで接続できればOK


削除する場合
```
$ terraform destroy
```