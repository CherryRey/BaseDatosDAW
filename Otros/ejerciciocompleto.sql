/*Ejercicio 1: Definición de Objetos en PL/SQL
Define un objeto de tipo Estudiante que contenga los siguientes atributos: id, nombre, edad, ciclo formativo y curso. 
Los valores deben cumplir las siguientes condiciones:
    Id debe ser un número auto-incrementable y único.
    Edad debe ser un número igual o superior a 18.
    Curso debe ser un número entre 2000 y 2025.
    Nombre no debe superar los 50 caracteres.

Define un objeto de tipo Libro que contenga los siguientes atributos: id, título, autor, categoría y año de publicación.
Los valores deben cumplir las siguientes condiciones:
    Id debe ser un valor numérico único.
    Año de publicación debe ser un número entre 1900 y 2024.
    Autor no debe superar los 50 caracteres.
    Categoría debe pertenecer al conjunto: “Didáctico”, “Ficción” u “Otro”.
*/


--drops ejercicio3
DROP TRIGGER insertContadorLibros;
DROP TABLE Contador_Libros;
DROP TABLE Libros;
DROP TRIGGER insertHistorialEst;
DROP TABLE HistorialEstudiantes;
DROP TABLE Estudiantes;
--drops ejercicio2
DROP FUNCTION ImprimirLibro;
DROP PROCEDURE ImprimirNombre;
--drops ejercicio1
DROP TYPE Libro;
DROP TYPE Estudiante;
DROP SEQUENCE seqIdLib;
DROP SEQUENCE seqId;

/*Creamos una secuencia para poder hacer el ID incremental. 
Debido a que se llama en el tipo-objeto debe crearse antes de ser llamada*/
CREATE SEQUENCE seqId START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;
/

CREATE SEQUENCE seqIdLib START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;
/

/*Creamos objeto "Estudiante"*/
CREATE OR REPLACE TYPE Estudiante AS OBJECT (
    id_es INTEGER,
    edad INTEGER,
    cicloFormativo VARCHAR2(50),
    curso INTEGER,
    nombre VARCHAR2(50),
     -- Usamos una función CONSTRUCTOR porque deseamos inicializar los objetos con datos validos.
     --Un método contructor siempre debe llamarse igual que el objeto.     
     CONSTRUCTOR FUNCTION Estudiante
     (
        id_es INTEGER,
        edad INTEGER,
        cicloFormativo VARCHAR2,
        curso INTEGER,
        nombre VARCHAR2--En los CONSTRUCTORES no se coloca varchar2(50). Sólo varchar2. 
     )
     RETURN SELF AS RESULT
);
/

/*↑ Ahora creamos el cuerpo del método contructor y la implementacion*/

CREATE OR REPLACE TYPE BODY Estudiante AS
    CONSTRUCTOR FUNCTION Estudiante (
        id_es INTEGER,
        edad INTEGER,
        cicloFormativo VARCHAR2,
        curso INTEGER,
        nombre VARCHAR2
    ) RETURN SELF AS RESULT IS
    -- inicializo el CONSTRUCTOR 
    BEGIN
    SELF.id_es := seqId.NEXTVAL; -- asignamos id_secuencial

    -- asignamos restriccion de edad con un IF
    IF edad < 18 THEN
        RAISE_APPLICATION_ERROR(-20001, 'La edad debe ser igual o superior a 18');
    END IF;
    SELF.edad := edad;-- ahora si asignamos edad

    SELF.cicloFormativo := cicloFormativo;

    --asiganmos restriccion del curso con un IF
    IF NOT (curso BETWEEN 2000 AND 2025) THEN
        RAISE_APPLICATION_ERROR(-20002, 'El curso debe ser entre 2000 y 2025');
    END IF;
    SELF.curso := curso;
    
    --asignamos restriccion a nombre. Recordar que funciones como Length() los args deben ir en paréntesis
    IF LENGTH (nombre) > 50 THEN
        RAISE_APPLICATION_ERROR(-20003, 'El nombre no debe superar los 50 caracteres');
    END IF;
    SELF.nombre := nombre;
 
    RETURN;
    END;--fin del bloque
END;--fin de la implementacion
/


/*Creación objeto LIBRO*/
CREATE OR REPLACE TYPE Libro AS OBJECT (
    id_lib INTEGER,
    titulo VARCHAR2(50),
    annio INTEGER,
    autor VARCHAR2(50),
    categoria VARCHAR2(50),
    CONSTRUCTOR FUNCTION LIBRO(
        id_lib INTEGER,
        titulo VARCHAR2,
        annio INTEGER,
        autor VARCHAR2,
        categoria VARCHAR2
    )
    RETURN SELF AS RESULT
);
/

/*implementacion*/
CREATE OR REPLACE TYPE BODY Libro AS
    CONSTRUCTOR FUNCTION Libro (
        id_lib INTEGER,
        titulo VARCHAR2,
        annio INTEGER,
        autor VARCHAR2,
        categoria VARCHAR2
    )
    RETURN SELF AS RESULT IS
    -- inicializo el CONSTRUCTOR 
    BEGIN
    SELF.id_lib := seqIdLib.NEXTVAL; -- asignamos id_secuencial

    SELF.titulo := titulo; 

    -- asignamos restriccion de Año con un IF
    IF NOT (annio BETWEEN 1900 AND 2024) THEN
        RAISE_APPLICATION_ERROR(-20004, 'El año debe ser entre 1900 y 2024');
    END IF;
    SELF.annio := annio;

    IF LENGTH (autor) > 50 THEN
        RAISE_APPLICATION_ERROR(-20005, 'El autor no debe superar los 50 caracteres');
    END IF;
    SELF.autor := autor;


    IF categoria NOT IN ('Didáctico', 'Ficción', 'Otro') THEN
        RAISE_APPLICATION_ERROR(-20005, 'La categoría debe ser "Didáctico", "Ficción" u "Otro".');
    END IF;
    SELF.categoria := categoria;-- ahora si asignamos categoria

 
 
    RETURN;
    END;--fin del bloque anonimo
END;--fin de la implementacion
/

/*Ejercicio 2: Procedimientos y Funciones con Objetos 
Crea un procedimiento en PL/SQL que tome como parámetro un objeto de tipo Estudiante e imprima en pantalla el nombre, la edad y el ciclo del estudiante.
Crea una función en PL/SQL que tome como parámetro un objeto de tipo Libro y devuelva el título y el autor del libro.
*/


/*Procedimiento con tipo-objeto*/
CREATE OR REPLACE PROCEDURE ImprimirNombre(
    infoEstudiante IN Estudiante -- Creamos variable como instancia de objeto estudiante. Después instanciamos los atributos en el bloque ↓.
) IS 
BEGIN
    DBMS_OUTPUT.PUT_LINE(' Nombre:' || infoEstudiante.nombre || ', Edad: ' || infoEstudiante.edad || ', Ciclo formativo:  ' || infoEstudiante.cicloFormativo);

END;
/

/*Función con tipo-objeto*/
CREATE OR REPLACE FUNCTION ImprimirLibro (
    infoLibro IN Libro
)
RETURN  VARCHAR2 IS
    BEGIN
        DBMS_OUTPUT.PUT_LINE('Autor:' || infoLibro.autor || ', titulo: ' || infoLibro.titulo);
    END;
/


/*Ejercicio 3: Disparadores con Objetos (Puntuación: 1,5 + 1,5 puntos) 
Crea un disparador en PL/SQL que, al insertar un nuevo objeto de tipo Estudiante en una tabla llamada Estudiantes, 
automáticamente inserte un registro en la tabla de Historial de Estudiantes con la fecha actual y el ID del estudiante.

Crea un disparador en PL/SQL que, al insertar un nuevo objeto de tipo Libro en una tabla llamada Libros, 
automáticamente actualice un contador de libros en una tabla llamada Contador_Libros.
*/


-- Crea la tabla "Estudiantes" basada en el tipo de objeto "Estudiante"
-- Se especifica que "id_es" es la clave primaria
CREATE TABLE Estudiantes OF Estudiante (
    PRIMARY KEY (id_es)
);
/

-- Crea la tabla "HistorialEstudiantes" que almacenará el historial de inserciones
-- Incluye las columnas "fecha" y "id_estudiante"
-- "id_estudiante" es una clave foránea que referencia a "id_es" en la tabla "Estudiantes"
CREATE TABLE HistorialEstudiantes (
    fecha TIMESTAMP,
    id_estudiante INTEGER,
    FOREIGN KEY (id_estudiante) REFERENCES Estudiantes(id_es)
);
/

-- Crea un disparador "insertHistorialEst"
-- Este disparador se ejecuta después de cada inserción en la tabla "Estudiantes"
CREATE OR REPLACE TRIGGER insertHistorialEst
AFTER INSERT ON Estudiantes
FOR EACH ROW
BEGIN
    -- Inserta una nueva fila en "HistorialEstudiantes" con la fecha actual y el ID del nuevo estudiante
    INSERT INTO HistorialEstudiantes (fecha, id_estudiante)
    VALUES (SYSTIMESTAMP, :NEW.id_es);
END;
/

-- Crea la tabla "Libros" basada en el tipo de objeto "Libro"
-- Se especifica que "id_lib" es la clave primaria
CREATE TABLE Libros OF Libro (
    PRIMARY KEY (id_lib)
);
/

-- Crea la tabla "Contador_Libros" que almacenará el contador de libros
CREATE  TABLE Contador_Libros (
    contador INTEGER
);
/

-- Inserta una fila inicial en "Contador_Libros" con el contador inicializado a 0
INSERT INTO Contador_Libros (contador) VALUES (0);

-- Crea un disparador "insertContadorLibros"
-- Este disparador se ejecuta después de cada inserción en la tabla "Libros"
CREATE OR REPLACE TRIGGER insertContadorLibros
AFTER INSERT ON Libros
FOR EACH ROW
BEGIN
    -- Actualiza el contador en "Contador_Libros" incrementándolo en 1
    UPDATE Contador_Libros
    SET contador = contador + 1;
END;
/