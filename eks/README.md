# Cluster de EKS com o Terraform utilizando vpc já existente ####

## Requistos

# Ao executar qualquer atualização ou implantação execute os comandos abaixo, para só depois executar o terraform apply

**terraform plan**
**terraform validate**


# *Arquitetura do EKS*

O EKS control plane é onde estarão os componentes **“masters”** do cluster, sendo o controller, scheduler, etcd… E isso é gerenciado pela própria AWS, ou seja, você não terá acesso a essas instâncias. Você vai gerenciar apenas os workers.

Para um ambiente de produção é necessário termos no mínimo 02 Availability Zones para ter uma alta disponibilidade.

Também será necessário 02 Subnets para cada AZ: uma subnet privada e uma pública. Isso porque os pods vão rodar internamente nas subnets privadas, enquanto os Ingress e Load Balancer (que irão exportar a aplicação para o mundo real) serão alocadas nas subnets públicas.

# *Terraform Modules*

O código foi desenvolvido utilizando o Terraform Modules, o Terraform Modules possibilita você reutilizar o código e separar várias pequenas partes, isso é mais fácil para manter o ambiente atualizado.

# *Estrutura do Projeto* <br/>
. <br/>
├── modules <br/>
│   ├── master <br/>
│   │   ├── iam.tf <br/>
│   │   ├── master.tf <br/>
│   │   ├── output.tf <br/>
│   │   ├── security.tf <br/>
│   │   └── variables.tf <br/>
│   ├── network <br/>
│   │   ├── internet-gateway.tf <br/>
│   │   ├── nat-gateway.tf <br/>
│   │   ├── output.tf <br/>
│   │   ├── private.tf <br/>
│   │   ├── public.tf <br/>
│   │   ├── variables.tf <br/>
│   │   └── vpc.tf <br/>
│   └── nodes <br/>
│       ├── auto_scale_cpu.tf <br/>
│       ├── iam.tf <br/>
│       ├── node_group.tf <br/>
│       ├── output.tf <br/>
│       └── variables.tf <br/>
├── modules.tf <br/>
├── output.tf <br/>
├── provider.tf <br/>
├── README.md <br/>
├── terraform.tfstate <br/>
├── terraform.tfstate.backup <br/>
└── variables.tf <br/>

* Cada um dos módulos ficam dentro do diretório modules
* O módulo de network é o responsável pela configuração de rede (Vpc, Subnets, IG, NGW, routes)
* O módulo master contém a configuração do control plane do EKS
* O módulo node contém as configurações dos workers

# *Iniciando a Instalação*

Usamos o comando **terraform init**

*Importando a vpc necessária*

Crie um arquivo chamado vpc.tf na raiz do projeto com as mesmas informações da vpc a ser importada

Execute o comando para importar a vpc
**terraform import aws_vpc.vpc-0489f8cacb52f6a69 vpc-0489f8cacb52f6a69**

Adicione a sintaxe 
**"module": "module.network"**, logo acima da sintaxe **mode**  no arquivo terraform.state. Após essas configurações mova o arquivo **vpc.cf** para o diretorio modules/network

# *Testando o planejamento do Ambiente*

Na raíz do projeto execute o comando **terraform plan** , se tudo ocorreu corretamente, execute o comando **terraform apply --auto-approve**

# *Utilização das Váriaveis*

Foi utilizada uma tag usando uma variável. A tag está usando a função format que vai anexar ao final da string. Por exemplo, se o cluster se chama eks-cluster-test, a vpc se chamará eks-cluster-test-vpc, dessa forma manteremos um padrão que será utilizado em todo código.


# *Subnets Públicas*

* Serão criadas duas subnets uma para casa Availability Zones.
* Será usado o map_public_ip_on_lauch que vai habilitar o uso de IP público em cada instância para essa subnet.
* A tag **"kubenetes.io/cluster"** é uma tag obrigatória no Cluster EKS. É com base nessa tag que o cluster EKS entende que pode usar essa subnet.

*Também será usada uma associação de subnet para uma tabela de rotas, as instâncias nessa subnet respeitarão as rotas do objeto eks_igw_route_table

# *Subnets Privadas*

É basicamente a mesma configuração da subnet pública, porém a subnet será adicionada na rota aws_route_table.eks_nat


# *Internet Gateway*

O Internet Gateway foi importado da mesma forma que a vpc utilizando
**terraform import aws_internet_gateway.igw-08734f3497551acbd igw-08734f3497551acbd** 
Lembrando de adicionar a sintaxe no módulo **"module": "module.network"**, no recurso de internet gateway.
O Internet Gateway é o componente que fará as subnets públicas se comunicarem externamente.

# *Nat Gateway*

Pra as subnets privadas foi utilizado o Nat Gateway, pois o mesmo permite que subnets possam se contectar à internet mas evita que externamente seja criada uma conexão com instâncias adicionadas nessas subredes.

# *Arquivos Outputs*

Os arquivos outputs.tf servem para coletar as saídas do módulos para serem usados no eks.

# *Implantação do módulo Master*

Para ínicio de implantação do EKS é necessário  criarmos uma role que permita a criação de instâncias EC2, as roles foram criadas no arquivo iam.tf do módulo master.
As permissões para o master são *AmazonEKSClusterPolicy* e *AmazonEKSServicePolicy*

Depois de criada essas roles, elas serão atreladas no cluster pelo master.tf e será distribuídas em subnets privadas.

Com a tag kubernetes.io habilitada o ingress irá procurar por uma subnet pública com essa tag, não erá necessário referenciar ela no arquivo do master.

No Master há uma dependência de role, pra caso seja necessário remover o terraform, será garantido que o cluster será removido primeiro.

# *Arquivo Output*

O ID do cluster é enviado para a saída do módulo, para que o grupo de nodes seja atrelado a um cluster.

# *Criação do NodeGroup*

O NodeGroup é configurado pelo módulo nodes referenciando o paramêtro **cluster_name**
Os paramêtros de escala foram definidos como mínimo 2 nodes e no máximo 8, iniciando com 2, essa configuração é feita no arquivo de variáveis do cluster.



# *Executando o Projeto*

No primeiro módulo estamos informando o cluster_name e a region que queremos utilizar (lembra que essas são as variáveis necessárias pro módulo funcionar declaradas no variables.tf)

Segundamente, criamos o cluster EKS informando os IDs das redes privadas que foram criadas pelo módulo acima… Isso cria uma interdependência entre eles e garante que o módulo master depende do módulo network

Por último, criamos o node group apontando para as mesmas subnets privadas do módulo network e também usando o ID do cluster da saída do módulo master. Isto é, o módulo node depende dos outros módulos.

Por fim executaremos os comandos abaixo.

*terraform validate*<br/>
*terraform plan*<br/>
*terraform apply*<br/>