packer {
  required_plugins {
    amazon = {
      version = ">= 1.2.1"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

source "amazon-ebs" "my-ebs" {
  access_key    = ""
  secret_key    = ""
  ami_name      = "k8s-master-ami-1"
  instance_type = "t2.micro"
  region        = "ap-south-1"
  source_ami    = "ami-02d508880f5861d90"
  ssh_username  = "ec2-user"
}

build {
  name    = "my-first-build"
  sources = ["source.amazon-ebs.my-ebs"]

  provisioner "ansible" {
    playbook_file          = "../multinode-k8s-cluster-on-AWS/setup-master.yml"
    ansible_env_vars       = ["ANSIBLE_HOST_KEY_CHECKING=False", "ANSIBLE_ASK_PASS=False", "ANSIBLE_BECOME_METHOD=sudo", "ANSIBLE_BECOME_ASK_PASS=False"]
    extra_arguments        = ["--ssh-extra-args", "-o IdentitiesOnly=yes -o HostKeyAlgorithms=+ssh-rsa -o PubkeyAcceptedAlgorithms=+ssh-rsa", "--scp-extra-args", "'-O'", "--become", "-v"]
    user = "ec2-user"
  }

}
