## QuickStart

Run the cookiecutter command to generate a project template.

Your project name is a concatenation of `["namespace", "environment", "stage", "name", "attributes"]` with `-` between. You can leave any of them out.

For example:

```json
{
    "namespace" : "bioanalyze",
    "environment" : "eks",
    "stage" : "dev"
}
```

Results in the project name: `bioanalyze-eks-dev`.

### Run with the default settings

The simplest way to run cookiecutter is by using the default CLI and running through the prompts.

```
cookiecutter \
	{{cookiecutter.docs_data.github_repo}} \
	--directory {{cookiecutter.docs_data.directory}}
```

### Supply variables from a configuration file

Some recipes have a lot of variables, and you may not be ready to decide them all in one go.

If that is the case create a `config.json` file and feed that to cookiecutter. At a minimum you need to include your project name. For more information on naming schemas see. {ref}`terraform-module-naming-convention`

```json
{
    "namespace" : "bioanalyze",
    "environment" : "eks",
    "stage" : "dev"
}
```

Run cookiecutter with your supplied config and use the suppress user input options.

```bash
cookiecutter \
	{{cookiecutter.docs_data.github_repo}} \
	--directory {{cookiecutter.docs_data.directory}} \
    --config-file path-to-config.json \
    --no-input
```

Or from a python script or console:

```python
cookiecutter({{cookiecutter.docs_data.github_repo}},
        directory={{cookiecutter.docs_data.directory}},
        no_input=True,
        # add your own namespace/environment/stage here
        extra_context= {
            "namespace" : "bioanalyze",
            "environment" : "eks",
            "stage" : "dev"
        })
```

## Customizing your Deployment with Terraform Variables

From here take a look at the `terraform.example.tfvars` and the `terraform.example.tfvars.json` file.

Each of these files serves the same purpose, to add variables to our deployment. Pick one of these files and rename it remove the `.example` from the name.

```bash
cp terraform.example.tfvars terraform.tfvars.json
```

Or:

```bash
cp terraform.example.tfvars terraform.tfvars.json
```


```{warning}
Make sure to use only one file, either the `tfvars` or the `tfvars.json`. Using both will make the computer lose it's mind.
```

(terraform-module-naming-convention)=
## Terraform Module Naming Convention

This is a cookicutter template to create Terraform modules based on the [BioAnalyze](https://www.bioanalyze.io) terraform recipe examples.

We use the [CloudPosse](https://github.com/cloudposse/terraform-example-module) as a base, and the [Label](https://github.com/cloudposse/terraform-null-label) module to generate a name.

The name is generated as:

```
delimiter = '{{cookiecutter.delimiter}}'

label_order         = ["namespace", "environment", "stage", "name", "attributes"]
id_context = {
    "namespace" : "{{ cookiecutter.namespace}}",
    "tenant" : "{{cookiecutter.tenant}}",
    "name" : "{{ cookiecutter.name}}",
    "environment" : "{{cookiecutter.environment}}",
    "stage"       : "{{cookiecutter.stage}}",
    "name"       : "{{cookiecutter.name}}"
}

labels = []
for l in label_order:
    if l in id_context and l:
        labels.append(id_context[l])

id_full = delimiter.join(labels)

{{ cookiecutter.update({ "project_name": id_full }) }}
```


You do not need to include all the labels. Usually I only use namespace, environment, and stage.

```
namespace = "bioanalyze"
environment = "eks"
stage = "dev"
```

Would result in the project name `bioanalyze-eks-dev`.

Before you start creating multiple projects it's recommended that you document your naming convention.

## Terraform Resources

[Terraform Variables](https://www.terraform.io/docs/language/values/variables.html)
