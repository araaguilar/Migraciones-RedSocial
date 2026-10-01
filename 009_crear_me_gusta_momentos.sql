-- 009 - Crear tabla de me encanta para momentos
-- Ejecutar despues de 008_crear_tabla_momentos.sql.

USE RedSocialDB;
GO

IF OBJECT_ID('dbo.MeGustaMomentos', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.MeGustaMomentos (
        IdMeGusta     INT IDENTITY(1,1) CONSTRAINT PK_MeGustaMomentos PRIMARY KEY,
        IdMomento     INT       NOT NULL,
        IdUsuario     INT       NOT NULL,
        FechaCreacion DATETIME2 NOT NULL CONSTRAINT DF_MeGustaMomentos_FechaCreacion DEFAULT SYSUTCDATETIME(),
        CONSTRAINT FK_MeGustaMomentos_Momentos FOREIGN KEY (IdMomento)
            REFERENCES dbo.Momentos (IdMomento)
            ON DELETE CASCADE,
        CONSTRAINT FK_MeGustaMomentos_Usuarios FOREIGN KEY (IdUsuario)
            REFERENCES dbo.Usuarios (IdUsuario)
            ON DELETE NO ACTION,
        CONSTRAINT UQ_MeGustaMomentos_Momento_Usuario UNIQUE (IdMomento, IdUsuario)
    );

    CREATE INDEX IX_MeGustaMomentos_IdUsuario_FechaCreacion
        ON dbo.MeGustaMomentos (IdUsuario, FechaCreacion DESC);
END
GO
