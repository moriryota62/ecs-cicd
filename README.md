
# 使い方

## デプロイ

### 環境
web GitLabでグループを作成する。グループのrunnerトークンを確認する。

main/enviromentの実行
　localsの値を変更する。

### サービス
GitLabグループに「app用」、「ecs用」の2つのレポジトリを作成する。（手順ではapp用にexample-app、ecs用にexample-ecsという名前ですすめる。）

main/service-templateを任意の名前でディレクトリコピーする。(手順ではexampleという名前ですすめる。)
main/example/prepareの実行
 localsの値を変更する。

main/example/prepareを実行することで、codepipleのソースが作成できている。
app用とecs用レポジトリに情報を格納する。CICDによりs3およびECRにソースデータを格納する。

main/example/deployの実行
 localsの値を変更する。

## アプリケーションの更新

### アプリケーションのソース更新
app用レポジトリに変更を加えれば良い。

### ECS定義の更新
ECS用レポジトリに変更を加えれば良い。

## 削除

### サービス
main/example/deploy、main/example/prepareを`terraform destroy`

### 環境
main/enviromentを`terraform destory`。（注意：先にmain/example/deployを削除していないとdestroyに失敗する。）