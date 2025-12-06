# Sistema de Telemetria Audi Cloud

Proyecto de Ingenieria DevOps para el monitoreo vehicular en tiempo real.

## Tecnologias
* **AWS (EC2 & Security Groups):** Infraestructura como Codigo con Terraform.
* **Docker:** Containerizacion de servicios.
* **n8n:** Orquestacion de flujos de datos y alertas.
* **MongoDB:** Base de datos NoSQL para persistencia de logs.
* **SMTP:** Sistema de notificaciones criticas via correo electronico.

## Arquitectura
1.  El vehiculo envia datos JSON via Webhook.
2.  n8n procesa la informacion y evalua riesgos.
3.  Si la temperatura > 100°C, dispara una alerta HTML por correo.
4.  Todos los eventos se registran automaticamente en MongoDB.

## Diagrama de Flujo (n8n)
*Este es el cerebro del sistema, orquestando la logica de negocio.*
<img width="1336" height="414" alt="image" src="https://github.com/user-attachments/assets/db6af482-4ebb-44f9-b738-8bae832bf7c3" />

## Evidencia de Funcionamiento

### 1. Registro en Base de Datos
Cada evento recibido se guarda estructuradamente en MongoDB para analisis historico.

<img width="1140" height="111" alt="image" src="https://github.com/user-attachments/assets/3f72ddde-c05b-427c-bdee-0be76885a0d0" />

### 2. Alerta de Temperatura Critica
Cuando el vehiculo supera los parametros seguros, el sistema dispara una notificacion inmediata.

<img width="487" height="746" alt="image" src="https://github.com/user-attachments/assets/89bc4df8-d0b0-4b6a-b626-287433f49eb7" />

## Como Desplegar Este Proyecto

Este repositorio contiene todo lo necesario para levantar la infraestructura en minutos usando Terraform.

**Requisitos:**
* Cuenta de AWS y credenciales configuradas (`aws configure`).
* Terraform instalado.

**Pasos:**
1.  **Clonar el repositorio:**
    ```bash
    git clone [https://github.com/DHZ1LL10/cloud-devops.git](https://github.com/DHZ1LL10/cloud-devops.git)
    cd cloud-devops
    ```
2.  **Inicializar Terraform:**
    ```bash
    terraform init
    ```
3.  **Revisar el plan y desplegar:**
    ```bash
    terraform apply
    ```
    *(Escribe `yes` cuando se te solicite).*

Al finalizar, Terraform te entregara la IP publica del servidor y el comando SSH para conectarte.

## Como Probar el Sistema (Simulacion)

Una vez que el servidor este corriendo y n8n configurado, puedes simular los sensores del vehiculo enviando peticiones HTTP desde tu terminal.

**Reemplaza `TU_IP_PUBLICA` con la IP que te entrego Terraform.**

### Escenario 1: Funcionamiento Normal
*Este comando registra los datos en MongoDB pero NO dispara alertas.*

bash
`curl -X POST -H "Content-Type: application/json" \
-d "{ \"temperatura\": 90, \"rpm\": 3500, \"estado\": \"estable\" }" \
http://TU_IP_PUBLICA:5678/webhook-test/telemetria`

### Escenario 2: Falla Critica (Alerta)
Este comando supera el umbral de 100°C, registrando el evento y enviando un correo de emergencia.

bash
`curl -X POST -H "Content-Type: application/json" \
-d "{ \"temperatura\": 115, \"rpm\": 6500, \"estado\": \"SOBRECALENTAMIENTO\" }" \
http://TU_IP_PUBLICA:5678/webhook-test/telemetria`

*Autor:* Diego Herrera Zilli | *Contacto:* zillidiego8@gmail.com
