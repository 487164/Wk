---
title: Legal Request
description: 
published: true
date: 2024-04-01T17:50:45.487Z
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

```bash
ticketID="82971"
userID="8a3ce084-8c92-49e9-9199-ea7336b202d8"
day="2023-04-11"
./legal-request-gestiona-ee/filter_by_day.sh "$day" "$ticketID.tar.gz" \
  | zgrep -a > $ticketID-$userID.$day.day_filtered.user_filtered       \
  | ./legal-request-gestiona-ee/convert_date.py                        \
  > /full_path/$ticketID-$userID.YYY-MM-DD.day_filtered.user_filtered.date_converted.json
```

## 4. Entrega del resultado
Se envía el Excel adjunto por correo desde soc@espublico.com a cumplimientonormativo@espublico.com, con asunto "Auditoría por requerimiento #" + número del ticket.