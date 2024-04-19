provider "github" {
  token = ""
}

resource "github_repository" "github-private-repo" {
  name        = "github-private"
  description = "First terraform github repo"
  visibility = "private"
  auto_init   = true
  gitignore_template = "Terraform"
}

resource "github_repository_file" "test" {
  repository = github_repository.github-private-repo.id
  file  = "test"
  #file = "test/testf.txt"
  content    = "testf"
}