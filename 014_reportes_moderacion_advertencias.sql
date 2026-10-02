USE RedSocialDB;
GO

IF COL_LENGTH('dbo.Usuarios', 'EstadoCuenta') IS NULL
BEGIN
    ALTER TABLE dbo.Usuarios
    ADD EstadoCuenta NVARCHAR(30) NOT NULL CONSTRAINT DF_Usuarios_EstadoCuenta DEFAULT N'activa',
        FechaDesactivacion DATETIME2 NULL,
        FechaEliminacion DATETIME2 NULL,
        MotivoEstadoCuenta NVARCHAR(300) NULL;
END;
GO

IF OBJECT_ID('dbo.Reportes', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.Reportes (
        IdReporte INT IDENTITY(1,1) NOT NULL CONSTRAINT PK_Reportes PRIMARY KEY,
        IdReportante INT NOT NULL,
        IdUsuarioReportado INT NULL,
        IdMomentoReportado INT NULL,
        Tipo NVARCHAR(20) NOT NULL,
        Motivo NVARCHAR(40) NOT NULL,
        Detalle NVARCHAR(500) NULL,
        Estado NVARCHAR(20) NOT NULL CONSTRAINT DF_Reportes_Estado DEFAULT N'abierto',
        FechaCreacion DATETIME2 NOT NULL CONSTRAINT DF_Reportes_FechaCreacion DEFAULT SYSUTCDATETIME(),
        CONSTRAINT FK_Reportes_Reportante FOREIGN KEY (IdReportante) REFERENCES dbo.Usuarios(IdUsuario),
        CONSTRAINT FK_Reportes_UsuarioReportado FOREIGN KEY (IdUsuarioReportado) REFERENCES dbo.Usuarios(IdUsuario),
        CONSTRAINT FK_Reportes_MomentoReportado FOREIGN KEY (IdMomentoReportado) REFERENCES dbo.Momentos(IdMomento),
        CONSTRAINT CK_Reportes_Objetivo CHECK (
            (IdUsuarioReportado IS NOT NULL AND IdMomentoReportado IS NULL)
            OR (IdUsuarioReportado IS NULL AND IdMomentoReportado IS NOT NULL)
        )
    );

    CREATE INDEX IX_Reportes_Estado_Fecha ON dbo.Reportes (Estado, FechaCreacion DESC);
    CREATE INDEX IX_Reportes_UsuarioReportado ON dbo.Reportes (IdUsuarioReportado);
    CREATE INDEX IX_Reportes_MomentoReportado ON dbo.Reportes (IdMomentoReportado);
END;
GO

IF OBJECT_ID('dbo.ModeracionAcciones', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.ModeracionAcciones (
        IdAccion INT IDENTITY(1,1) NOT NULL CONSTRAINT PK_ModeracionAcciones PRIMARY KEY,
        IdModerador INT NOT NULL,
        IdUsuarioObjetivo INT NOT NULL,
        Tipo NVARCHAR(30) NOT NULL,
        Motivo NVARCHAR(160) NOT NULL,
        Mensaje NVARCHAR(700) NULL,
        FechaCreacion DATETIME2 NOT NULL CONSTRAINT DF_ModeracionAcciones_FechaCreacion DEFAULT SYSUTCDATETIME(),
        CONSTRAINT FK_ModeracionAcciones_Moderador FOREIGN KEY (IdModerador) REFERENCES dbo.Usuarios(IdUsuario),
        CONSTRAINT FK_ModeracionAcciones_Objetivo FOREIGN KEY (IdUsuarioObjetivo) REFERENCES dbo.Usuarios(IdUsuario)
    );

    CREATE INDEX IX_ModeracionAcciones_Objetivo_Fecha ON dbo.ModeracionAcciones (IdUsuarioObjetivo, FechaCreacion DESC);
END;
GO

IF OBJECT_ID('dbo.AdvertenciasUsuario', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.AdvertenciasUsuario (
        IdAdvertencia INT IDENTITY(1,1) NOT NULL CONSTRAINT PK_AdvertenciasUsuario PRIMARY KEY,
        IdUsuario INT NOT NULL,
        IdModerador INT NOT NULL,
        Plantilla NVARCHAR(60) NOT NULL,
        Mensaje NVARCHAR(700) NOT NULL,
        Leida BIT NOT NULL CONSTRAINT DF_AdvertenciasUsuario_Leida DEFAULT 0,
        FechaCreacion DATETIME2 NOT NULL CONSTRAINT DF_AdvertenciasUsuario_FechaCreacion DEFAULT SYSUTCDATETIME(),
        CONSTRAINT FK_AdvertenciasUsuario_Usuario FOREIGN KEY (IdUsuario) REFERENCES dbo.Usuarios(IdUsuario),
        CONSTRAINT FK_AdvertenciasUsuario_Moderador FOREIGN KEY (IdModerador) REFERENCES dbo.Usuarios(IdUsuario)
    );

    CREATE INDEX IX_AdvertenciasUsuario_Usuario_Leida_Fecha ON dbo.AdvertenciasUsuario (IdUsuario, Leida, FechaCreacion DESC);
END;
GO
