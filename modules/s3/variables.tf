variable "bucket_name" {
  description = "The name of the S3 bucket"
  type        = string
}

variable "tags" {
  description = "Tags to apply to the S3 bucket"
  type        = map(string)
}

variable "force_destroy" {
  description = "A boolean that indicates all objects should be deleted from the bucket so that the bucket can be destroyed without error."
  type        = bool
}

variable "enable_website" {
  description = "Enable S3 static website hosting"
  type        = bool
  default     = false
}

variable "index_document" {
  description = "The index document for the website"
  type        = string
  default     = ""
}

variable "error_document" {
  description = "The error document for the website"
  type        = string
  default     = ""
}

variable "index_html" {
  description = "The path to the index.html file"
  type        = string
  default     = ""
}

variable "error_html" {
  description = "The path to the error.html file"
  type        = string
  default     = ""
}

variable "styles_css" {
  description = "The path to the styles.css file"
  type        = string
  default     = ""
}
