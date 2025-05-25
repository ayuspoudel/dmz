# -------------------------------
# Terraform Aliases & Config
# -------------------------------

alias tf='terraform'
alias tfi='terraform init'
alias tfp='terraform plan'
alias tfa='terraform apply'
alias tfd='terraform destroy'
alias tfv='terraform validate'
alias tfo='terraform output'
alias tfw='terraform workspace'
alias tfws='terraform workspace show'
alias tfl='terraform fmt -recursive'
alias tfaa='terraform apply -auto-approve'
alias tfdd='terraform destroy -auto-approve'
alias tfr='terraform init -reconfigure'
alias tfpvars='terraform plan -var-file="terraform.tfvars"'
alias tfavars='terraform apply -var-file="terraform.tfvars"'
alias tfrf='terraform refresh'

# Clean .terraform and apply fresh
alias tfcleanapply='[ -d .terraform ] && rm -rf .terraform && echo "🧹 .terraform removed"; terraform init && terraform apply'
