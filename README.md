**0311 AT – K8S: Casi como en producción**   
 **Despliegue de Sitio Web Estático en Kubernetes con Minikube**

Este proyecto tiene como finalidad crear un entorno de trabajo local que simule una situación real del mundo laboral, utilizando Kubernetes sobre Minikube. Se despliega un sitio web estático personalizado, cuyo contenido se encuentra en un volumen persistente montado desde el host local. Además, se versiona todo el código utilizando Git y GitHub, tanto para el contenido de la web como para los manifiestos de Kubernetes.

Requisitos  
\- Docker   
\- Minikube (con driver Docker)  
\- kubectl  
\- Git

**Estructura del Proyecto**

Este proyecto consta de dos repositorios:

* **static-website**:(https://github.com/RocioMagnoni/static-website): contiene el código fuente del sitio web (HTML y CSS).  
* **0311AT-K8S-INFRA**:(https://github.com/RocioMagnoni/0311AT-K8S-INFRA): contiene los manifiestos Kubernetes dentro del directorio \`manifiestos\_k8s\`.


El repositorio del sitio web parte de un fork del siguiente proyecto base:  
 [https://github.com/ewojjowe/static-website](https://github.com/ewojjowe/static-website) 

Este README fue pensado para reproducirse de forma manual en un entorno Windows. Si estás usando Linux o Mac, deberás adaptar las rutas del volumen montado.  
En el caso de reproducir el entorno de forma automática está pensado para ejecutarse en un entorno Linux,por lo que si te encuentras utilizando Windows deberás adaptar las rutas de volumen de montado.

**Pasos para reproducir el entorno de forma automática en Linux**

1. Dar permisos de ejecución al script:(Asegurarse estar en el directorio donde se encuentra el archivo despliegue.sh)  
     
   chmod \+x despliegue.sh  
     
2. Ejecutar el script:(debes asegurarte de tener corriendo docker)  
     
   ./despliegue.sh  
   

Esto creará el entorno local en \~/0311AT-K8S, clonará los repositorios, iniciará Minikube con el volumen montado, y aplicará los manifiestos automáticamente.Al finalizar el script se mostrará la URL que deberás utilizar para acceder a tu pagina web estatica

**Pasos para reproducir el entorno de forma manual**

1. Crear un directorio de trabajo local, por ejemplo:  
     
   C:\\Users\\tu-usuario\\0311AT-K8S  
     
2. Posicionarse en la carpeta desde PowerShell o Git Bash:

   

   cd C:\\Users\\TU\_USUARIO\\0311AT-K8S

   

3. Clonar los dos repositorios:

   

   git clone https://github.com/RocioMagnoni/static-website.git

   git clone [https://github.com/RocioMagnoni/0311AT-K8S-INFRA.git](https://github.com/RocioMagnoni/0311AT-K8S-INFRA.git)

   

   Esto creará dos carpetas dentro de tu directorio de trabajo (static-website y 0311AT-K8S-INFRA), que contendrán todo lo necesario para reproducir el entorno.

   

4. Iniciar el cluster Minikube montando el contenido del sitio:

   

    minikube start \--driver=docker \--mount \--mount-string="C:\\Users\\tu-usuario\\0311AT-K8S\\static-website:/mnt/web"

5. Aplicar los manifiestos YAML desde la carpeta manifiestos\_k8s:

   

   cd 0311AT-K8S-INFRA\\manifiestos\_k8s

   

   kubectl apply \-f pv-pvc/persistent-volume.yaml

   kubectl apply \-f pv-pvc/persistent-volume-claim.yaml

   kubectl apply \-f deployment/deployment.yaml

   kubectl apply \-f service/service.yaml

 


6. Verificar que el despliegue esté funcionando:

   

   kubectl get pods

   kubectl get svc 

   kubectl get deployments

   

7. Acceder al sitio web desde el navegador:

   

   minikube service static-site-service

   

   

   

   

   

   

   

   

 


   

   

   

   

   

   