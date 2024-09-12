/*EJERCICIO 1: Vamos a crear las tablas para una tienda virtual que distribuye productos agrupados en familias en varias tiendas*/

--Creando la tabla FAMILIA 
--Contiene las familias a las que pertenecen los productos,como por ejemplo ordenadores, impresoras,etc.
CREATE TABLE FAMILIA(
Codfamilia NUMBER(3) CONSTRAINT cod_fm_pk PRIMARY KEY, 
Denofamilia CHAR(50) CONSTRAINT den_fm_nn NOT NULL UNIQUE 
);

--Creando tabla Producto. Contendrá información general sobre los productos que distribuye la empresa a las tiendas.
CREATE TABLE PRODUCTO(
Codproducto NUMBER(5) CONSTRAINT cod_pr_pk PRIMARY KEY,
Denoproducto CHAR(20) CONSTRAINT dn_pr_nn NOT NULL,
Descripcion CHAR(100),
PrecioBase NUMBER(3,0) CONSTRAINT pr_bs_chk CHECK(PrecioBase >0) NOT NULL,
UnidadesMinimas NUMBER(4) CONSTRAINT uu_min CHECK(UnidadesMinimas >0) NOT NULL,
Codfamilia NUMBER (3) CONSTRAINT cod_fm_fk REFERENCES FAMILIA NOT NULL
);

-- Creando tabla Tienda. Contendrá información básica sobre las tiendas que distribuyen los productos.
CREATE TABLE TIENDA(
Codtienda NUMBER(3) CONSTRAINT cod_shop_pk PRIMARY KEY,
Denotienda NUMBER (20) CONSTRAINT dn_shop_nn NOT NULL,
Telefono CHAR(11),
CodigoPostal CHAR(5) CONSTRAINT cp_nn NOT NULL,
Provincia CHAR(5) CONSTRAINT prov_nn NOT NULL
);

--Creando tabla Stock. Contendrá para cada tienda el número de unidades disponibles de cada producto. 
--La clave primaria está formada por la concatenación de los campos Codtienda y Codproducto.
CREATE TABLE STOCK(
Codtienda NUMBER(3) CONSTRAINT cod_shop_fk REFERENCES TIENDA NOT NULL,
Codproducto NUMBER(5) CONSTRAINT cod_pr_fk REFERENCES PRODUCTO NOT NULL,
Unidades NUMBER(6) CONSTRAINT uu__nn_chk CHECK(Unidades >=0) NOT NULL,
CONSTRAINT cod_shop_pr_pk PRIMARY KEY (Codtienda, Codproducto)
);

