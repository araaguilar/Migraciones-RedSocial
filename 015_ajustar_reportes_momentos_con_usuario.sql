USE RedSocialDB;
GO

IF OBJECT_ID('dbo.Reportes', 'U') IS NOT NULL
BEGIN
    IF EXISTS (
        SELECT 1
        FROM sys.check_constraints
        WHERE name = N'CK_Reportes_Objetivo'
          AND parent_object_id = OBJECT_ID(N'dbo.Reportes')
    )
    BEGIN
        ALTER TABLE dbo.Reportes DROP CONSTRAINT CK_Reportes_Objetivo;
    END;

    UPDATE r
    SET IdUsuarioReportado = m.IdUsuario
    FROM dbo.Reportes r
    INNER JOIN dbo.Momentos m ON m.IdMomento = r.IdMomentoReportado
    WHERE r.Tipo = N'momento'
      AND r.IdMomentoReportado IS NOT NULL
      AND r.IdUsuarioReportado IS NULL;

    ALTER TABLE dbo.Reportes
    ADD CONSTRAINT CK_Reportes_Objetivo CHECK (
        (Tipo = N'perfil' AND IdUsuarioReportado IS NOT NULL AND IdMomentoReportado IS NULL)
        OR (Tipo = N'momento' AND IdUsuarioReportado IS NOT NULL AND IdMomentoReportado IS NOT NULL)
    );
END;
GO
