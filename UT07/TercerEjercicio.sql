DROP TYPE Comercial;
DROP TYPE Zonas;
DROP TYPE Responsable;
DROP TYPE Persona1; 

-- 3. Crea un método getNombreCompleto para el tipo de objetos Responsable que permita obtener su nombre completo con el formato apellidos-nombre.

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
        codigoPostal CHAR(5)
    );
    /
    --HERENCIA--
    -- Crea como tipo heredado de "Persona1", el tipo de objeto "Comercial"
    CREATE OR REPLACE TYPE Comercial UNDER Persona1(
        ZonaComercial Zonas --ZonaComercial es un atributo de tipo "Zonas" (como una instancia)
    );
    /