# レポジトリの説明

GitLab + ECS CICDパイプラインを構築するTerraformモジュール群とそのセットアップ方法を格納したレポジトリです。GitLabに作成するレポジトリのサンプルも格納しています。本レポジトリで作成するCICDの全体像は以下の通りです。

AWS構成図

CICDフロー図

# モジュールの説明

大きく`環境構築モジュール群`と`サービス構築モジュール群`に別れます。`環境構築モジュール群`はECSサービスとGitLab CICDを行うための環境を準備するモジュールです。プロジェクトで一度だけ実施するモジュールです。`サービス構築モジュール群`はECSサービスをデプロイする前準備とECSサービスのデプロイおよびCICDパイプラインを構築するモジュールです。サービスごとに実施するモジュールです。

各モジュールは`main`と`module`のディレクトリに別れて構成されます。`main`は各モジュールのパラメータを指定する`{モジュール名}.tf`という名前のtfファイルを格納しています。基本的に利用者はこのmain配下のtfファイル内にあるlocalsの値のみ修正し実行します。`module`は各モジュールが実行するサブモジュール群です。基本的に利用者はmodule配下を気にする必要はありません。（追加の設定など細かなカスタマイズが必要な方や実装が気になる方は見てください。）

また、各モジュールを実行した後に作成されるtfstateはとくにリモートへ保存する設定をしておらず、実行時のカレントディレクトリに保存されます。必要に応じてリモートへの保存やロックの仕組みを実装してください。

## 環境構築モジュールの説明

基本となる以下環境をセットアップするterraformモジュールを用意しています。

- ネットワーク
- GitLabサーバ
- GitLab Runner
- ECSクラスタ

`ネットワーク`はVPCとパブリックサブネットおよびプライベートサブネットを構築するterraformモジュールです。インターネットゲートウェイやNATゲートウェイも構築します。このモジュールで作成した`VPCのID`や`サブネットのID`は他のモジュールでも使用します。このモジュールはVPCがない場合などに実行ください。すでにVPCやサブネットがある場合はそれならのIDを他モジュールで使用してください。

`GitLabサーバ`はセルフホストのGitLabサーバを構築するモジュールです。任意のEC2タイプで構築できます。AMIは指定可能ですが、デフォルトではGitLabより公開されている最新のGitLab CE AMIを使用します。使用にはあらかじめAMIをサブスクライブする必要があります。GitLabサーバにはEIPを付与します。また、以下の追加機能を任意で設定できます。追加機能はデフォルトでは`無効`にしています。このモジュールを実行せす、インターネットのSaaS版GitLabを使用しても良いです。その場合、SaaS版GitLabでグループ作成やRunnerトークンの確認を行ってください。

|機能|説明|
|-|-|
|自動起動/停止スケジュール|GitLabサーバは自動で起動/停止するスケジュールを設定します。有効にした場合、デフォルトでは平日の日本時間09-19時の間に起動するように設定します。スケジュールは任意の値に変更可能です。|
|自動バックアップ|GitLabサーバのEBSボリュームのスナップショットを取得します。有効にした場合、デフォルトでは日本時間の0時に1世代のスナップショットを取得します。取得時間、世代数は任意の値に変更可能です。|

`GitLab Runner`はGitLab CICDによるパイプライン処理を実行するGitLab Runnerサーバを構築するモジュールです。AMIは最新のAmazon Linuxを使用します。接続するGitLabサーバと認証用のトークンを設定し、Runnerのセットアップを行います。このセットアップはUserdataにより自動で行います。また、GitLab RunnerサーバにはCICD処理のためS3とECRへの書き込みを許可するIAMロールを割り当てます。

`ECSクラスタ`はECSのサービスをまとめるクラスタを構築するモジュールです。また、ECSタスクやCodePipeline、CodeDeployに必要となる共通のIAMポリシーおよびロールを作成します。

## サービス構築モジュールの説明

ECSサービスとサービスのCICDをセットアップするモジュールを用意しています。大きく以下2つあります。

- ソース
- サービスデプロイ

`ソース`はサービスをデプロイする前のソース置き場を構築するモジュールです。コンテナイメージを格納するECRレポジトリとデプロイ設定を格納するS3バケットを構築します。

`サービスデプロイ`はサービスのデプロイおよびCICDの設定を行うモジュールです。ECSサービスに紐づくALBもデプロイします。CodePipelineとCodeDeployによるECSサービスのBlue/Greenデプロイを設定します。このモジュールを実行する前にソースモジュールで作成したソース置き場にコンテナイメージおよびデプロイ設定を格納してください。CICDはソース置き場の情報が更新される度に自動で実行されます。

# 使い方

以下の順番で各モジュールを実行します。環境構築の`ネットワーク`および`GitLabサーバ`は自身の環境に合わせて実行要否を判断してください。サービス構築の`GitLab CICDによるソース配置`はTerraformモジュールの実行ではなく、GitLabのレポジトリに対する作業になります。サービス構築はサービスごとに実行してください。

- 環境構築
  - ネットワーク（任意）
  - GitLabサーバ（任意）
  - GitLab Runner
  - ECSクラスタ
- サービス構築
  - ソース
  - GitLab CICDによるソース配置
  - サービスデプロイ

まずは本レポジトリを任意の場所でクローンしてください。なお、以降の手順では任意のディレクトリのパスを`$CLONEDIR`環境変数として進めます。

``` sh
export CLONEDIR=`pwd`
git clone https://github.com/moriryota62/ecs-cicd.git
```

## 環境構築

環境構築はプロジェクトで一度だけ行います。環境の分け方によっては複数実施するかもしれません。`main`ディレクトリをコピーして`環境名`ディレクトリなどの作成がオススメです。以下の手順では`cicd-dev`という環境名を想定して記載します。

``` sh
cd $CLONEDIR/ecs-cicd/
cp -r main cicd-dev
export PJNAME=cicd-dev
```

また、すべてのモジュールで共通して設定する`pj`、`region`、`owner`の値はsedで置換しておくと後の手順が楽です。regionはデフォルトでは'ap-northeast-1'を指定しています。変える必要がなければsedする必要ありません。

**macの場合**

``` sh
cd $PJNAME
find ./ -type f -exec grep -l 'ap-northeast-1' {} \; | xargs sed -i "" -e 's:ap-northeast-1:us-east-2:g'
find ./ -type f -exec grep -l 'PJ-NAME' {} \; | xargs sed -i "" -e 's:PJ-NAME:cicd-dev:g'
find ./ -type f -exec grep -l 'OWNER' {} \; | xargs sed -i "" -e 's:OWNER:nobody:g'
```


### ネットワーク

すでにVPCやサブネットがある場合、ネットワークのモジュールは実行しなくても良いです。その場合はVPCとサブネットのIDを確認しておいてください。ネットワークモジュールでVPCやサブネットを作成する場合は以下の手順で作成します。

ネットワークモジュールのディレクトリへ移動します。

``` sh
cd $CLONEDIR/ecs-cicd/$PJNAME/environment/network
```

`network.tf`を編集します。`region`と`locals`配下のパラメータを修正します。`region`と`pj`は他すべてのモジュールでも同じ値を設定するようにしましょう。あらかじめ全置換しても良いかもしれません。

修正したら以下コマンドでモジュールを作成します。

``` sh
terraform apply
> yes
```

### GitLabサーバ

インターネットのSaaS版GitLabを使用する場合、GitLabサーバのモジュールは実行しなくても良いです。SaaS版でもグループの作成やRunnerトークンの確認は実施してください。

GitLabサーバモジュールのディレクトリへ移動します。

``` sh
cd $CLONEDIR/ecs-cicd/$PJNAME/environment/self-host-gitlab
```

`self-host-gitlab.tf`を編集します。`region`と`locals`配下のパラメータを修正します。とくにvpc_idとsubnet_id（パブリックサブネットのID）は自身の環境に合わせて修正してください。

修正したら以下コマンドでモジュールを作成します。

``` sh
terraform apply
> yes
```

terraform実行後、以下の通りGitLabサーバにアクセスしてGitLabサーバの準備をしてください。

- GitLabサーバを構築したら許可した端末からGUIに接続します。ブラウザにEC2インスタンスのパブリックDNS名を入力してください

- 初回アクセスの場合、rootのパスワード変更を求められるため、パスワードを設定してください

- rootのパスワードを入力するとログイン画面が表示されます。先ほど設定したパスワードでrootにログインします

- 上部メニューバーの[Admin Area（スパナマーク）]を選択します

- 左メニューから[Settings]-[General]-[Visibility and access controls]を開き`Custom Git clone URL for HTTP(S)`にEC2インスタンスのパブリックDNS名を入力して[Save changes]します。（デフォルトではAWSの外部で名前解決できない名前になっているためです。名前解決できる名前ならプラベートDNS名以外の任意のドメイン名でも構いません。）

- 左メニューから[Overview]-[Users]を開き`New user`を選択します。任意のユーザを作成してください。（パスワードはユーザ作成後、ユーザの一覧画面でeditすると設定できる。）

- 左メニューから[Overview]-[Groups]を開き`New group`を選択します。任意の名前のグループを作成してください。また、上記作成したユーザをグループのownerに設定してください

- 一度rootからログアウトし、上記ユーザでログインしなおしてください

- 上部メニューバーの[Groups]-[Your groups]を表示し、先ほど作成したグループを選択します

- グループの画面で左メニューから[Settings]-[CICD]-[Runners]を開きます。`Set up a group Runner manually`の2のURLと3のトークンを確認します。たとえば以下のような値となっているはずです

1. http://ec2-3-138-55-5.us-east-2.compute.amazonaws.com/
2. 972hz6YiJTWUcN4ECUNk

### GitLab Runner

GitLab Runnerサーバモジュールのディレクトリへ移動します。

``` sh
cd $CLONEDIR/ecs-cicd/$PJNAME/environment/gitlab-runner
```


### ECSクラスタ

ECSクラスタモジュールのディレクトリへ移動します。

``` sh
cd $CLONEDIR/ecs-cicd/$PJNAME/environment/ecs-cluster
```

`ecs-cluster.tf`を編集します。`region`と`locals`配下のパラメータを修正します。

修正したら以下コマンドでモジュールを作成します。

``` sh
terraform apply
> yes
```

## サービス構築

サービスの構築はサービスごとに行います。terraformのコードもサービスごとに作成するため、あらかじめ用意された`service-template`ディレクトリをコピーし、`サービス名`ディレクトリなどの作成がオススメです。以下の手順では`test-app`というサービス名を想定して記載します。

``` sh
cd $CLONEDIR/ecs-cicd/$PJNAME/
cp -r service-template test-app
```

また、すべてのモジュールで共通して設定する`pj`と`app`の値はsedで置換しておくと後の手順が楽です。なお、ここで設定するpjの値は環境構築モジュールで設定したpjと同じ値にしてください。

**macの場合**

``` sh
cd test-app
find ./ -type f -exec grep -l 'APP-NAME' {} \; | xargs sed -i "" -e 's:APP-NAME:test-app:g'
```

### ソース

ソースモジュールのディレクトリへ移動します。


### GitLab CICDによるソース配置


### サービスデプロイ