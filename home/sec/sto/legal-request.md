---
title: Legal Request
description: 
published: true
date: 2024-04-01T19:00:42.345Z
tags: 
editor: markdown
dateCreated: 2024-04-01T17:50:45.487Z
---

# Procedimiento
## 1. Petición
El equipo de [Cumplimiento Normativo](mailto:cumplimientonormativo@espublico.com) (autorizado por su responsable) abre un ticket detallando los datos. Por ejemplo:

> Necesitamos conocer la auditoría completa de las operaciones sobre 2 usuarios en una entidad Gestiona (cada uno en una fecha concreta). Los datos son:
>
> - Pool 1
> - organizationId -> 53a5a409-7549-4fb0-9754-7b9517b75488
> - Usuarios / fecha:
>   - User_id -> 8a3ce084-8c92-49e9-9199-ea7336b202d8
>   - Fecha -> 11/04/2023
> .
>   - User_id -> 6116df73-d138-4716-bae0-f6a48e886994
>   - Fecha -> 18/04/2023

El número del ticket (`$ticketID`) se usa como identificador del caso (ej.: 82971).

## 2. Extracción de la auditoría
El equipo de "esPublico Sistemas - Operaciones" obtiene del Pool especificado los logs de auditoría de Gestiona EE y los deja en el servidor "zgz-soar" directamente[^*] como un fichero `.tar.gz` (ej.: 82971.tar.gz).

 [^*]: _ CONFIRMAR _

## 3. Filtrado y procesado

Desde la máquina "zgz-soar", se utilizan los scripts `filter_by_day.sh`, `convert_data.py` y `zgrep` para filtrar sobre el tar.gz en bruto.
Se puede ejecutar por separado cada uno de los tres pasos o combinarlos según se necesite. Por ejempo, si tenemos una fecha y un usuario, los scripts podrían encadenarse de la siguiente forma:
```bash
ticketID="82971"
userID="8a3ce084-8c92-49e9-9199-ea7336b202d8"
day="2023-04-11"
# Si en el ticket no se ha especificado día, directamente "zgrep -a $userID $ticketID.tar.gz"
./legal-request-gestiona-ee/filter_by_day.sh "$day" "$ticketID.tar.gz" \
  | zgrep -a $userID                                                   \
  | ./legal-request-gestiona-ee/convert_date.py                        \
  > /full_path/$ticketID-$userID.$day.day_filtered.user_filtered.date_converted.json
```

El JSON resultante se debe descargar en el equipo del analista para que haga la conversión final en Excel.
Partiendo de [`sample-TicketID-UserID.YYYY-MM-DD.xlsx`](/sec/sto/legal-request/sample-TicketID-UserID.YYY-MM-DD.xlsx)[^1], solo es necesario **modificar el paso "Origen"** de la consulta "Convertir AuditLogs GestionaEE" que incluye este archivo.

[^1]: Este Excel es una plantilla. Hace la consulta contra [`sample-TicketID-UserID.YYYY-MM-DD.day_filtered.user_filtered.date_converted.json`](/sec/sto/legal-request/sample-TicketID-UserID.YYYY-MM-DD.day_filtered.user_filtered.date_converted.json), para tener datos de ejemplo.

Para ello, hay que abrir el Editor de Power Query en el siguiente menú:
- Datos > Consultas y conexiones, click derecho sobre la consulta "Convertir AuditLogs GestionaEE" y click sobre "Editar".
- Doble click sobre el paso "Origen" (o click derecho y "Editar Configuración") y seleccionar el JSON desde el menú Examinar de "Ruta de acceso de archivo".

Si el Editor de Power Query muestra el resultado correctamente, tan solo queda pulsar "Cerrar y cargar" para completar el volcado de los registros de auditoría en una hoja:

![screenshot_power_query.png](/sec/sto/legal-request/screenshot_power_query.png)

Una vez se hayan cargado todos los datos en una tabla, desde la ventana principal de Excel se debe  **"Guardar como"** siguiendo el siguiente formato para el nombre de fichero:
```
$ticketID-$userID.xlsx
```

## 4. Entrega del resultado
Se envía el Excel adjunto por correo desde soc@espublico.com a cumplimientonormativo@espublico.com, con asunto "Auditoría por requerimiento #" + número del ticket.