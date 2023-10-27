############ Variables ############

$randomNumber = Get-Random -Minimum 1000 -Maximum 9999
$bucket = "tfstate-bucket-umbrella-$randomNumber"
$DynamoDBName = "tfstate-dynamodb-umbrella-$randomNumber"
$find = 'umbrella-0000'
$replace = "umbrella-${randomNumber}"


############ Define Env-variable ############
$env:BucketName = $bucket
$env:DynamoDBName = $DynamoDBName

############ Config RemoteState   ############

$config00RemoteState = '.\00_remote_state\template-main'
$NewFileConfig00RemoteState = '.\00_remote_state\main.tf'
Get-Item -Path $config00RemoteState
Copy-Item -Path $config00RemoteState -Destination $NewFileConfig00RemoteState
(Get-Content $NewFileConfig00RemoteState).replace($find, $replace) | Set-Content $NewFileConfig00RemoteState


############ Config VPC01 ############
$config01Vpc = '.\01_vpc\template-main'
$NewFile01Vpc = '.\01_vpc\main.tf'

Get-Item -Path $config01Vpc
Copy-Item -Path $config01Vpc -Destination $NewFile01Vpc
(Get-Content $NewFile01Vpc).replace($find, $replace) | Set-Content $NewFile01Vpc

############ Config EC02 + Userdata  ############

$TemplateFileUserData02EC2 = '.\02_ec2\user-data-instance3-template'
$NewFileUserData02EC2 = '.\02_ec2\user-data-instance3'
Get-Item -Path $TemplateFileUserData02EC2
Copy-Item -Path $TemplateFileUserData02EC2 -Destination $NewFileUserData02EC2
(Get-Content $NewFileUserData02EC2).replace($find, $replace) | Set-Content $NewFileUserData02EC2


$config02EC2 = '.\02_ec2\template-main'
$NewFileConfig02EC2 = '.\02_ec2\main.tf'
Get-Item -Path $config02EC2
Copy-Item -Path $config02EC2 -Destination $NewFileConfig02EC2
(Get-Content $NewFileConfig02EC2).replace($find, $replace) | Set-Content $NewFileConfig02EC2

############ Config EKS   ############

$config03EKSCluster = '.\03_eks_cluster\template-main'
$NewFileConfig03EKSCluster = '.\03_eks_cluster\main.tf'
Get-Item -Path $config03EKSCluster
Copy-Item -Path $config03EKSCluster -Destination $NewFileConfig03EKSCluster
(Get-Content $NewFileConfig03EKSCluster).replace($find, $replace) | Set-Content $NewFileConfig03EKSCluster

############ Config Kubernetes   ############


$config04Kubernetes = '.\04_kubernetes\template-main'
$NewFileConfig04Kubernetes = '.\04_kubernetes\provider.tf'
Get-Item -Path $config04Kubernetes
Copy-Item -Path $config04Kubernetes -Destination $NewFileConfig04Kubernetes
(Get-Content $NewFileConfig04Kubernetes).replace($find, $replace) | Set-Content $NewFileConfig04Kubernetes