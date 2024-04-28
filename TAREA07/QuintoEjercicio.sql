/*5. Crea una colección VARRAY llamada ListaZonas 
en la que se puedan almacenar hasta 10 objetos Zonas.
 Guarda en una instancia listaZonas1 de dicha lista, dos Zonas*/

-- Por si acaso, borramos el VARRAY
DROP TYPE listaZonas; 

-- Primero creamos el VARRAY
CREATE TYPE listaZonas IS VARRAY(10) OF Zonas;
/ -- Se cierra el bloque

-- INSTANCIAMOS
DECLARE
	listaZonas1 listaZonas; -- Declaramos una instancia de la colección VARRAY "ListasZonas"
	Zona1 Zonas; -- Instanciamos la primera zona del objeto Zonas
	Zona2 Zonas; -- Instanciamos la segunda zona del objeto Zonas

	ref_res REF Responsable; -- Variable que indica la referencia al tipo de objeto Responsable

BEGIN
	-- Primero: Seleccionamos la referencia de TablaResponsable de la Zona1
	SELECT REF(r) INTO ref_res FROM TablaResponsable r WHERE r.codigo = 5;
	-- Después, creamos una instancia de Zonas con los valores (Zona1 en este caso)
	Zona1 := NEW Zonas(1, 'Zona 1', ref_res, '06834');

	-- Segundo: Seleccionamos la referencia de Responsable de la Zona2
	SELECT REF(r) INTO ref_res FROM TablaResponsable r WHERE r.dni = '51083099F';
	-- Creamos una nueva instancia de Zonas con los valores de Zona2
	Zona2 := NEW Zonas(2, 'Zona 2', ref_res, '28003');

	-- Asignamos los objetos Zona1 y Zona2 a la listaZonas1
	listaZonas1 := listaZonas(Zona1, Zona2); 
END;

-- Se cierra el bloque anónimo PL/SQL
