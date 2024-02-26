.PHONY: init plan apply destroy update-secrets

init:
	terraform -chdir=terraform init

plan: update-secrets
	terraform -chdir=terraform plan

apply: update-secrets
	terraform -chdir=terraform apply

destroy: update-secrets
	terraform -chdir=terraform destroy

update-secrets:
	@echo "Updating secrets..."
	@TOKEN=$$(ansible-vault view ansible/secrets.yml --ask-vault-pass | grep 'cloud_provider_token' | awk '{print $$2}') && \
	echo "cloud_provider_token = $$TOKEN" > terraform/terraform.tfvars
