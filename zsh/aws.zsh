# -------------------------------
# AWS CLI Profile Switching
# -------------------------------
alias awsdev='export AWS_PROFILE=dev'
alias awsprod='export AWS_PROFILE=prod'

# -------------------------------
# S3 Shortcuts
# -------------------------------
alias s3ls='aws s3 ls'
alias s3cp='aws s3 cp'
alias s3mv='aws s3 mv'
alias s3rm='aws s3 rm'
alias s3sync='aws s3 sync'

# -------------------------------
# EC2 Management
# -------------------------------
alias ec2ls='aws ec2 describe-instances --query "Reservations[].Instances[].InstanceId" --output table'
alias ec2ip='aws ec2 describe-instances --query "Reservations[].Instances[].PublicIpAddress" --output text'
alias ec2sg='aws ec2 describe-security-groups --query "SecurityGroups[].{ID:GroupId,Name:GroupName}" --output table'
alias ec2vols='aws ec2 describe-volumes --query "Volumes[].{ID:VolumeId,State:State,Size:Size}" --output table'
alias ec2types='aws ec2 describe-instance-types --output table'
alias ec2start='aws ec2 start-instances --instance-ids'
alias ec2stop='aws ec2 stop-instances --instance-ids'
alias ec2reboot='aws ec2 reboot-instances --instance-ids'

# -------------------------------
# EBS Volume Management
# -------------------------------
alias ebsls='aws ec2 describe-volumes --query "Volumes[].{ID:VolumeId,Size:Size,State:State}" --output table'
alias ebsattach='aws ec2 attach-volume --instance-id'
alias ebsdetach='aws ec2 detach-volume --volume-id'
alias ebssnap='aws ec2 create-snapshot --volume-id'
alias ebssnapls='aws ec2 describe-snapshots --owner-ids self --query "Snapshots[].{ID:SnapshotId,Time:StartTime}" --output table'

# -------------------------------
# IAM Helpers
# -------------------------------
alias iamusers='aws iam list-users --query "Users[].UserName" --output table'
alias iamroles='aws iam list-roles --query "Roles[].RoleName" --output table'
alias iampolicies='aws iam list-policies --scope Local --query "Policies[].PolicyName" --output table'
alias iamgroups='aws iam list-groups --query "Groups[].GroupName" --output table'

# -------------------------------
# Lambda
# -------------------------------
alias lambdals='aws lambda list-functions --query "Functions[].FunctionName" --output table'
alias lambdaconfig='aws lambda get-function-configuration --function-name'
alias lambdaupdate='aws lambda update-function-code --function-name'

# -------------------------------
# ECR
# -------------------------------
alias ecrrepos='aws ecr describe-repositories --query "repositories[].repositoryName" --output table'
alias ecrlogin='aws ecr get-login-password | docker login --username AWS --password-stdin'
alias ecrimages='aws ecr list-images --repository-name'

# -------------------------------
# EKS
# -------------------------------
alias eksclusters='aws eks list-clusters --output table'
alias eksconfig='aws eks update-kubeconfig --name'

# -------------------------------
# ECS
# -------------------------------
alias ecsclusters='aws ecs list-clusters --output table'
alias ecsservices='aws ecs list-services --cluster'
alias ecsdescribe='aws ecs describe-services --cluster'

# -------------------------------
# General AWS Utility
# -------------------------------
alias awswhoami='aws sts get-caller-identity'
alias awsregions='aws ec2 describe-regions --query "Regions[].RegionName" --output table'
alias awsazs='aws ec2 describe-availability-zones --query "AvailabilityZones[].ZoneName" --output table'
