# common parameter
variable "tags" {
  description = "リソース群に付与する共通タグ"
  type        = map(string)
}

# module parameter
variable "ecr_repositories" {
  description = "作成するECRリポジトリ名のリスト"
  type        = list(string)
}
