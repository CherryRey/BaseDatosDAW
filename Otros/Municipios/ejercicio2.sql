SELECT * FROM  INFORME; -- LA TABLA INFORME NO TIENE NADA
-- HAY QUE CREAR UN PROCEDIMIENTO QUE CARGUE CADA VEZ QUE SE EJECUTE LOS DATOS DE LOS NOMBRE DE LOS MUNICIPIO ORDENADOS ALFABETICAMENTE 
--JUNTO CON NOMBRE Y HABITANTES DE 4 CUATRO LOCAL CON MAS HABITANTES DE CADA MUNICIPIO. 
--HAY QUE TENER EN CUENTA QUE HAY MUNICIPIO QUE PUEDEN TENER MENOS DE 4 LOCALIDADES O NINGUNA. ENTONCES DEBE RELLENARSE CON NULL
SELECT * FROM MUNICIPIOS;
SELECT * FROM LOCALIDADES;


DROP PROCEDURE PR_INFORMES;

/*En el procedimiento creamos un cursor "cursorInforme" indicando que seleccione los campos NOMBRE e ID de la TABLA MUNCIPIOS Y los ordene */
CREATE OR REPLACE PROCEDURE PR_INFORMES AS
    CURSOR cursorInforme IS
        SELECT NOMBRE, ID FROM MUNICIPIOS ORDER BY NOMBRE; -- Obtener los nombres e IDs de los municipios ordenados alfabéticamente
    
    varNombreMuncipio MUNICIPIOS.NOMBRE%TYPE; 
    varIDMuncipio MUNICIPIOS.ID%TYPE;
    varNombreLocal LOCALIDADES.NOMBRE_LOC%TYPE;
    varHabitantesLocal LOCALIDADES.HABITANTES%TYPE;
    varContador NUMBER := 0;

BEGIN
    -- Recorrer los nombres de los municipios con un FOR LOOP
    FOR cadaMunicipio IN cursorInforme LOOP
        varNombreMuncipio := cadaMunicipio.NOMBRE;
        varIDMuncipio := cadaMunicipio.ID;

        -- Un nuevo FOR LOOP anidado para obtener las cuatro localidades con más habitantes de cada municipio
        FOR cadaLocalidad IN (SELECT NOMBRE_LOC, HABITANTES
                    FROM (SELECT NOMBRE_LOC, HABITANTES, RANK() OVER (ORDER BY HABITANTES DESC) as ranking
                          FROM LOCALIDADES
                          WHERE MUNICIPIO = varIDMuncipio)
                    WHERE ranking <= 4) LOOP
            varNombreLocal := cadaLocalidad.NOMBRE_LOC;
            varHabitantesLocal := cadaLocalidad.HABITANTES;

            -- Insertar los valores obtenidos en el LOOP en la tabla informe
            INSERT INTO INFORME (nombremuni, nombreloc, habitantes)
            VALUES (varNombreMuncipio, varNombreLocal, varHabitantesLocal);

            varContador := varContador + 1; --para que el contador siga sumando las localidades a cada Muncipio y saber que muncipios NO TIENEN LOCALIDADES
        END LOOP; -- FIN DEL LOOP de "cadalocalidad"

        -- Si el municipio no tiene localidades, insertar el municipio y su población en la tabla informe. 
        --Usamos un IF y la variable creada al principio de contador.
        IF varContador = 0 THEN
            INSERT INTO INFORME (nombremuni, nombreloc, habitantes)
            VALUES (varNombreMuncipio, 'Sin localidades', (SELECT POBLACION FROM MUNICIPIOS WHERE ID = varIDMuncipio));
        END IF;

        varContador := 0; -- Reiniciar el contador para el próximo municipio
    END LOOP; -- FIN DEL LOOP de "cadaMunicipio"
    
   
END;
/

BEGIN
    PR_INFORMES;
END;
/

SELECT * FROM  INFORME;
ROLLBACK;

SELECT * FROM  INFORME;

--- B. 
DROP TRIGGER ActualizarHabitantes;

CREATE OR REPLACE TRIGGER ActualizarHabitantes
AFTER INSERT OR UPDATE ON LOCALIDADES
FOR EACH ROW
DECLARE
    varTotalHabitantes NUMBER;
BEGIN
    -- Calcular el total de habitantes para el municipio al que pertenece la localidad
    SELECT SUM(habitantes) INTO varTotalHabitantes
    FROM LOCALIDADES
    WHERE MUNICIPIO = :NEW.municipio;

    -- Actualizar el nÚmero de habitantes del municipio
    UPDATE MUNICIPIOS
    SET POBLACION = varTotalHabitantes -- Actualizamos la columna "POBLACION" de la TABLA MUNICIPIOS
    WHERE ID = :NEW.municipio;
END;
/