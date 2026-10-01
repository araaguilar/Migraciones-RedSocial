-- 002 - Registro con perfil, fecha de nacimiento, rol y verificacion de correo
-- Ejecutar despues de 001_crear_tabla_usuarios.sql.

USE RedSocialDB;
GO

IF COL_LENGTH('dbo.Usuarios', 'NombrePerfil') IS NULL
BEGIN
    ALTER TABLE dbo.Usuarios
    ADD NombrePerfil NVARCHAR(60) NULL;
END
GO

UPDATE dbo.Usuarios
SET NombrePerfil = NombreUsuario
WHERE NombrePerfil IS NULL;
GO

IF COL_LENGTH('dbo.Usuarios', 'NombrePerfil') IS NOT NULL
BEGIN
    ALTER TABLE dbo.Usuarios
    ALTER COLUMN NombrePerfil NVARCHAR(60) NOT NULL;
END
GO

IF COL_LENGTH('dbo.Usuarios', 'FechaNacimiento') IS NULL
BEGIN
    ALTER TABLE dbo.Usuarios
    ADD FechaNacimiento DATE NULL;
END
GO

IF COL_LENGTH('dbo.Usuarios', 'Rol') IS NULL
BEGIN
    ALTER TABLE dbo.Usuarios
    ADD Rol NVARCHAR(20) NOT NULL CONSTRAINT DF_Usuarios_Rol DEFAULT 'usuario';
END
GO

IF COL_LENGTH('dbo.Usuarios', 'EmailVerificado') IS NULL
BEGIN
    ALTER TABLE dbo.Usuarios
    ADD EmailVerificado BIT NOT NULL CONSTRAINT DF_Usuarios_EmailVerificado DEFAULT 0;
END
GO

IF OBJECT_ID('dbo.VerificacionesEmail', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.VerificacionesEmail (
        IdVerificacionEmail INT IDENTITY(1,1) CONSTRAINT PK_VerificacionesEmail PRIMARY KEY,
        Email               NVARCHAR(100) NOT NULL,
        CodigoHash          VARCHAR(64)   NOT NULL,
        TokenVerificacion   VARCHAR(64)   NOT NULL,
        ExpiraEn            DATETIME2     NOT NULL,
        IntentosFallidos    INT           NOT NULL CONSTRAINT DF_VerificacionesEmail_IntentosFallidos DEFAULT 0,
        FechaCreacion       DATETIME2     NOT NULL CONSTRAINT DF_VerificacionesEmail_FechaCreacion DEFAULT SYSUTCDATETIME(),
        FechaVerificacion   DATETIME2     NULL,
        Usado               BIT           NOT NULL CONSTRAINT DF_VerificacionesEmail_Usado DEFAULT 0,
        CONSTRAINT UQ_VerificacionesEmail_TokenVerificacion UNIQUE (TokenVerificacion)
    );

    CREATE INDEX IX_VerificacionesEmail_Email ON dbo.VerificacionesEmail (Email);
END
GO
