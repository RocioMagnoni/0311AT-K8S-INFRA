0311 AT – K8S: Casi como en producción   
 Despliegue de Sitio Web Estático en Kubernetes con Minikube

Este proyecto tiene como finalidad crear un entorno de trabajo local que simule una situación real del mundo laboral, utilizando Kubernetes sobre Minikube. Se despliega un sitio web estático personalizado, cuyo contenido se encuentra en un volumen persistente montado desde el host local. Además, se versiona todo el código utilizando Git y GitHub, tanto para el contenido de la web como para los manifiestos de Kubernetes.

Requisitos  
\- Docker   
\- Minikube (con driver Docker)  
\- kubectl  
\- Git

Estructura del Proyecto  
Consta de dos repositorios:

* static-website : contiene el código fuente del sitio web HTML y CSS  
* [0311AT-K8S-INFRA](https://github.com/RocioMagnoni/0311AT-K8S-INFRA): contiene a manifiestos\_k8s (contiene los manifiestos YAML) y el README

  Pasos para reproducir el entorno


1. Clonar ambos repositorios

   

   git clone https://github.com/tu-usuario/static-website. git .

   git clone https://github.com/tu-usuario/[0311AT-K8S-INFRA](https://github.com/RocioMagnoni/0311AT-K8S-INFRA). git .

   

2. Iniciar el Cluster (se debe cambiar la dirección por la que corresponda en tu caso)

   

    minikube start \--driver=docker \--mount \--mount-string="C:\\Users\\Casa\\0311AT-K8S\\static-website:/mnt/web"

3. Aplicar los manifiestos (Previamente creados)

   

   cd manifiestos\_k8s

   kubectl apply \-f pv-pvc/persistent-volume.yaml

   kubectl apply \-f pv-pvc/persistent-volume-claim.yaml

   kubectl apply \-f deployment/deployment.yaml

   kubectl apply \-f service/ service.yaml

4. Verificacion pods,svc,deployments

   

   kubectl get pods

   kubectl get svc 

   kubectl get deployments

   

5. Acceso al sitio web 

   

   minikube service static-site-service

   

   

   

   

   

   

   

   

 


   

   

   

   

   

   