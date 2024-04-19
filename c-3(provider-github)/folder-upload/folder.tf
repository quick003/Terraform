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
  content    = "testfile content"
}
##########################


resource "null_resource" "create_dir" {
  provisioner "local-exec" {
    # Execute the provisioner only after the github_repository resource is created
    # (Terraform automatically detects creation)

    command = <<EOF
      git clone https://github.com/quick003/github-private.git my-repo
      cd my-repo
      mkdir target_dir
    EOF
  }
}


resource "null_resource" "upload_file" {
  depends_on = [null_resource.create_dir]  # Ensure create_dir runs first

  provisioner "local-exec" {
    command = <<EOF
      cd my-repo
      cp F:/Terraform/c-3(provider-github)/folder-upload/test-folder/* my-repo/
      git add .
      git commit -m "Add files to target_dir"
      git push origin main  # Assuming the branch is 'main'
    EOF
  }
}