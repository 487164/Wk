# Gestión de colas en RT

## Nomenclatura de colas

- `SPOC` (_Single Point Of Contact_): Cola principal de entrada de tickets.
- `SO  ` (_Service Operation_): Cola secundaria para asignación a grupos de operación.
- `SD  ` (_Service Delivery_): Cola secundaria para ejecución y entrega de servicios.
- `ST  ` (_Service Transition_): Cola para gestionar el ciclo de vida de un servicio.

## Creación de grupos para colas

En RT: `Admin → Groups → Create`.

Como recomendación de buenas prácticas, no se asignan colas a usuarios individuales.
En previsión de crecimiento, es mejor asignar a grupos.

Nomenclatura:
- Entidad-Rol
- Entidad-Área-Rol

## Postfix - Asociación de cuentas de correo a colas

1. Acceder al servidor por SSH:
```sh
[user@jumper.local ~]$ ssh rt-svcs.local
```

2. Revisar la configuración de los alias asignados a cada cola:
```sh
[user@rt-svcs.local ~]$ cat /opt/rt5/etc/aliases
## rebuid with: postalias aliases
...
## SPOCs:
spoc-systems : "| /opt/rt5/bin/rt-mailgate --no-verify-ssl --queue 'SPOC-Systems' --action correspond --url https://soporte.local/"
spoc-systems-comment : "| /opt/rt5/bin/rt-mailgate --no-verify-ssl --queue 'SPOC-Systems' --action comment --url https://soporte.local/"
...
```

3. Si se modifica el fichero, hay que actualizar `aliases.db` y recargar el servicio:
```sh
[user@rt-svcs.local ~]$ sudo vi /opt/rt5/etc/aliases
[user@rt-svcs.local ~]$ sudo postalias /opt/rt5/etc/aliases
[user@rt-svcs.local ~]$ sudo systemctl reload postfix.service
```
