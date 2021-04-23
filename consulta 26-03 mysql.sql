DELIMITER $$
CREATE TRIGGER tgrOficinaInsert BEFORE INSERT ON oficina
FOR EACH ROW  
BEGIN
    INSERT INTO auditoria (accion, tabla, descripcion)
    VALUES('C', 'Oficina', CONCAT('Se inserto Oficina: ', NEW.nombreOficina,' - Direccion: ', NEW.direccion));
END$$

DELIMITER $$
CREATE TRIGGER tgrOficinaDelete BEFORE DELETE ON oficina
FOR EACH ROW  
BEGIN
    INSERT INTO auditoria (accion, tabla, descripcion)
    VALUES('D', 'Oficina', CONCAT('Se elimino Oficina: ', OLD.nombreOficina,' - Direccion: ', OLD.direccion));
END$$

DELIMITER $$
CREATE TRIGGER tgrOficinaUpdate BEFORE UPDATE ON oficina
FOR EACH ROW  
BEGIN
    INSERT INTO auditoria (accion, tabla, descripcion)
    VALUES('U', 'Oficina', CONCAT('Se modifico Oficina: ', OLD.nombreOficina,' a: ', NEW.nombreOficina));
END$$

INSERT INTO oficina (nombreOficina, direccion)
VALUES('Of. Quillacollo', 'Plaza Bolivar S/N')

DELETE FROM oficina WHERE idOficina=6;

UPDATE oficina SET nombreOficina='Oficina Sucursal Tiquipaya'
WHERE idOficina=7;

DROP TRIGGER tgrOficinaInsert;