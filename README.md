
# 使い方

# 環境構築

基本となる以下環境をセットアップするterraformモジュールを用意しています。

- ネットワーク
- GitLabサーバ
- GitLab Runner
- ECSクラスタ

`ネットワーク`はVPCとパブリックサブネットおよびプライベートサブネットを構築するterraformモジュールです。インターネットゲートウェイやNATゲートウェイも構築します。このモジュールで作成した`VPCのID`や`サブネットのID`は他のモジュールでも使用します。このモジュールの実行は必須ではありません。すでにVPCやサブネットがある場合はそれならのIDを他モジュールで使用してください。

`GitLabサーバ`はセルフホストのGitLabサーバを構築するモジュールです。任意のEC2タイプで構築できます。AMIは指定可能ですが、デフォルトではGitLabより公開されている最新のGitLab CE AMIを使用します。使用にはあらかじめAMIをサブスクライブする必要があります。GitLabサーバにはEIPを付与します。また、以下の追加機能を任意で設定できます。追加機能はデフォルトでは`無効`にしています。

|機能|説明|
|-|-|
|自動起動/停止スケジュール|GitLabサーバは自動で起動/停止するスケジュールを設定します。有効にした場合、デフォルトでは平日の日本時間09-19時の間に起動するように設定します。スケジュールは任意の値に変更可能です。|
|自動バックアップ|GitLabサーバのEBSボリュームのスナップショットを取得します。有効にした場合、デフォルトでは日本時間の0時に1世代のスナップショットを取得します。取得時間、世代数は任意の値に変更可能です。|


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