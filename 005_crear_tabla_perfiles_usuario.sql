-- 005 - Separar datos de perfil de los datos de autenticacion
-- Ejecutar despues de 004_vista_disponibilidad_emails.sql.

USE RedSocialDB;
GO

IF OBJECT_ID('dbo.PerfilesUsuario', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.PerfilesUsuario (
        IdPerfil           INT IDENTITY(1,1) CONSTRAINT PK_PerfilesUsuario PRIMARY KEY,
        IdUsuario          INT          NOT NULL,
        NombrePerfil       NVARCHAR(60) NOT NULL,
        FechaNacimiento    DATE         NULL,
        Biografia          NVARCHAR(160) NULL,
        FotoPerfilUrl      NVARCHAR(500) NULL,
        FechaCreacion      DATETIME2    NOT NULL CONSTRAINT DF_PerfilesUsuario_FechaCreacion DEFAULT SYSUTCDATETIME(),
        FechaActualizacion DATETIME2    NULL,
        CONSTRAINT FK_PerfilesUsuario_Usuarios FOREIGN KEY (IdUsuario)
            REFERENCES dbo.Usuarios (IdUsuario)
            ON DELETE CASCADE,
        CONSTRAINT UQ_PerfilesUsuario_IdUsuario UNIQUE (IdUsuario)
    );

    CREATE INDEX IX_PerfilesUsuario_NombrePerfil ON dbo.PerfilesUsuario (NombrePerfil);
END
GO

INSERT INTO dbo.PerfilesUsuario (IdUsuario, NombrePerfil, FechaNacimiento)
SELECT
    u.IdUsuario,
    u.NombrePerfil,
    u.FechaNacimiento
FROM dbo.Usuarios u
WHERE NOT EXISTS (
    SELECT 1
    FROM dbo.PerfilesUsuario p
    WHERE p.IdUsuario = u.IdUsuario
);
GO
