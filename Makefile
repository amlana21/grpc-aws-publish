export AWS_ACCOUNT ?= 123456789012

# generate protos
0-generate-backend-proto:
	@cd backend/src/proto && protoc -I=. --go_opt=module=github.com/amlana21/grpc-aws --go_out=. --go-grpc_opt=module=github.com/amlana21/grpc-aws --go-grpc_out=. user.proto

1-build-backend-proto-envoy:
	@cd backend/src/proto && protoc --include_imports --include_source_info --descriptor_set_out=user.pb user.proto

3-gen_frontend_codes:
	@cd frontend && protoc -I=. user.proto \
  --js_out=import_style=commonjs:./src/proto \
  --grpc-web_out=import_style=typescript,mode=grpcwebtext:./src/proto

# -------------------------------------------deploy app---------

0-create-ecr-repo:
	@aws ecr create-repository --repository-name grpc-aws --profile grpc-post

1-build-push-envoy-proxy:
	@cd proxy_svc && docker build -t grpc-aws-envoy:test  .
	@docker tag grpc-aws-envoy:test $(AWS_ACCOUNT).dkr.ecr.us-east-1.amazonaws.com/grpc-aws:envoy-proxy
	@docker login -u AWS -p $(shell aws ecr get-login-password --region us-east-1 --profile grpc-post) $(AWS_ACCOUNT).dkr.ecr.us-east-1.amazonaws.com
	@docker push $(AWS_ACCOUNT).dkr.ecr.us-east-1.amazonaws.com/grpc-aws:envoy-proxy

2-build-push-backend:
	@cd backend && docker build -t grpc-aws-backend:test  .
	@docker tag grpc-aws-backend:test $(AWS_ACCOUNT).dkr.ecr.us-east-1.amazonaws.com/grpc-aws:backend
	@docker login -u AWS -p $(shell aws ecr get-login-password --region us-east-1 --profile grpc-post) $(AWS_ACCOUNT).dkr.ecr.us-east-1.amazonaws.com
	@docker push $(AWS_ACCOUNT).dkr.ecr.us-east-1.amazonaws.com/grpc-aws:backend

3-build-push-frontend:
	@cd frontend && npm run build
	@aws s3 cp frontend/build s3://grpc-post-frontend-3 --recursive --profile grpc-post

4-deploy-infra:
	@cd infra && terraform init
	@cd infra && terraform apply --auto-approve

deploy-app: 1-build-push-envoy-proxy 2-build-push-backend 4-deploy-infra  3-build-push-frontend

destroy-infra:
	@cd infra && terraform destroy --auto-approve
	@aws ecr delete-repository --repository-name grpc-aws --force --profile grpc-post

# -------------------------------------------end deploy app---------


