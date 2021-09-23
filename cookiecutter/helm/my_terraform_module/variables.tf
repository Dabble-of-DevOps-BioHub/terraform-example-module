variable "region" {
  type        = string
  description = "AWS Region"
}


variable "helm_release_name" {
  type        = string
  description = "Helm Release Name"
  
}

variable "helm_release_namespace" {
  type        = string
  description = "Helm Release NameSpace"
  default = "default"
}

variable "helm_chart" {
  type        = string
  description = "Helm Chart"
  default = "https://charts.bitnami.com/bitnami"
}

variable "images" {
  type        = list(object({image  = string
tag = string
}))
  description = "docker images"
  default = []
}
