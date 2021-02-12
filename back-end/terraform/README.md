# Terraform script

Master에 push하면 Github action을 통해 aws에 배포한다.

### lambda.tf

작성한 람다함수를 AWS에 업로드 하기 위한 Terraform script.

### APIGateway.tf

AWS의 APIGateway를 설정하기 위한 Terraform script.


### Github secrets

Setting의 secrets에 AWS IAM credential(AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY)를 등록