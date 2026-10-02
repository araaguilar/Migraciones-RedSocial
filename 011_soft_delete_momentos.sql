-- 011 - Soft delete para momentos
-- Ejecutar despues de 010_historial_cambios_perfil.sql.

USE RedSocialDB;
GO

SET ANSI_NULLS ON;
GO

SET QUOTED_IDENTIFIER ON;
GO

IF COL_LENGTH('dbo.Momentos', 'FechaEliminacion') IS NULL
BEGIN
    ALTER TABLE dbo.Momentos
    ADD FechaEliminacion DATETIME2 NULL;
END
GO

IF COL_LENGTH('dbo.Momentos', 'EliminarDefinitivamenteEn') IS NULL
BEGIN
    ALTER TABLE dbo.Momentos
    ADD EliminarDefinitivamenteEn DATETIME2 NULL;
END
GO

IF COL_LENGTH('dbo.Momentos', 'EliminadoPorUsuario') IS NULL
BEGIN
    ALTER TABLE dbo.Momentos
    ADD EliminadoPorUsuario INT NULL;

    ALTER TABLE dbo.Momentos
    ADD CONSTRAINT FK_Momentos_EliminadoPorUsuario
        FOREIGN KEY (EliminadoPorUsuario)
        REFERENCES dbo.Usuarios (IdUsuario)
        ON DELETE NO ACTION;
END
GO

IF COL_LENGTH('dbo.Momentos', 'MotivoEliminacion') IS NULL
BEGIN
    ALTER TABLE dbo.Momentos
    ADD MotivoEliminacion NVARCHAR(200) NULL;
END
GO

IF NOT EXISTS (
    SELECT 1
    FROM sys.indexes
    WHERE name = 'IX_Momentos_Activo_EliminarDefinitivamenteEn'
      AND object_id = OBJECT_ID('dbo.Momentos')
)
BEGIN
    CREATE INDEX IX_Momentos_Activo_EliminarDefinitivamenteEn
        ON dbo.Momentos (Activo, EliminarDefinitivamenteEn)
        WHERE Activo = 0 AND EliminarDefinitivamenteEn IS NOT NULL;
END
GO
