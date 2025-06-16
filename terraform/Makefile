.PHONY: init plan apply rollback destroy lint

init:
	terraform init

plan:
	terraform plan -var-file=env/local.tfvars

apply:
	terraform apply -var-file=env/local.tfvars

rollback:
	kubectl rollout undo deployment/devops-api -n default

destroy:
	terraform destroy -var-file=env/local.tfvars

lint:
	tflint
