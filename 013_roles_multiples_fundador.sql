USE RedSocialDB;
GO

IF OBJECT_ID('dbo.Roles', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.Roles (
        IdRol INT IDENTITY(1,1) NOT NULL CONSTRAINT PK_Roles PRIMARY KEY,
        Nombre NVARCHAR(30) NOT NULL,
        Descripcion NVARCHAR(160) NOT NULL,
        FechaCreacion DATETIME2 NOT NULL CONSTRAINT DF_Roles_FechaCreacion DEFAULT SYSUTCDATETIME(),
        CONSTRAINT UQ_Roles_Nombre UNIQUE (Nombre)
    );
END;
GO

IF OBJECT_ID('dbo.UsuarioRoles', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.UsuarioRoles (
        IdUsuario INT NOT NULL,
        IdRol INT NOT NULL,
        FechaAsignacion DATETIME2 NOT NULL CONSTRAINT DF_UsuarioRoles_FechaAsignacion DEFAULT SYSUTCDATETIME(),
        AsignadoPor INT NULL,
        CONSTRAINT PK_UsuarioRoles PRIMARY KEY (IdUsuario, IdRol),
        CONSTRAINT FK_UsuarioRoles_Usuarios FOREIGN KEY (IdUsuario) REFERENCES dbo.Usuarios(IdUsuario) ON DELETE CASCADE,
        CONSTRAINT FK_UsuarioRoles_Roles FOREIGN KEY (IdRol) REFERENCES dbo.Roles(IdRol) ON DELETE CASCADE,
        CONSTRAINT FK_UsuarioRoles_AsignadoPor FOREIGN KEY (AsignadoPor) REFERENCES dbo.Usuarios(IdUsuario)
    );
END;
GO

IF NOT EXISTS (SELECT 1 FROM dbo.Roles WHERE Nombre = N'usuario')
    INSERT INTO dbo.Roles (Nombre, Descripcion) VALUES (N'usuario', N'Acceso social normal para compartir momentos, seguir perfiles y chatear.');

IF NOT EXISTS (SELECT 1 FROM dbo.Roles WHERE Nombre = N'moderador')
    INSERT INTO dbo.Roles (Nombre, Descripcion) VALUES (N'moderador', N'Acceso administrativo para revisar reportes, spam y acciones de moderacion.');

IF NOT EXISTS (SELECT 1 FROM dbo.Roles WHERE Nombre = N'admin')
    INSERT INTO dbo.Roles (Nombre, Descripcion) VALUES (N'admin', N'Acceso fundador para gestionar roles, permisos y configuracion global.');
GO

INSERT INTO dbo.UsuarioRoles (IdUsuario, IdRol)
SELECT u.IdUsuario, r.IdRol
FROM dbo.Usuarios u
CROSS APPLY (
    SELECT IdRol FROM dbo.Roles WHERE Nombre = COALESCE(NULLIF(LOWER(u.Rol), N''), N'usuario')
    UNION
    SELECT IdRol FROM dbo.Roles WHERE Nombre = N'usuario'
) r
WHERE NOT EXISTS (
    SELECT 1
    FROM dbo.UsuarioRoles ur
    WHERE ur.IdUsuario = u.IdUsuario AND ur.IdRol = r.IdRol
);
GO

DECLARE @FundadorId INT = (
    SELECT TOP 1 IdUsuario
    FROM dbo.Usuarios
    WHERE Email = N'craul0090@gmail.com'
);

IF @FundadorId IS NOT NULL
BEGIN
    UPDATE dbo.Usuarios
    SET Rol = N'admin'
    WHERE IdUsuario = @FundadorId;

    INSERT INTO dbo.UsuarioRoles (IdUsuario, IdRol)
    SELECT @FundadorId, r.IdRol
    FROM dbo.Roles r
    WHERE r.Nombre IN (N'usuario', N'moderador', N'admin')
      AND NOT EXISTS (
        SELECT 1
        FROM dbo.UsuarioRoles ur
        WHERE ur.IdUsuario = @FundadorId AND ur.IdRol = r.IdRol
      );
END;
GO
