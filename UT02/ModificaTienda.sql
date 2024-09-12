/*EJERCICIO 2:
A)  Modificar las tablas creadas en el ejercicio anterior siguiendo las indicaciones. 
*/

--Tabla STOCK:
--Una columna de tipo fecha llamada FechaUltimaEntrada Default fecha actual

ALTER TABLE STOCK ADD(
FechaUltima DATE default SYSDATE);

--Una columna llamada Beneficio
ALTER TABLE STOCK ADD(
Beneficio NUMBER (1) CONSTRAINT bn_chk CHECK(Beneficio BETWEEN 1 AND 5)
);

--Tabla PRODUCTO
--- Eliminar de la tabla producto la columna Descripción
ALTER TABLE PRODUCTO DROP COLUMN Descripcion;

--Añadir una columna llamada perecedero que únicamente acepte los valores: S o N
ALTER TABLE PRODUCTO ADD(
Perecedero CHAR(1) CONSTRAINT pc_chk CHECK(Perecedero IN('S','N'))
);

--Modificar el tamaño de la columna Denoproducto a 50
ALTER TABLE PRODUCTO MODIFY(
Denoproducto CHAR(50));

--Tabla FAMILIA
--Añadir columna IVA y solo pueda contener los valores 21,10,ó 4.

ALTER TABLE FAMILIA ADD(
IVA NUMBER(2) CONSTRAINT iva_chk CHECK(iva IN (21,10,4))
);

--Tabla TIENDA
--Restringir a una sola tienda en un Código Postal
ALTER TABLE TIENDA ADD CONSTRAINT cp_chk UNIQUE(CodigoPostal);



-- B)Renombra la tabla STOCK por PRODXTIENDAS

RENAME STOCK TO PRODXTIENDAS;

--C) Elimina la tabla FAMILIA y su contenido si lo tuviera.

--Eliminar contenido
DELETE FROM FAMILIA;
--Eliminar la constraint FK
ALTER TABLE PRODUCTO DROP CONSTRAINT cod_fm_fk; 
--Eliminar la tabla
DROP TABLE FAMILIA; 

--D) Crea un usuario llamado C##INVITADO con todos los privilegios sobre la tabla PRODUCTO
CREATE USER c##invitado IDENTIFIED BY invitado;
GRANT CONNECT TO c##invitado;
GRANT CREATE SESSION TO c##invitado;
--Privilegios
GRANT ALL ON PRODUCTO TO c##invitado;

--E) Retira los permisos de modificar (ALTER) la estructura de la tabla 
--borrar contenido (DELETE) de la tabla PRODUCTO al usuario anterior.

REVOKE ALTER, DELETE ON PRODUCTO FROM c##invitado; 
