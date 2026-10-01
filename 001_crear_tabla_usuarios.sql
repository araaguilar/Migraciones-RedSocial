-- 001 - Crear tabla base de usuarios
-- Ejecutar en SQL Server sobre la base RedSocialDB.

IF DB_ID('RedSocialDB') IS NULL
    CREATE DATABASE RedSocialDB;
GO

USE RedSocialDB;
GO

IF OBJECT_ID('dbo.Usuarios', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.Usuarios (
        IdUsuario        INT IDENTITY(1,1) CONSTRAINT PK_Usuarios PRIMARY KEY,
        NombreUsuario    NVARCHAR(30)  NOT NULL,
        Email            NVARCHAR(100) NOT NULL,
        PasswordHash     VARCHAR(60)   NOT NULL,
        Activo           BIT           NOT NULL CONSTRAINT DF_Usuarios_Activo DEFAULT 1,
        FechaRegistro    DATETIME2     NOT NULL CONSTRAINT DF_Usuarios_FechaRegistro DEFAULT SYSUTCDATETIME(),
        UltimoLogin      DATETIME2     NULL,
        CONSTRAINT UQ_Usuarios_NombreUsuario UNIQUE (NombreUsuario),
        CONSTRAINT UQ_Usuarios_Email UNIQUE (Email)
    );
END
GO
