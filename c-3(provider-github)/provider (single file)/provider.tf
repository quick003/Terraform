provider "github" {
    token = ""
}

resource "github_repository" "terraform-github" {
  name        = "terraform-first"
  description = "First terraform github repo"
  visibility = "public"
  auto_init = true
}

resource "github_repository" "terraform-github-2" {
  name        = "terraform-second"
  description = "Second terraform github repo"
  visibility = "public"
  auto_init = true
}