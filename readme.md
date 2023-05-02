# Punto 3 del challenge

Para poder realizar el punto tres del challenge lo primero que realizamos es crear un archivo index.html con un esquema default/generico.

Luego es sumamente importante crear un Dockerfile en el cual podamos indicar que vamos a utilizar una imagen de ningx para
la cual nos va a permitir poder "hostear" nuestro index.html , le indicamos tambien que debe ser copiado dentro de nuestro nginx y donde va a ser expuesto el puerto.

Para poder crear la imagen nos situamos en nuestra terminal donde se encuentra el Dockerfile e ingresamos el comando
"sudo docker build -t nginximagen . para poder crear la imagen que estamos buscando.

Para implementar el CI/CD vamos a utilizar Github Actions que permite automatizar pipelines de build , test y deploy 

En esta carpeta se encuentra la resolución del Test 3.

El Dockerfile genera una imagen de nginx que contiene el index.html que va a hostear.


Vamos a utilizar github actions, para ello necesitamos tener una cuenta en dockerhub como asi tambien en github, primero creamos un repositorio publico en dockerhub para que podamos guardar nuestras imagenes, generamos un accesskey ID y un accesskey PASSWORD. Luego entramos a Github y creamos un repositorio publico, dentro del mismo en "settings" vamos a agregar en "secrets" nuestros accesskey ID y PASSWORD de dockerhub para que ambas esten vinculadas. Subimos a nuestro repositorio publico de Github el archivo "index.html" y "dockerfile". Creamos una carpeta en nuestro escritorio el cual luego a traves de la terminal y a traves de "sudo git clone" vamos a clonar en nuetra carpeta nuestro repositorio de Github para poder trabajar alli desde la terminal de nuestra pc. Primero y principal debemos a traves del comando "sudo mkdir -p .github/workflows" creamos la carpeta.. luego hacemos un "sudo vim .github/workflows/push.yml" para crear nuestro archivo .yml que va a contener el CI. El formato utilizado es el siguiente:


on:
  push:
    branches:
      - 'main'

jobs:
  docker-build:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout
        uses: actions/checkout@v3
 # instala QEMU y lo configura
      - name: Set up QEMU
        uses: docker/setup-qemu-action@v2
 # aca estamos usando una action en este caso de login
 # a dockerhub pasandole los parametros  
      - name: Login to DockerHub
        uses: docker/login-action@v2
        with:
            username: ${{ secrets.DOCKERHUB_USERNAME }}
            password: ${{ secrets.DOCKERHUB_PASSWORD }}
 # construir la imagen y pushearla
      - name: Build and push
        uses: docker/build-push-action@v3
        with:
          file: Dockerfile
          context: .
          push: true
          tags: ignaciovocos/punto3:${{ github.sha }}
          
Luego cerramos el editor con un :wq

volvemos a la terminal e ingresamos un "sudo git add ." seguido de un " sudo git commit -m "primer commit" para luego realizar un "sudo git push origin main". Esto va a hacer que podamos ver en "actions" de githun el deploy y que al ingresar en nuestro repositorio de dockerhub podamos ver las imagenes con los "tags".

// deploy cluster de kubernetes , buscamos en el market de github en la parte de "actions"  "Kubectl" agregando en nuestro yml. 

- name: Deploy to cluster
        uses: steebchen/kubectl@master
        env:
          KUBE_CONFIG_DATA: ${{ secrets.KUBE_CONFIG_DATA }}
        with:
          args: set image --record deployment/my-app prueba-gha=:ignaciovocos/punto3:${{ github.sha }}
      - name: verify deployment
        uses: steebchen/kubectl@master
        env:
          KUBE_CONFIG_DATA: ${{ secrets.KUBE_CONFIG_DATA }}
          KUBECTL_VERSION: "1.20"
        with:
          args: '"rollout status deployment/my-app"'

* Agregamos en nuestro repositorio de github en la parte de secrets KUBE_CONFIG_DATA para luego poder hacer un sudo git push origin main.



