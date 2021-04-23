go
CREATE TRIGGER tgrGrupoInsert ON grupo AFTER INSERT
AS 
BEGIN
    INSERT INTO auditoria (accion, tabla, descripcion)
	VALUES ('C', 'Grupo', 'Se inserto un registro')
END

DROP TRIGGER tgrGrupoDelete
go
CREATE TRIGGER tgrGrupoInsert2 ON grupo AFTER INSERT
AS 
BEGIN
    DECLARE @id VARCHAR(50), @nombre VARCHAR(60)
	SET @id=(SELECT idGrupo FROM inserted)
	SET @nombre=(SELECT nombreGrupo FROM inserted)
    INSERT INTO auditoria (accion, tabla, descripcion)
	VALUES ('C', 'Grupo', CONCAT('Se inserto en Grupo ID=',@id,', Nombre=',@nombre))
END

go
CREATE TRIGGER tgrGrupoDelete ON grupo AFTER DELETE
AS 
BEGIN
    DECLARE @id VARCHAR(50), @nombre VARCHAR(60)
	SET @id=(SELECT idGrupo FROM deleted)
	SET @nombre=(SELECT nombreGrupo FROM deleted)
    INSERT INTO auditoria (accion, tabla, descripcion)
	VALUES ('D', 'Grupo', CONCAT('Se elimino Grupo ID=',@id,', Nombre=',@nombre))
END

go
CREATE TRIGGER tgrGrupoUpdate ON grupo AFTER UPDATE
AS 
BEGIN
    DECLARE @id VARCHAR(50), @nombre VARCHAR(60), @nombreNuevo VARCHAR(60)
	SET @id=(SELECT idGrupo FROM deleted)
	SET @nombre=(SELECT nombreGrupo FROM deleted)
	SET @nombreNuevo=(SELECT nombreGrupo FROM inserted)
    INSERT INTO auditoria (accion, tabla, descripcion)
	VALUES ('U', 'Grupo', CONCAT('Se modifico el nombre del Grupo ID=',@id,' de:',@nombre,' a:',@nombreNuevo))
END
UPDATE grupo SET nombreGrupo='URGENCIAS'
WHERE idGrupo='8'