-- 006 - Crear tabla para recuperacion de contrasenas
-- Ejecutar despues de 005_crear_tabla_perfiles_usuario.sql.

USE RedSocialDB;
GO

IF OBJECT_ID('dbo.RecuperacionesPassword', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.RecuperacionesPassword (
        IdRecuperacionPassword INT IDENTITY(1,1) CONSTRAINT PK_RecuperacionesPassword PRIMARY KEY,
        IdUsuario              INT           NOT NULL,
        Email                  NVARCHAR(100) NOT NULL,
        CodigoHash             VARCHAR(64)   NOT NULL,
        TokenRecuperacion      VARCHAR(64)   NOT NULL,
        ExpiraEn               DATETIME2     NOT NULL,
        IntentosFallidos       INT           NOT NULL CONSTRAINT DF_RecuperacionesPassword_IntentosFallidos DEFAULT 0,
        FechaCreacion          DATETIME2     NOT NULL CONSTRAINT DF_RecuperacionesPassword_FechaCreacion DEFAULT SYSUTCDATETIME(),
        FechaVerificacion      DATETIME2     NULL,
        Usado                  BIT           NOT NULL CONSTRAINT DF_RecuperacionesPassword_Usado DEFAULT 0,
        CONSTRAINT FK_RecuperacionesPassword_Usuarios FOREIGN KEY (IdUsuario)
            REFERENCES dbo.Usuarios (IdUsuario)
            ON DELETE CASCADE,
        CONSTRAINT UQ_RecuperacionesPassword_TokenRecuperacion UNIQUE (TokenRecuperacion)
    );

    CREATE INDEX IX_RecuperacionesPassword_Email ON dbo.RecuperacionesPassword (Email);
    CREATE INDEX IX_RecuperacionesPassword_IdUsuario ON dbo.RecuperacionesPassword (IdUsuario);
END
GO
