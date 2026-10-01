-- 008 - Crear tabla de momentos/publicaciones
-- Ejecutar despues de 007_social_basico_perfiles_seguidores.sql.

USE RedSocialDB;
GO

IF OBJECT_ID('dbo.Momentos', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.Momentos (
        IdMomento          INT IDENTITY(1,1) CONSTRAINT PK_Momentos PRIMARY KEY,
        IdUsuario          INT           NOT NULL,
        Texto              NVARCHAR(180) NOT NULL,
        TipoAdjunto        NVARCHAR(20)  NULL,
        ArchivoUrl         NVARCHAR(500) NULL,
        LinkUrl            NVARCHAR(500) NULL,
        TotalMeGusta       INT           NOT NULL CONSTRAINT DF_Momentos_TotalMeGusta DEFAULT 0,
        TotalComentarios   INT           NOT NULL CONSTRAINT DF_Momentos_TotalComentarios DEFAULT 0,
        Activo             BIT           NOT NULL CONSTRAINT DF_Momentos_Activo DEFAULT 1,
        FechaCreacion      DATETIME2     NOT NULL CONSTRAINT DF_Momentos_FechaCreacion DEFAULT SYSUTCDATETIME(),
        FechaActualizacion DATETIME2     NULL,
        CONSTRAINT FK_Momentos_Usuarios FOREIGN KEY (IdUsuario)
            REFERENCES dbo.Usuarios (IdUsuario)
            ON DELETE CASCADE,
        CONSTRAINT CK_Momentos_TipoAdjunto CHECK (TipoAdjunto IS NULL OR TipoAdjunto IN ('foto', 'video', 'link'))
    );

    CREATE INDEX IX_Momentos_IdUsuario_FechaCreacion ON dbo.Momentos (IdUsuario, FechaCreacion DESC);
    CREATE INDEX IX_Momentos_Activo_FechaCreacion ON dbo.Momentos (Activo, FechaCreacion DESC);
END
GO
