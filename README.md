# Migraciones de base de datos - Moment

Estas migraciones crean y actualizan la base de datos inicial de la app.

## Requisitos

- SQL Server instalado o accesible.
- SQL Server Management Studio, Azure Data Studio o una herramienta similar.
- Permisos para crear la base de datos `RedSocialDB`.

## Orden de ejecución

Ejecuta los archivos en este orden:

1. `001_crear_tabla_usuarios.sql`
2. `002_registro_verificacion_email_roles.sql`

El orden importa porque la segunda migración agrega columnas y tablas sobre la estructura creada por la primera.

## Cómo ejecutar

1. Abre SQL Server Management Studio o Azure Data Studio.
2. Conéctate a tu instancia de SQL Server.
3. Abre el archivo `001_crear_tabla_usuarios.sql`.
4. Ejecuta el script completo.
5. Abre el archivo `002_registro_verificacion_email_roles.sql`.
6. Ejecuta el script completo.

Los scripts usan `USE RedSocialDB`, por lo que la primera migración crea la base si todavía no existe.

## Qué crea cada migración

`001_crear_tabla_usuarios.sql` crea:

- Base de datos `RedSocialDB`.
- Tabla `Usuarios`.
- Restricciones únicas para `NombreUsuario` y `Email`.

`002_registro_verificacion_email_roles.sql` agrega:

- `NombrePerfil`
- `FechaNacimiento`
- `Rol`
- `EmailVerificado`
- Tabla `VerificacionesEmail` para códigos de verificación.

## Notas importantes

- Los scripts están escritos para SQL Server.
- La app no guarda contraseñas en texto plano; guarda `PasswordHash`.
- Los códigos de verificación tampoco se guardan en texto plano; se guarda `CodigoHash`.
- Si la base ya tiene usuarios, la migración 002 rellena `NombrePerfil` usando `NombreUsuario`.

