DROP TYPE Comercial;
DROP TYPE Zonas;
DROP TYPE Responsable;
DROP TYPE Persona1; -- El orden del DROP TYPE es importante, pues al heredar no te dejará borrar los demas tipos por lo que el Objeto "Padre" debe ir al último



    -- Primero: especificación del tipo de objeto
    CREATE OR REPLACE TYPE Persona1 AS OBJECT (
        -- Aquí indicaremos los atributos de nuestro TIPO-OBJETO "Persona1"
        codigo INTEGER,
        dni VARCHAR(10),
        nombre VARCHAR(30),
        apellidos VARCHAR(20),
        sexo VARCHAR(1),
        fecha_nac DATE
        -- Aquí irían los metodos si los hubiese:
    ) NOT FINAL; -- Para que otro tipo objeto pueda heredar de "Persona1" debe tener la propiedad NOT FINAL
    /

    -- HERENCIA --
    --Crea como tipo heredado de "Persona 1", el tipo-objeto "Responsable".
    --Usamos la palabra reservada UNDER para indicar que hereda
    CREATE OR REPLACE TYPE Responsable UNDER Persona1 (
        tipo CHAR,
        antiguedad INTEGER
    );
    /

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

