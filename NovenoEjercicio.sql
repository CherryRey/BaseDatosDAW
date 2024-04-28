DROP TYPE listaZonas; 
DROP TABLE TablaComerciales; 
DROP TABLE TablaResponsable; 
DROP TYPE Comercial;
DROP TYPE Zonas;
DROP TYPE Responsable;
DROP TYPE Persona1; 


CREATE OR REPLACE TYPE Persona1 AS OBJECT (
        -- Aquí indicaremos los atributos de nuestro TIPO-OBJETO "Persona1"
        codigo INTEGER,
        dni VARCHAR(10),
        nombre VARCHAR(30),
        apellidos VARCHAR(20),
        sexo VARCHAR(1),
        fecha_nac DATE      
    ) NOT FINAL; -- Para que otro tipo objeto pueda heredar de "Persona1" debe tener la propiedad NOT FINAL
    /

-- Especificamos el  método getNombreCompleto dentro  del tipo de objetos Responsable:
    CREATE OR REPLACE TYPE Responsable UNDER Persona1 (
            tipo CHAR,
            antiguedad INTEGER,
            -- Especificación de atributos del METODO CONSTRUCTOR. Usamos la palabra CONSTRUCTOR para indicar que es un método constructor.
            CONSTRUCTOR FUNCTION Responsable (
            codigo INTEGER,
            nombre VARCHAR2, -- Usamos VARCHAR2 con el método constructor
            primerApellido VARCHAR2,
            segundoApellido VARCHAR2,
            tipo CHAR
            )
            RETURN SELF AS RESULT,

            -- Especificación del método con MEMBER FUNCTION para que retorne un valor (MEMEBER PROCEDURE no lo hace)
            MEMBER FUNCTION getNombreCompleto RETURN VARCHAR2 -- Usamos "RETURN" para que nos devuelva el valor.
        );
        /

    -- Creamos el cuerpo del método 
    CREATE OR REPLACE TYPE BODY Responsable AS
        CONSTRUCTOR FUNCTION Responsable (
                    codigo INTEGER,
                    nombre VARCHAR2, -- Usamos VARCHAR2 con el método constructor
                    primerApellido VARCHAR2,
                    segundoApellido VARCHAR2,
                    tipo CHAR)
                RETURN SELF AS RESULT IS
            BEGIN
                -- Ahora asignamos los valores correspondientes a los atributos usando SELF
                SELF.codigo := codigo;
                SELF.nombre := nombre;
                SELF.apellidos:= primerApellido || ' ' || segundoApellido; -- esta vez, aplicamos la concetación en el SELF.apellidos y no creamos una variable.
                SELF.tipo := tipo;
                RETURN; 
            END; -- Finalizamos el bloque del METODO CONSTRUCTOR
            -- Implemtenaticon     
            MEMBER FUNCTION getNombreCompleto RETURN VARCHAR2 IS
            nombreCompleto VARCHAR2(80); -- Declaramos una variable "nombrecompleto" antes de empezar el bloque
            BEGIN
                nombreCompleto := apellidos || ' ' || nombre; -- Asignamos a la variable "nombreCompleto" la concatenacion. 
                RETURN nombreCompleto; -- Devolvemos  valor de la variable
            END getNombreCompleto; --Finalizamos el método
    END;-- 
    /


    -- CREAMOS LOS OTROS OBJETOS: ZONAS Y COMERCIAL--    
    -- Crea tipo de objeto "Zonas" con referencia a objeto "Responsable"
    CREATE OR REPLACE TYPE Zonas AS OBJECT(
        codigo INTEGER,
        nombre VARCHAR(20),
        refRespon REF Responsable, -- Referimos a objeto "Responsable"
        codigoPostal CHAR(5),

        /*9. Crea un método MAP OrdenarZonas para el tipo Zonas. 
        Este método debe retornar el nombre completo del Responsable 
        al que hace referencia cada zona. 
        Para obtener el nombre debes utilizar el
         método getNombreCompleto que se ha creado anteriormente*/

        -- 9.1 Creamos Método MAP
        MAP MEMBER FUNCTION OrdenarZonas RETURN VARCHAR2

    );
    /

    --9.2 Creamos el cuerpo del Método MAP OrdenarZonas

    CREATE OR REPLACE TYPE BODY Zonas AS
        MAP MEMBER FUNCTION OrdenarZonas RETURN VARCHAR2 IS
            respon1 Responsable;
        BEGIN
            SELECT DEREF(refRespon) INTO respon1 FROM DUAL; -- Para navegar y obtener los atributos de un objeto referenciado usamos DEREF
            RETURN respon1.getNombreCompleto();
        END OrdenarZonas;
    END;
    /
    --HERENCIA--
    -- Crea como tipo heredado de "Persona1", el tipo de objeto "Comercial"
    CREATE OR REPLACE TYPE Comercial UNDER Persona1(
        ZonaComercial Zonas --ZonaComercial es un atributo de tipo "Zonas" (como una instancia)
    );
    /




-- Creamos o reemplazamos la tabla TablaResponsable con los objetos del tipo Responsable
CREATE TABLE TablaResponsable OF Responsable;
/ -- Se cierra el bloque

BEGIN
    -- Insertamos el primer objeto en la tabla TablaResponsable
    INSERT INTO TablaResponsable VALUES (Responsable(5, '51083099F', 'Elena', 'Posta Llanos', 'F', '31-03-1975', 'N', 4));

    -- Insertamos el segundo objeto utilizando el MÉTODO CONSTRUCTOR.
    -- Para ello, utilizamos "NEW" para llamar a dicho método y luego lo insertamos en la tabla.
    INSERT INTO TablaResponsable VALUES (NEW Responsable(6, 'Javier', 'Jaramillo', 'Hernandez', 'C'));
END;
/



CREATE TABLE TablaComerciales OF Comercial;
/

-- Primero creamos el VARRAY
CREATE TYPE listaZonas IS VARRAY(10) OF Zonas;
/

-- INSTANCIAMOS
DECLARE
    listaZonas1 listaZonas; -- Declaramos una instancia de la colección VARRAY "ListasZonas"
    Zona1 Zonas; -- Instanciamos la primera zona del objeto Zonas
    Zona2 Zonas; -- Instanciamos la segunda zona del objeto Zonas
    ref_res REF Responsable; -- Variable que indica la referencia al tipo de objeto Responsable
    unComercial Comercial; -- Variable para almacenar el Comercial con código 100
BEGIN
    -- 5. Primero: Seleccionamos la referencia de TablaResponsable de la Zona1
    SELECT REF(r) INTO ref_res FROM TablaResponsable r WHERE r.codigo = 5;
    -- Después, creamos una instancia de Zonas con los valores (Zona1 en este caso)
    Zona1 := NEW Zonas(1, 'Zona 1', ref_res, '06834');

    -- 6. Segundo: Seleccionamos la referencia de Responsable de la Zona2
    SELECT REF(r) INTO ref_res FROM TablaResponsable r WHERE r.dni = '51083099F';
    -- Creamos una nueva instancia de Zonas con los valores de Zona2
    Zona2 := NEW Zonas(2, 'Zona 2', ref_res, '28003');

    -- Asignamos los objetos Zona1 y Zona2 a la listaZonas1
    listaZonas1 := listaZonas(Zona1, Zona2);
    
    -- 7. INSERTAMOS LOS VALORES EN LA "TablaComerciales" con los objetos de "listaZonas"
    INSERT INTO TablaComerciales VALUES (Comercial(100, '23401092Z', 'MARCOS', 'SUAREZ LOPEZ', 'M', '30-3-1990', listaZonas1(1)));
    INSERT INTO TablaComerciales VALUES (Comercial(102, '6932288V', 'ANASTASIA', 'GOMES PEREZ', 'F', '28-11-1984', listaZonas1(2)));
    
    -- 7. Obtener el Comercial con código 100 y asignarlo a la variable unComercial
    SELECT VALUE(tc) INTO unComercial FROM TablaComerciales tc WHERE tc.codigo = 100;
    
    /*8. Modifica el código del Comercial guardado en esa variable unComercial asignando el valor 101, 
    y su zona debe ser la segunda que se había creado anteriormente. Inserta ese Comercial en la tabla TablaComerciales*/
    unComercial.codigo:= 101; -- Por medio del atributo, modificamos el codigo

    unComercial.ZonaComercial := listaZonas1(2);
    --unComercial es la variable del tipoObjeto Comercial y ZonaComercial es el atributo de Zonas que también funciona como atributo de "unComercial"
    --listasZonas1(2) le indicamos que el atributo se tomará del arreglo listoZonas1, especificamente el 2.

    --8.1Insertamos los valores en la tabla "TablaComerciales"
    INSERT INTO TablaComerciales VALUES (unComercial);    
END;
/
-- Se cierra el bloque anónimo
