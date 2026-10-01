-- 004 - Vista optimizada para disponibilidad de correos
-- Ejecutar despues de 003_vista_disponibilidad_usuarios.sql.

USE RedSocialDB;
GO

SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;
GO

IF OBJECT_ID('dbo.vw_EmailsLookup', 'V') IS NOT NULL
    DROP VIEW dbo.vw_EmailsLookup;
GO

CREATE VIEW dbo.vw_EmailsLookup
WITH SCHEMABINDING
AS
    SELECT
        IdUsuario,
        Email
    FROM dbo.Usuarios;
GO

IF NOT EXISTS (
    SELECT 1
    FROM sys.indexes
    WHERE name = 'IX_vw_EmailsLookup_Email'
      AND object_id = OBJECT_ID('dbo.vw_EmailsLookup')
)
BEGIN
    CREATE UNIQUE CLUSTERED INDEX IX_vw_EmailsLookup_Email
    ON dbo.vw_EmailsLookup (Email);
END
GO
