# AzureServicePrincipal-PAL
Script para asignar un código PAL a un service principal

## Optimización de Atribución de Consumo Azure: Impacto de PIM en Partner Admin Link (PAL)
Para asegurar el correcto registro del Partner Admin Link (PAL) y la correspondiente atribución de consumo/influencia en Partner Center, es fundamental entender la interacción técnica entre los roles de RBAC y las políticas de acceso condicional.

## Desafío Técnico: Azure PIM y PAL
El mecanismo de PAL opera mediante el rastreo de asignaciones de roles activos. Bajo un entorno de Azure Privileged Identity Management (PIM), los roles suelen configurarse como "Elegibles" (Eligible).

**Impacto**: Microsoft no reconoce la influencia de un partner si el rol asociado al Partner ID se encuentra en estado "Elegible" pero no activado.

**Consecuencia**: La falta de una activación permanente deriva en la pérdida de visibilidad en las métricas de DPOR/PAL, afectando directamente los incentivos y el reconocimiento de competencia en el Partner Center.

**Solución Recomendada**: Implementación de Service Principal (SPN)
Para garantizar una telemetría de consumo ininterrumpida y mitigar las limitaciones de PIM en cuentas de usuario, se recomienda la siguiente arquitectura de acceso:
1. Uso de Service Principal: Desplegar un Service Principal dedicado (en lugar de una cuenta de usuario) para la vinculación del PAL.
2. Asignación de Permisos Permanentes: Configurar el SPN con el rol de Contributor de manera permanente (no elegible).
3. Alcance del Rol (Scope):
- Opción A (Recomendada): Asignar permisos a nivel de Management Group de nivel superior (Root Management Group -1) para heredar la autoridad en toda la estructura.
- Opción B: En caso de restricciones de gobernanza, aplicar el rol de Contributor en cada Management Group o suscripción individual que genere consumo activo.

Aquí tienes el procedimiento técnico detallado para realizar la vinculación del Service Principal (SPN) al Partner ID (MPN) de forma permanente, asegurando así la atribución de consumo sin las interrupciones que causa PIM.

## Guía Técnica: Vinculación de Service Principal para PAL
Para automatizar y asegurar el registro de influencia, seguiremos estos pasos utilizando Azure CLI. Este método es más eficiente que el portal para gestionar identidades de servicio.

### 1. Creación y Configuración del Service Principal
Primero, asegúrate de que el Service Principal tenga el rol de Contributor (Colaborador) con un alcance lo suficientemente amplio (idealmente a nivel de Management Group).

``` bash
# Creación del Service Principal y asignación de rol a nivel de suscripción
az ad sp create-for-rbac --name "Partner-PAL-ServicePrincipal" --role Contributor --scopes /subscriptions/{subscription-id}
```

### 2. Autenticación como el Service Principal
Para que el PAL se registre correctamente, la vinculación debe ejecutarse bajo el contexto de seguridad del propio Service Principal, no con tus credenciales de usuario.

``` bash
# Inicio de sesión con el SPN
az login --service-principal -u <appId> -p <password> --tenant <tenantId>
```
### 3. Registro del Partner ID (PAL)
Una vez autenticado como el SPN, ejecuta el comando de gestión de partners para asociar vuestro PartnerID (anteriormente conocido como MPN ID).

``` bash
# Vinculación del Partner ID
az managementpartner create --partner-id <Tu_Partner_ID>
```

### Resumen de Beneficios
**Atribución Ininterrumpida**: Al ser un SPN, el rol es "Active" 24/7, evitando el estado "Eligible" de PIM que bloquea las métricas.
**Escalabilidad**: Al aplicarlo a nivel de Management Group, cualquier suscripción nueva creada bajo esa jerarquía heredará el permiso y el registro de influencia automáticamente.
**Auditoría**: Separa las acciones del partner de las acciones de los usuarios nominales, facilitando el cumplimiento (compliance) interno.
