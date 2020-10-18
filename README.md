# レポジトリの説明

本レポジトリは GitLab CICD + AWS CodePipeline/Deploy を使用したECSのCICDパイプラインの仕組みと構築方法を解説したものです。

AWSの構築はTerraformを使用します。

パイプラインの動作を確認するためのアプリケーションとECS設定のサンプルレポジトリも用意しています。

本レポジトリで作成する環境のイメージは次の通りです。

**AWS環境図**

![AWS環境図](./documents/images/aws.svg)

**CICDフロー図**

![CICDフロー図](./documents/images/cicd.svg)

# バージョン

本レポジトリのモジュール群は以下のバージョンを前提としてます。（構築時のバージョンも記載します。）

terraform 0.13.2 以上　（構築時 0.13.3）  
aws providor 3.5.0以上　

# ドキュメント

モジュールや使い方などのドキュメントは以下になります。

- [モジュール説明](./documents/module.md)
- [CICDフロー説明](./documents/cicd.md)
- [使い方](./documents/howtouse.md)