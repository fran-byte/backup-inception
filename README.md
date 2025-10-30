42 Madrid Proyecto inception

El Inception Project consiste en crear una infraestructura completa con Docker Compose, donde cada servicio (MariaDB, WordPress y NGINX) corre en su propio contenedor basado en Alpine o Debian.
Se exige una estructura ordenada con carpetas para configuraciones, herramientas y secretos, y un Makefile que automatice la construcción y despliegue.
El NGINX actúa como único punto de entrada, sirviendo WordPress por HTTPS (TLSv1.2/1.3) en el puerto 443.
MariaDB gestiona la base de datos con usuarios personalizados, y WordPress (PHP-FPM) se comunica con ella internamente sin exponer puertos.
Los contenedores deben tener reinicio automático, redes personalizadas y volúmenes persistentes para datos y contenido.
Las variables sensibles se almacenan en archivos .env o en la carpeta secrets/, sin incluir contraseñas en los Dockerfiles.
El dominio local se configura en /etc/hosts apuntando a la IP de la máquina virtual.
Como parte opcional, se pueden añadir servicios extra como Redis, FTP o Adminer, siempre que la infraestructura principal funcione correctamente.
