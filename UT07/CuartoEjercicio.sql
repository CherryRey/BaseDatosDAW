
/*4. Crea un tabla TablaResponsables de objetos Responsable. Inserta en dicha tabla dos objetos  Responsable. 
El segundo objeto "Responsable" debes crearlo usando el método constructor que has realizado anteriormente.*/

-- Por si acaso, borramos el VARRAY
DROP TABLE TablaResponsable; 

-- Creamos o reemplazamos la tabla TablaResponsable con los objetos del tipo Responsable
CREATE OR REPLACE TABLE TablaResponsable OF Responsable;
/ -- Se cierra el bloque

BEGIN
    -- Insertamos el primer objeto en la tabla TablaResponsable
    INSERT INTO TablaResponsable VALUES (Responsable(5, '51083099F', 'Elena', 'Posta Llanos', 'F', '31-03-1975', 'N', 4));

    -- Insertamos el segundo objeto utilizando el MÉTODO CONSTRUCTOR.
    -- Para ello, utilizamos "NEW" para llamar a dicho método y luego lo insertamos en la tabla.
    INSERT INTO TablaResponsable VALUES (NEW Responsable(6, 'Javier', 'Jaramillo', 'Hernandez', 'C'));
END;
/
