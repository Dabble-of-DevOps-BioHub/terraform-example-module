SHELL := /bin/bash

# List of targets the `readme` target should call before generating the readme
export README_DEPS ?= docs/targets.md docs/terraform.md

-include $(shell curl -sSL -o .build-harness "https://git.io/build-harness"; echo .build-harness)

## Lint terraform code
lint:
	$(SELF) terraform/install terraform/get-modules terraform/get-plugins terraform/lint terraform/validate

download/readme:
	wget https://raw.githubusercontent.com/dabble-of-devops-bioanalyze/biohub-info/master/docs/README.md.gotmpl -O ./README.md.gotmpl

docker/shell:
	docker run -it -v "$(shell pwd):/tmp/terraform-module" \
		-e README_TEMPLATE_FILE=/tmp/terraform-module/README.md.gotmpl \
		-w /tmp/terraform-module \
		--entrypoint bash  \
		cloudposse/build-harness:slim-latest

docker/lint:
	docker run -it -v "$(shell pwd):/tmp/terraform-module" \
		-e README_TEMPLATE_FILE=/tmp/terraform-module/README.md.gotmpl \
		-w /tmp/terraform-module \
		cloudposse/build-harness:slim-latest terraform/lint

docker/init:
	docker run -it -v "$(shell pwd):/tmp/terraform-module" \
		-e README_TEMPLATE_FILE=/tmp/terraform-module/README.md.gotmpl \
		-w /tmp/terraform-module \
		cloudposse/build-harness:slim-latest init

docker/readme:
	$(MAKE) download/readme
	docker run -it -v "$(shell pwd):/tmp/terraform-module" \
		-e README_TEMPLATE_FILE=/tmp/terraform-module/README.md.gotmpl \
		-w /tmp/terraform-module \
		cloudposse/build-harness:slim-latest readme
