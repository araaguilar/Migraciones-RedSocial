-- 007 - Base social: seguidores, sobre mi y contador de me encanta
-- Ejecutar despues de 006_crear_tabla_recuperaciones_password.sql.

USE RedSocialDB;
GO

IF COL_LENGTH('dbo.PerfilesUsuario', 'SobreMi') IS NULL
BEGIN
    ALTER TABLE dbo.PerfilesUsuario
    ADD SobreMi NVARCHAR(300) NULL;
END
GO

IF COL_LENGTH('dbo.PerfilesUsuario', 'TotalMeEncanta') IS NULL
BEGIN
    ALTER TABLE dbo.PerfilesUsuario
    ADD TotalMeEncanta INT NOT NULL CONSTRAINT DF_PerfilesUsuario_TotalMeEncanta DEFAULT 0;
END
GO

IF OBJECT_ID('dbo.Seguidores', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.Seguidores (
        IdSeguidorRelacion INT IDENTITY(1,1) CONSTRAINT PK_Seguidores PRIMARY KEY,
        IdSeguidor         INT       NOT NULL,
        IdSeguido          INT       NOT NULL,
        FechaSeguimiento   DATETIME2 NOT NULL CONSTRAINT DF_Seguidores_FechaSeguimiento DEFAULT SYSUTCDATETIME(),
        CONSTRAINT FK_Seguidores_Seguidor FOREIGN KEY (IdSeguidor)
            REFERENCES dbo.Usuarios (IdUsuario),
        CONSTRAINT FK_Seguidores_Seguido FOREIGN KEY (IdSeguido)
            REFERENCES dbo.Usuarios (IdUsuario),
        CONSTRAINT UQ_Seguidores_Relacion UNIQUE (IdSeguidor, IdSeguido),
        CONSTRAINT CK_Seguidores_NoAutoSeguir CHECK (IdSeguidor <> IdSeguido)
    );

    CREATE INDEX IX_Seguidores_IdSeguidor ON dbo.Seguidores (IdSeguidor);
    CREATE INDEX IX_Seguidores_IdSeguido ON dbo.Seguidores (IdSeguido);
END
GO
