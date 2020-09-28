# common parameter
variable "tags" {
  description = "リソース群に付与する共通タグ"
  type        = map(string)
}

variable "pj" {
  description = "リソース群に付与する接頭語"
  type        = string
}

variable "vpc_id" {
  description = "リソース群が属するVPCのID"
  type        = string
}

# module parameter
variable "ec2_gitlab_url" {
  description = "GitLab Runnerのアクセス先となる、GitLabのURL"
  type        = string
}

variable "ec2_registration_token" {
  description = "グループrunnerとして登録するためのトークン"
  type        = string
}

variable "ec2_runner_name" {
  description = "GitLabで表示されるrunnerの名前"
  type        = string
}

variable "ec2_runner_tags" {
  description = "runnerに付与するタグのリスト"
  type        = list(string)
}

variable "ec2_instance_type" {
  description = "GitLab Runnerのインスタンスタイプ"
  type        = string
}

variable "ec2_subnet_id" {
  description = "GitLab Runnerを配置するパブリックサブネットのID"
  type        = string
}

variable "ec2_root_block_volume_size" {
  description = "GitLab Runnerのルートデバイスの容量(GB)"
  type        = string
}

variable "ec2_key_name" {
  description = "GitLab Runnerのインスタンスにsshログインするためのキーペア名"
  type        = string
}