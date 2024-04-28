/* 7. Obtener, de la tabla TablaComerciales, el Comercial que tiene el código 100, asignándoselo a una variable unComercial */

/* Debemos crear la tabla antes del VARRAY e insertar los valores de la tabla dentro del bloque con las instancias de ListaZonas
esto debido a que las instancias son LOCALES*/


-- Por si acaso, borramos el VARRAY y LA TABLA
DROP TYPE listaZonas; 
DROP TABLE TablaComerciales; 


CREATE TABLE TablaComerciales OF Comercial;
/
-- Primero creamos el VARRAY
CREATE TYPE listaZonas IS VARRAY(10) OF Zonas;
/
 -- Se cierra el bloque

-- INSTANCIAMOS
DECLARE
	listaZonas1 listaZonas; -- Declaramos una instancia de la colección VARRAY "ListasZonas"
	Zona1 Zonas; -- Instanciamos la primera zona del objeto Zonas
	Zona2 Zonas; -- Instanciamos la segunda zona del objeto Zonas

	ref_res REF Responsable; -- Variable que indica la referencia al tipo de objeto Responsable

    /*CREAMOS VARIABLE*/

    unComercial Comercial; 

BEGIN
	-- 5. Primero: Seleccionamos la referencia de TablaResponsable de la Zona1
	SELECT REF(r) INTO ref_res FROM TablaResponsable r WHERE r.codigo = 5;
	-- Después, creamos una instancia de Zonas con los valores (Zona1 en este caso)
	Zona1 := NEW Zonas(1, 'Zona 1', ref_res, '06834');

	-- Segundo: Seleccionamos la referencia de Responsable de la Zona2
	SELECT REF(r) INTO ref_res FROM TablaResponsable r WHERE r.dni = '51083099F';
	-- Creamos una nueva instancia de Zonas con los valores de Zona2
	Zona2 := NEW Zonas(2, 'Zona 2', ref_res, '28003');

	-- Asignamos los objetos Zona1 y Zona2 a la listaZonas1
	listaZonas1 := listaZonas(Zona1, Zona2);
    
    -- 6. INSERTAMOS LOS VALORES EN LA "TablaComerciales" con los objetos de "listaZonas"
    INSERT INTO TablaComerciales VALUES (Comercial(100, '23401092Z', 'MARCOS', 'SUAREZ LOPEZ', 'M', '30-3-1990', listaZonas1(1)));
    INSERT INTO TablaComerciales VALUES (Comercial(102, '6932288V', 'ANASTASIA', 'GOMES PEREZ', 'F', '28-11-1984', listaZonas1(2)));

    --7.OBTENEMOS EL COMERCIAL CON EL CODIGO 100
    SELECT VALUES (tc) INTO unComercial FROM TablaComerciales tc WHERE tc.codigo = 100;

    
END;

-- Se cierra el bloque anónimo PL/SQL
