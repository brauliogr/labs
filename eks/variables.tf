variable "cluster_name" {
    default = "eks-cluster-test"
  
}

variable "aws_region" {
    default = "us-east-1"
  
}

variable "k8s_version" {
    default = "1.21"
  
}

variable "nodes_instances_sizes" {
    default = [
        "t3.medium"
    ]
}

variable "auto_scale_options" {
    default = {
        min     = 2
        max     = 8
        desired = 2

    }
  
}

variable "auto_scale_cpu" {

    default = {
        scale_up_threshold = 80  // Se a instancia chegar a 80% escale
        scale_up_period = 60  // periodo de segundos que cluster deve permanecer para escalar
        scale_up_evaluation = 2 // Quantidade de checagem por minuto
        scale_up_cooldown = 300 // Periodo de checagem de um autoscaling 
        scale_up_add = 2  // Quantidade de instancias que será escalada

        scale_down_threshold = 40 // Se o Cluster chegar a 40% 
        scale_down_period = 120 // Periodo que o cluster permanecer ocioso
        scale_down_evaluation = 2 // Quantidade de checagem por minuto
        scale_down_cooldown = 300 // Periodo de checagem de um autoscaling
        scale_down_remove = -1  // Quantidade de instancias a serem removidas

    }
  
}