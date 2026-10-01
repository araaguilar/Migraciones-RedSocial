-- 003 - Vista optimizada para disponibilidad de nombres de usuario
-- Ejecutar despues de 002_registro_verificacion_email_roles.sql.

USE RedSocialDB;
GO

SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;
GO

IF OBJECT_ID('dbo.vw_UsuariosLookup', 'V') IS NOT NULL
    DROP VIEW dbo.vw_UsuariosLookup;
GO

CREATE VIEW dbo.vw_UsuariosLookup
WITH SCHEMABINDING
AS
    SELECT
        IdUsuario,
        NombreUsuario
    FROM dbo.Usuarios;
GO

IF NOT EXISTS (
    SELECT 1
    FROM sys.indexes
    WHERE name = 'IX_vw_UsuariosLookup_NombreUsuario'
      AND object_id = OBJECT_ID('dbo.vw_UsuariosLookup')
)
BEGIN
    CREATE UNIQUE CLUSTERED INDEX IX_vw_UsuariosLookup_NombreUsuario
    ON dbo.vw_UsuariosLookup (NombreUsuario);
END
GO
