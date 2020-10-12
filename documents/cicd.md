# CICDフロー説明

##  GitLab CICD

アプリケーションおよびECSのデプロイ設定はそれぞれGitLabのレポジトリで管理しています。各レポジトリに変更がプッシュされるとGitLab CICDにより変更内容がAWSのソース置き場（S3 or ECR）に配置されます。

### アプリケーションソース

アプリケーションのレポジトリの`masterブランチに変更がプッシュ`されるとGitLab CICDによりアプリケーションビルドのパイプラインが自動実行されます。サンプルレポジトリの場合は以下のようなパイプラインを定義しています。パイプラインの設定内容はレポジトリのルートにある`.gitlab-ci.yml`を参照ください。

- [kaniko](https://docs.gitlab.com/ee/ci/docker/using_kaniko.html)を使用し、レポジトリのルートにあるdockerfileをbuildする
- buildしたimageは以下の2つのタグを付与しECRにプッシュする
  - <ECRホスト名>/<PJ-NAME-APP-NAME>:latest
  - <ECRホスト名>/<PJ-NAME-APP-NAME>:<コミットハッシュ>
- このパイプラインは`master`ブランチに対する変更時に実行する
- パイプラインは`<PJ-NAME>`のタグがついたrunnerで実行する

### ECSデプロイ設定

ECSデプロイ設定のレポジトリに対し`masterブランチに変更がプッシュ`されるとGitLab CICDによりECSデプロイ設定のデプロイパイプラインが自動実行されます。サンプルレポジトリの場合は以下のようなパイプラインを定義しています。パイプラインの設定内容はレポジトリのルートにある`.gitlab-ci.yml`を参照ください。

- [kaniko](https://docs.gitlab.com/ee/ci/docker/using_kaniko.html)を使用し、レポジトリのルートにあるdockerfileをbuildする
- buildしたimageは以下の2つのタグを付与しECRにプッシュする
  - <ECRホスト名>/<PJ-NAME-APP-NAME>:latest
  - <ECRホスト名>/<PJ-NAME-APP-NAME>:<コミットハッシュ>
- このパイプラインは`master`ブランチに対する変更時に実行する
- パイプラインは`<PJ-NAME>`のタグがついたrunnerで実行する

## CloudWatch

## CodePipeline

### ソースの取得

### CodeDeploy