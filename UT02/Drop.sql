ALTER TABLE PRODUCTO DROP CONSTRAINT cod_fm_fk;
ALTER TABLE FAMILIA DROP CONSTRAINT cod_fm_pk;
DROP TABLE FAMILIA;

ALTER TABLE STOCK DROP CONSTRAINT cod_shop_fk;
ALTER TABLE STOCK DROP CONSTRAINT cod_pr_fk;
ALTER TABLE PRODUCTO DROP CONSTRAINT cod_pr_pk;
ALTER TABLE TIENDA DROP CONSTRAINT cod_shop_pk;

DROP TABLE STOCK;
DROP TABLE TIENDA;
DROP TABLE PRODUCTO;
----

ALTER TABLE PRODXTIENDAS DROP CONSTRAINT cod_shop_fk;
ALTER TABLE PRODXTIENDAS DROP CONSTRAINT cod_pr_fk;
ALTER TABLE PRODUCTO DROP CONSTRAINT cod_pr_pk;
ALTER TABLE TIENDA DROP CONSTRAINT cod_shop_pk;

DROP TABLE PRODXTIENDAS;
DROP TABLE TIENDA;
DROP TABLE PRODUCTO;