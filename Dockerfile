# Para poder visualizar el index.html utilizamos una imagen de nginx que la hostea.
FROM nginx:1.22-alpine

# El archivo que hemos creado index.html tiene que ser copiado dentro de la imagen nginx
# como se menciona mas arriba.
COPY index.html /usr/share/nginx/html/index.html

# Exponemos el puerto
EXPOSE 80 