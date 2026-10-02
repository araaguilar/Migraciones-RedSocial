-- 012 - Vista e indices para busqueda basica
-- Ejecutar despues de 011_soft_delete_momentos.sql.

USE RedSocialDB;
GO

SET ANSI_NULLS ON;
GO

SET QUOTED_IDENTIFIER ON;
GO

CREATE OR ALTER VIEW dbo.vw_BusquedaPerfiles
AS
SELECT
    u.IdUsuario,
    u.NombreUsuario,
    COALESCE(p.NombrePerfil, u.NombrePerfil) AS NombrePerfil,
    p.SobreMi,
    p.FotoPerfilUrl,
    u.Activo
FROM dbo.Usuarios u
LEFT JOIN dbo.PerfilesUsuario p ON p.IdUsuario = u.IdUsuario;
GO

IF NOT EXISTS (
    SELECT 1 FROM sys.indexes
    WHERE name = 'IX_Usuarios_NombreUsuario_Busqueda'
      AND object_id = OBJECT_ID('dbo.Usuarios')
)
BEGIN
    CREATE INDEX IX_Usuarios_NombreUsuario_Busqueda
        ON dbo.Usuarios (NombreUsuario)
        INCLUDE (NombrePerfil, Activo);
END
GO

IF NOT EXISTS (
    SELECT 1 FROM sys.indexes
    WHERE name = 'IX_PerfilesUsuario_NombrePerfil_Busqueda'
      AND object_id = OBJECT_ID('dbo.PerfilesUsuario')
)
BEGIN
    CREATE INDEX IX_PerfilesUsuario_NombrePerfil_Busqueda
        ON dbo.PerfilesUsuario (NombrePerfil)
        INCLUDE (IdUsuario, SobreMi, FotoPerfilUrl);
END
GO

IF NOT EXISTS (
    SELECT 1 FROM sys.indexes
    WHERE name = 'IX_Momentos_Activo_Texto_Fecha'
      AND object_id = OBJECT_ID('dbo.Momentos')
)
BEGIN
    CREATE INDEX IX_Momentos_Activo_Texto_Fecha
        ON dbo.Momentos (Activo, FechaCreacion DESC)
        INCLUDE (Texto, IdUsuario, TipoAdjunto, ArchivoUrl, LinkUrl, TotalMeGusta, TotalComentarios);
END
GO
