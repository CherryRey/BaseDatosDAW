DROP TYPE Comercial;
DROP TYPE Zonas;
DROP TYPE Responsable;
DROP TYPE Persona1; -- El orden del DROP TYPE es importante, pues al heredar no te dejará borrar los demas tipos



-- Primero: especificación del tipo de objeto "Persona1"
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


 -- 2. Crea un método contructor para el tipo de objetos "Responsable"
        CREATE OR REPLACE TYPE Responsable UNDER Persona1 (
        tipo CHAR,
        antiguedad INTEGER,

         -- Especificación de atributos del metodo constructor. Usamos la palabra CONSTRUCTOR para indicar que es un método constructor.
        CONSTRUCTOR FUNCTION Responsable (
        codigo INTEGER,
        nombre VARCHAR2, -- Usamos VARCHAR2 con el método constructor
        primerApellido VARCHAR2,
        segundoApellido VARCHAR2,
        tipo CHAR
        )
        RETURN SELF AS RESULT
    );
    /
       
        -- Creamos el cuerpo del método constructor
        CREATE OR REPLACE TYPE BODY Responsable AS
            CONSTRUCTOR FUNCTION Responsable (
                codigo INTEGER,
                nombre VARCHAR2, -- Usamos VARCHAR2 con el método constructor
                primerApellido VARCHAR2,
                segundoApellido VARCHAR2,
                tipo CHAR)
            RETURN SELF AS RESULT
        IS
            -- Aquí primero declaramos una variable donde almacenar ambos apellidos
            apellidos VARCHAR (50);
        BEGIN
           -- asignamos los valores correspondientes a los atributos usando SELF
            SELF.codigo := codigo;
            SELF.nombre := nombre;
            SELF.apellidos:= primerApellido || ' ' || segundoApellido; -- Asignamos el valor de la variable que creamos anteriormente. Se puede aplicar la concatenación aquí, pero decidimos mejor usar una variable.
            SELF.tipo := tipo; 

            RETURN; --Con la palabra reservada "RETURN" devolvemos la instancia del tipo-objeto "Responsable"
        END;
        END;
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