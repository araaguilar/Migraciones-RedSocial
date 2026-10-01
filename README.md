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
3. `003_vista_disponibilidad_usuarios.sql`
4. `004_vista_disponibilidad_emails.sql`
5. `005_crear_tabla_perfiles_usuario.sql`
6. `006_crear_tabla_recuperaciones_password.sql`
7. `007_social_basico_perfiles_seguidores.sql`

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

`003_vista_disponibilidad_usuarios.sql` agrega:

- Vista `vw_UsuariosLookup`.
- Índice único sobre `NombreUsuario` para consultas rápidas de disponibilidad.

`004_vista_disponibilidad_emails.sql` agrega:

- Vista `vw_EmailsLookup`.
- Índice único sobre `Email` para consultas rápidas de disponibilidad.

`005_crear_tabla_perfiles_usuario.sql` agrega:

- Tabla `PerfilesUsuario`.
- Relación 1 a 1 con `Usuarios`.
- Migración inicial de `NombrePerfil` y `FechaNacimiento` desde usuarios existentes.

`006_crear_tabla_recuperaciones_password.sql` agrega:

- Tabla `RecuperacionesPassword`.
- Códigos hasheados para recuperación de contraseña.
- Token temporal de recuperación con expiración e intentos fallidos.

`007_social_basico_perfiles_seguidores.sql` agrega:

- `SobreMi` de máximo 300 caracteres.
- `TotalMeEncanta` en perfiles.
- Tabla `Seguidores` con relación única seguidor/seguido.

## Notas importantes

- Los scripts están escritos para SQL Server.
- La app no guarda contraseñas en texto plano; guarda `PasswordHash`.
- Los códigos de verificación tampoco se guardan en texto plano; se guarda `CodigoHash`.
- Si la base ya tiene usuarios, la migración 002 rellena `NombrePerfil` usando `NombreUsuario`.

## Sincronización automática local

Este repo incluye un watcher opcional para Windows. Sirve para que, en esta PC, cada cambio en archivos `.sql` o en este `README.md` genere un commit automático y haga `git push`.

Instalar:

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\install-watcher.ps1
```

Desinstalar:

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\uninstall-watcher.ps1
```

El instalador crea un acceso de arranque en la carpeta de Inicio de Windows del usuario actual. No requiere permisos de administrador.
