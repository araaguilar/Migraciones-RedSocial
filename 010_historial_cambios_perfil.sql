-- 010 - Historial de cambios de identidad del perfil
-- Ejecutar despues de 009_crear_me_gusta_momentos.sql.

USE RedSocialDB;
GO

IF OBJECT_ID('dbo.HistorialCambiosPerfil', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.HistorialCambiosPerfil (
        IdCambio     INT IDENTITY(1,1) CONSTRAINT PK_HistorialCambiosPerfil PRIMARY KEY,
        IdUsuario    INT           NOT NULL,
        TipoCambio   NVARCHAR(30)  NOT NULL,
        ValorAnterior NVARCHAR(100) NULL,
        ValorNuevo    NVARCHAR(100) NULL,
        FechaCambio  DATETIME2     NOT NULL CONSTRAINT DF_HistorialCambiosPerfil_FechaCambio DEFAULT SYSUTCDATETIME(),
        CONSTRAINT FK_HistorialCambiosPerfil_Usuarios FOREIGN KEY (IdUsuario)
            REFERENCES dbo.Usuarios (IdUsuario)
            ON DELETE CASCADE,
        CONSTRAINT CK_HistorialCambiosPerfil_Tipo CHECK (TipoCambio IN ('nombre_perfil', 'nombre_usuario'))
    );

    CREATE INDEX IX_HistorialCambiosPerfil_Usuario_Tipo_Fecha
        ON dbo.HistorialCambiosPerfil (IdUsuario, TipoCambio, FechaCambio DESC);
END
GO
