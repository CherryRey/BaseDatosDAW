-- Creo un procedimiento con CREATE OR REPLACE PROCEDURE.
-- Asigno una variable a origen y destino y las instancio con la columna de la tabla origen 
-- y con el atributo %TYPE declaro que tome el tipo de dato de la columna de origen.
CREATE OR REPLACE 
PROCEDURE CambiarAgentesFamilia (
    id_FamiliaOrigen familias.identificador%TYPE, 
    id_FamiliaDestino familias.identificador%TYPE)
IS
-- Vamos a declarar las variables locales:
        -- CURSOR VARIABLE PARA COMPROBAR SI EXISTEN LAS FAMILIAS
        --Defino mi cursor variable con REF CURSOR.
        --y que devuelva con el atributo %ROWTYPE la misma estructura que nuestra tabla origen (familias)
        TYPE cursorFam IS REF CURSOR RETURN familias%ROWTYPE;
        --declaro la variable que contendrá mi cursor
        famExiste cursorFam;
        -- Declaro una variable para almacenar los datos de "familias" pero con el tipo de dato definido por mi cursor
        NewFam famExiste%ROWTYPE;
        -- Variable que almacenaran si existe FamiliaOrigen; la dejamos inicializada en FALSE
        famOrigenExist BOOLEAN := FALSE;
        -- Variable que almacenara si existe FamiliaDestino; la dejamos inicializada en FALSE
        famDestinoExist BOOLEAN := FALSE;
        

BEGIN

        --COMPROBAMOS LA EXISTENCIA DE LAS FAMILIAS
        --Una vez definido nuestro cursor variable lo asociamos a una consulta:
        -- Comprobamos que familia Origen existe
        OPEN famExiste FOR SELECT * FROM familias WHERE identificador= id_FamiliaOrigen;
        FETCH famExiste INTO NewFam; -- recojo los datos de mi cursor y los voy almacenando en mi variable NewFam
        IF famExiste%NOTFOUND THEN
                RAISE_APPLICATION_ERROR(-20099,'La familia de Origen no existe.');
        ELSE famOrigenExist := TRUE;
        END IF;
        CLOSE famExiste;--Cerramos nuestro cursor
        
        -- COMPROBAMOS que familia Destino existe:
        OPEN famExiste FOR SELECT * FROM familias WHERE identificador = id_FamiliaDestino;
        FETCH famExiste INTO NewFam;
        IF famExiste%NOTFOUND THEN               
                RAISE_APPLICATION_ERROR(-20100,'La familia de Destino no existe.');
        ELSE famDestinoExist := TRUE;
        END IF;
        CLOSE famExiste; --Cerramos nuestro cursor

        -- Comprobamos SI AMBAS FAMILIAS son diferentes; si son iguales se alza un RAISE_APPLICATION_ERROR.
        OPEN famExiste FOR SELECT * FROM familias WHERE identificador = id_FamiliaOrigen;
        IF id_FamiliaDestino = id_FamiliaOrigen THEN
                RAISE_APPLICATION_ERROR(-20101, 'La familia de Origen no puede ser la misma que la de Destino.');
        END IF;
        CLOSE famExiste; --Cerramos nuestro cursor
      
        --ACTUALIZAMOS la tabla AGENTES modificando identificador de familia con código id_FamiliaOrigin por el de id_FamiliaDestino
        UPDATE Agentes
        SET familia = id_FamiliaDestino
        WHERE familia = id_FamiliaOrigen;

        
       
       -- MENSAJE de Confirmación 
        DBMS_OUTPUT.PUT_LINE('Se han trasladado ' || SQL%ROWCOUNT || ' agentes de la familia ' || id_FamiliaOrigen || ' a la familia ' || id_FamiliaDestino);           
       
END;
/
