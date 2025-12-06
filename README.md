# Sistema de Telemetría Audi Cloud 

Proyecto de Ingeniería DevOps para el monitoreo vehicular en tiempo real.

## Tecnologías
* **AWS (EC2 & Security Groups):** Infraestructura como Código con Terraform.
* **Docker:** Containerización de servicios.
* **n8n:** Orquestación de flujos de datos y alertas.
* **MongoDB:** Base de datos NoSQL para persistencia de logs.
* **SMTP:** Sistema de notificaciones críticas vía correo electrónico.

## Arquitectura
1.  El vehículo envía datos JSON vía Webhook.
2.  n8n procesa la información y evalúa riesgos.
3.  Si la temperatura > 100°C, dispara una alerta HTML por correo.
4.  Todos los eventos se registran automáticamente en MongoDB.