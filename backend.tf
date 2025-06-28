terraform {
  backend "gcs" {
    bucket = "death-star-tfstate-death-star-platform-666"
    prefix = "terraform/state"
  }
}
