# Projeto criado para o desafio 16 da Oficina de Projetos da Cloud Treinamentos\*\*

Este projeto permite criar a infraestrutura na AWS para execução de carga de trabalho baseada em EC2 e CloudFront.

A proposta é criar todos os recursos necessários, como VPC, Subnet, Route Tables, EC2, RDS etc, para rodar o projeto.

O sistema a ser executado neste exemplo é uma aplicação em PHP, que é um sistema para testes.

Toda a infraestrutura é criada via pipeline em Terraform.

Para usar este repositório consulte a seção [**Terraform**](#terraform) abaixo neste texto.

## Terraform

Terraform é tecnologia para uso de infraestrutura como código (IaC), assim como CloudFormation da AWS.

Porém com Terraform é possível definir infraestrutura para outras clouds como GCP, Azure, entre outras.

## Instalação

Para utilizar é preciso baixar o arquivo do binário compilado para o sistema que você usa. Acesse <https://www.terraform.io/downloads>

## Iniciaizando o repositório

O primeiro passo é baixar o repositório, seja via git ou fazendo o download do zip.

Se baixar o zip, descompacte ele e acesse a pasta via terminal.

É preciso inicializar o Terraform na raiz deste projeto executando

```sh
terraform init
```

## Definindo credenciais

O arquivo de definição do Terraform é o _main.tf_.

É nele que especificamos como nossa infraestrutura será, jutamente com os outros arquivos _.tf_.

É importante observar que no bloco do `provider "aws"` é onde definimos que vamos usar Terraform com AWS e em qual região será criada a infraestrutura.

```tf
provider "aws" {
  region = "us-east-1"
  profile = "oficina-de-projetos"
}
```

Como Terraform cria toda a infra automaticamente na AWS, é preciso dar permissão para isso por meio de credenciais.

Apesar de ser possível especificar as chaves no próprio provider, esta abordagem não é indicada. Principalmente por este código estar em um repositório git, pois quem tiver acesso ao repositório saberá qual são as credenciais.

Uma opção melhor é usar um _profile_ da AWS configurado localmente.

Podemos criar, por exemplo, o profile chamado _projeto_. Para criar um profile execute o comando abaixo usando o AWS CLI e preencha os parâmetros solicitados.

```sh
aws configure --profile projeto
```

### Recomendação

Asista este vídeo: [Nunca use credenciais da AWS no seu código!](https://www.youtube.com/watch?v=8yGaKo4xkxc)

## Variáveis - Configurações adicionais

Além da configuração do profile será preciso definir algumas variáveis.

Para evitar expor dados sensíveis no git, como senha do banco de dados, será preciso copiar o arquivo `terraform.tfvars.exemplo` para `terraform.tfvars`.

No arquivo `terraform.tfvars` redefina os valores das variáveis. Algumas são opcionais, como os dados necessários para o RDS.

Todas as variáveis possíveis para este arquivo podem ser vistas no arquivo `variables.tf`. Apenas algumas delas foram utilizadas no exemplo.

## Aplicando a infra definida

O Terraform provê alguns comandos básicos para validar, planejar, aplicar e destruir a infraestrutura.

Ao começar a aplicar a infraestrutura, o Terraform cria o arquivo `terraform.tfstate`, que deve ser preservado e não deve ser alterado manualmente.

Por meio deste arquivo o Terraform sabe o estado atual da infraestrutura e é capaz de adicionar, alterar ou remover recursos.

Neste repositório estamos versionando este arquivo em um bucket S3 que deverá ser criado previamente. Neste caso, foi criado em um bucket nomeado `terraform-tfstate-php-jversolato`. Lembrando que o nome do bucket deve ser único, portanto, não se deve utilizar o mesmo nome de bucket.

Mais um ponto importante: **NÃO ALTERE A INFRAESTRUTURA MANUALMENTE PELA CONSOLE**. Se você fizer isso o Terraform poderá se perder pois se você tentar usá-lo novamente no mesmo projeto.

### Validando o código de terraform

```sh
terraform validate
```

### Verificando o que será criado, removido ou alterado

```sh
terraform plan -out plan.out
```

### Aplicando a infraestrutura definida

```sh
terraform apply plan.out
```

### Destruindo toda sua infraestrutura

\*CUIDADO!
Após a execução dos comandos abaixo você apagará tudo que foi criado através do seu arquivo Terraform (banco de dados, EC2, EBS etc) na AWS.

```sh
terraform destroy
```

ou, para confirmar automáticamente.

```sh
terraform destroy -auto-approve
```

## Pós criação da infraestrutura

Após executar o `terraform apply`, é apresentado no terminal quantos recursos formam adicionados, alterados ou destruídos na sua infra.

No nosso código adicionamos mais algumas informações de saída (outputs) necessárias para acessarmos os recursos criados, como o banco de dados. Observe abaixo.

O acesso à aplicação será pelo endereço apresentado no `projeto-dns`, que também pode ser utilizado para acessar a instância.

O endereço _host_ para o banco de dados RDS é apresentado em `projeto-rds-addr`.

```text
Apply complete! Resources: 23 added, 0 changed, 0 destroyed.

Outputs:

projeto-dns = "ec2-44-201-145-193.compute-1.amazonaws.com"
projeto-id = "i-0c3289412a3104db2"
projeto-ip = "44.201.145.193"
projeto-rds-addr = "projeto-rds.cmfcq1p7msvt.us-east-1.rds.amazonaws.com"
projeto-rds-endpoint = "projeto-rds.cmfcq1p7msvt.us-east-1.rds.amazonaws.com:5432"
```

---

## Considerações finais

Este é um projeto para experimentações e estudo do Terraform.

## Referências

1. [Terraform](https://www.terraform.io/)
2. [How to setup a basic VPC with EC2 and RDS using Terraform](https://dev.to/rolfstreefkerk/how-to-setup-a-basic-vpc-with-ec2-and-rds-using-terraform-3jij)
