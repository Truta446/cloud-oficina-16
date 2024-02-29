# Template para Distribution Cloudfront e WAF em Terraform

Essa pasta contém arquivos para serem usados de modelo para criar Distributions novas no CDN/WAF da AWS

## Inputs

- Todas as entradas obrigatórias estão em [variables.tf](./variables.tf) file.

## Outputs

- Todas as saídas estão em [outputs.tf](./outputs.tf) file.


## Principais arquivos

- cloudfront.tf: configuração do CDN
- waf.tf: contém as regras de WAF para o CDN
- dashboard.tf: Dashboard AWS padrão para cada Distribution. Usa cloudformation.

## Uso

Copiar e colar essa pasta renomeando para `template.projeto`  (ex: `nome` para `nome.projeto`)

Configurar os valores nos arquivos:

- `main.tf` e `custom_ip.tf`: : Substituir os valores template pelo nome do serviço da distribution

- `url.csv`: configurar `FQDN,<IP_ORIGIN>,template`

**Erro conhecido:**

Caso template não seja preenchido, ao executar `terraform plan` ocorrerá o erro:

```
╷
│ Error: "name" isn't a valid log group name (alphanumeric characters, underscores, hyphens, slashes, hash signs and dots are allowed): "aws-waf-logs-template"
│
│   with module.multi["template.projeto"].aws_cloudwatch_log_group.aws_waf_logs,
│   on multiple-resources/waf.tf line 2, in resource "aws_cloudwatch_log_group" "aws_waf_logs":
│    2:   name = format("%s%s","aws-waf-logs-",var.urlname)
│
╵
```

## Como aplicar os templates com Terraform

Depois de configurar o template e fazer os ajustes nos arquivos `cloudfront.tf` e `waf.tf`, siga os passos abaixos em seu ambiente (doc abaixo foi gerada automaticamente).

### Configure environment variables

```shell
export AWS_ACCESS_KEY_ID=<access_key>
export AWS_SECRET_ACCESS_KEY=<secret_access_key>
export AWS_DEFAULT_REGION=<region>
```

### Backend Init
From the corresponding deployment sub-directory run:

```shell
terraform init -backend-config="../../config/backend.tfvars"
```
### Infrastructure Deployment
From the corresponding deployment sub-directory run:

```shell
terraform plan -var-file="../../config/global.tfvars" -var-file="../../config/cloudfront.tfvars" -out <deployment_plan_name>
terraform apply <deployment_plan_name>
```
### Infrastructure Destroy

**Atenção:** alterar valores do url.csv não permitem que o apply funcione. Nesse caso será necessário:

1. Executar o `terraform destroy ` 
2. Ocorrerá erro ao criar os `logs groups` e listas

 ```
 (...)

╷
│ Error: creating WAFv2 IPSet (allow-clients-nome-web-hm): WAFDuplicateItemException: AWS WAF couldn’t perform the operation because some resource in your request is a duplicate of an existing one.
│
│   with module.multi["nome-web-hm.projeto"].aws_wafv2_ip_set.allow-clients-nome-web-hm,
│   on multiple-resources/custom_ip.tf line 2, in resource "aws_wafv2_ip_set" "allow-clients-nome-web-hm":
│    2: resource "aws_wafv2_ip_set" "allow-clients-nome-web-hm" {
│
╵
 
 ``` 


3. Recriar a distribution com `terraform apply`

From the corresponding deployment sub-directory run:

```shell
terraform destroy -var-file="../../config/global.tfvars" -var-file="../../config/cloudfront.tfvars"
```