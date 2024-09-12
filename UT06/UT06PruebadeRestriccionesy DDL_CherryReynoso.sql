/* Consultas de prueba para comprobar funcionamiento del Disparador*/
/*Prueba con longitud de la clave*/
    /*ACTIVA TRIGGER*/
    INSERT INTO AGENTES(IDENTIFICADOR, NOMBRE, USUARIO, CLAVE, HABILIDAD, CATEGORIA, FAMILIA, OFICINA)
    VALUES (10001,'Ramón Bilbao', 'rmblb', '12345', 2, 0, null, 0)

    /*INSERTA FILA*/
    INSERT INTO AGENTES(IDENTIFICADOR, NOMBRE, USUARIO, CLAVE, HABILIDAD, CATEGORIA, FAMILIA, OFICINA)
    VALUES (11235,'Ramón Bilbao', 'rmblb', '123456', 2, 0, null, 1)

/*Prueba con rango de habilidad*/
    /*ACTIVA TRIGGER*/
    INSERT INTO AGENTES(IDENTIFICADOR, NOMBRE, USUARIO, CLAVE, HABILIDAD, CATEGORIA, FAMILIA, OFICINA)
    VALUES (11235,'Armando Manzanero', 'amndmz', '223456', -1, 0, 11, null)

    /*INSERTA FILA*/
    INSERT INTO AGENTES(IDENTIFICADOR, NOMBRE, USUARIO, CLAVE, HABILIDAD, CATEGORIA, FAMILIA, OFICINA)
    VALUES (11235,'Armando Manzanero', 'amndmz', '223456', 9, 0, 11, null)

/*Prueba con rango de categoria*/
    /*ACTIVA TRIGGER*/
    INSERT INTO AGENTES(IDENTIFICADOR, NOMBRE, USUARIO, CLAVE, HABILIDAD, CATEGORIA, FAMILIA, OFICINA)
    VALUES (11236,'Beatriz Bedolla', 'btzbda', '323456', 0, 3, 11, null)

    /*INSERTA FILA*/
    INSERT INTO AGENTES(IDENTIFICADOR, NOMBRE, USUARIO, CLAVE, HABILIDAD, CATEGORIA, FAMILIA, OFICINA)
    VALUES (11236,'Beatriz Bedolla', 'btzbda', '323456', 0, 0, 11, null)

/*Prueba con rango de categoria 2: no puede pertenecer a ninguna familia pero si a una oficina*/
    /*ACTIVA TRIGGER*/
    INSERT INTO AGENTES(IDENTIFICADOR, NOMBRE, USUARIO, CLAVE, HABILIDAD, CATEGORIA, FAMILIA, OFICINA)
    VALUES (11238,'María Salcedo', 'mrslcd', '423456', 0, 2, 11, 1)

    /*ACTIVA TRIGGER*/
    INSERT INTO AGENTES(IDENTIFICADOR, NOMBRE, USUARIO, CLAVE, HABILIDAD, CATEGORIA, FAMILIA, OFICINA)
    VALUES (11238,'María Salcedo', 'mrslcd', '423456', 0, 2, null, null)

    /*INSERTA FILA*/
    INSERT INTO AGENTES(IDENTIFICADOR, NOMBRE, USUARIO, CLAVE, HABILIDAD, CATEGORIA, FAMILIA, OFICINA)
    VALUES (11238,'María Salcedo', 'mrslcd', '423456', 0, 2, null, 1)

/*Prueba con rango de categoria 1: no puede pertenecer a ninguna oficna pero si a una familia*/
    /*ACTIVA TRIGGER*/
    INSERT INTO AGENTES(IDENTIFICADOR, NOMBRE, USUARIO, CLAVE, HABILIDAD, CATEGORIA, FAMILIA, OFICINA)
    VALUES (11239,'Hortencia DOmniguez', 'hrtdmz', '523456', 0, 1, 11, 1)

    /*ACTIVA TRIGGER*/
    INSERT INTO AGENTES(IDENTIFICADOR, NOMBRE, USUARIO, CLAVE, HABILIDAD, CATEGORIA, FAMILIA, OFICINA)
    VALUES (11239,'Hortencia DOmniguez', 'hrtdmz', '523456', 0, 1, null, null)

    /*INSERTA FILA*/
    INSERT INTO AGENTES(IDENTIFICADOR, NOMBRE, USUARIO, CLAVE, HABILIDAD, CATEGORIA, FAMILIA, OFICINA)
    VALUES (11239,'Hortencia DOmniguez', 'hrtdmz', '523456', 0, 1, 11, null)

/*Prueba contodos los agentes deben pertencer a una familia u oficina pero nunca a ambas a la vez*/
    /*ACTIVA TRIGGER*/
    INSERT INTO AGENTES(IDENTIFICADOR, NOMBRE, USUARIO, CLAVE, HABILIDAD, CATEGORIA, FAMILIA, OFICINA)
    VALUES (11240,'Tomas Hernandez', 'tmhdz', '623456', 0, 0, 11, 2)
    /*ACTIVA TRIGGER*/
    INSERT INTO AGENTES(IDENTIFICADOR, NOMBRE, USUARIO, CLAVE, HABILIDAD, CATEGORIA, FAMILIA, OFICINA)
    VALUES (11240,'Tomas Hernandez', 'tmhdz', '623456', 0, 0, null, null)

    /*INSERTA FILAs*/
    INSERT INTO AGENTES(IDENTIFICADOR, NOMBRE, USUARIO, CLAVE, HABILIDAD, CATEGORIA, FAMILIA, OFICINA)
    VALUES (11240,'Tomas Hernandez', 'tmhdz', '623456', 0, 0, 11, null);

    INSERT INTO AGENTES(IDENTIFICADOR, NOMBRE, USUARIO, CLAVE, HABILIDAD, CATEGORIA, FAMILIA, OFICINA)
    VALUES (11241,'Araceli Hernandez', 'arhdz', '7623456', 0, 0, null, 1);

----

/* Restricciones que se pueden implementar en el esquema de la table AGENTES*/
ALTER TABLE agentes
ADD CONSTRAINT chk_habilidad_rango CHECK (habilidad BETWEEN 0 AND 9) NOT NULL;

ALTER TABLE agentes
ADD CONSTRAINT chk_categoria_rango CHECK (categoria IN (0, 1, 2));

