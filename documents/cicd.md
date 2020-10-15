# CICDフロー説明

##  GitLab CICD

アプリケーションおよびECSのデプロイ設定はそれぞれGitLabのレポジトリで管理しています。各レポジトリに変更がプッシュされるとGitLab CICDにより変更内容がAWSのソース置き場（S3 or ECR）に配置されます。

### アプリケーションソース

アプリケーションのレポジトリの`masterブランチに変更がプッシュ`されるとGitLab CICDによりアプリケーションビルドのパイプラインが自動実行されます。サンプルレポジトリの場合は以下のようなパイプラインを定義しています。パイプラインの設定内容はレポジトリのルートにある`.gitlab-ci.yml`を参照ください。

- [kaniko](https://docs.gitlab.com/ee/ci/docker/using_kaniko.html)を使用し、レポジトリのルートにあるdockerfileをbuildする
- buildしたimageは以下のタグを付与しECRにプッシュする
  - <ECRホスト名>/<PJ-NAME-APP-NAME>:latest
- このパイプラインは`master`ブランチに対する変更時に実行する
- パイプラインは`<PJ-NAME>`のタグがついたrunnerで実行する

ECRにプッシュされる最新のイメージは常に`<ECRホスト名>/<PJ-NAME-APP-NAME>:latest`というイメージ名になります。古いイメージは`タグなし`となり一日経過後にライフサイクルポリシーにより自動で削除されます。もし、古いイメージに戻したい場合はアプリケーションレポジトリを過去のバージョンに戻してイメージを再ビルドしてください。

### ECSデプロイ設定

ECSデプロイ設定のレポジトリに対し`masterブランチに変更がプッシュ`されるとGitLab CICDによりECSデプロイ設定のデプロイパイプラインが自動実行されます。サンプルレポジトリの場合は以下のようなパイプラインを定義しています。パイプラインの設定内容はレポジトリのルートにある`.gitlab-ci.yml`を参照ください。

- [ryotamori/alpine-zip](https://hub.docker.com/repository/docker/ryotamori/alpine-zip/general)イメージを使用し、レポジトリ内のファイル（`appspec.yaml`、`taskdef.json`）をzipファイルにまとめる
- zipファイルをS3の`s3://<PJ-NAME-APP-NAME>`バケットに格納する
- このパイプラインは`master`ブランチに対する変更時に実行する
- パイプラインは`<PJ-NAME>`のタグがついたrunnerで実行する

## CloudWatch

### ECRの変更検知

### S3の変更検知

## CodePipeline

### ソースの取得

### CodeDeploy