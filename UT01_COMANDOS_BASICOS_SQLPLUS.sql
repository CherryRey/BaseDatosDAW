-- COMANDOS BÁSICOS EN SQL PLUS (CMD)

-- CREANDO USUARIO
-- Creando usuario “turron” para hacer pruebas.
-- Entramos en cmd y ejecutamos la siguiente línea:

sqlplus sys as sysdba

-- Damos la contraseña de Administrador.

-- Creamos usuario “turron”
create user c##turron identified by turron default tablespace users;

-- (Sintaxis: create user c##usuario identified by contraseña default tablespace users;)

-- Le concedemos los permisos para poder trabajar
grant GRANT DBA TO C##turron;

-- o
grant connect resource DBA to c##turron;

-- Y nos conectamos
connect c##turron/turron;

-- CONSULTANDO USUARIOS CREADOS
select * from all_user;

-- ELIMINAR USUARIO
DROP USER c##usuario CASCADE;

-- ¿CÓMO EJECUTAR UN SCRIPT?
-- Primero conectas con el usuario 
connect c##tu_usuario/tu_password_de_usuario

-- Después ejecutas:
@c:\direccion\ruta\del\archivo.sql

-- o
start c:/ruta/script.sql

-- VER LAS TABLAS
-- Puedes ver las tablas con 
select table_name from cat;

-- (cat es la abreviatura de catálogo)

-- SABER LAS TABLAS DE TU USUARIO
-- Una vez conectada a mi <usuario> ejecuto la siguiente línea tal cual:
select table_name from user_tables order by table_name;

-- similar (tal cual):
select table_name from cat;

-- VER EL CONTENIDO (COLUMNAS Y TIPO DE DATOS) DE UNA TABLA
describe nombre_de_tu_tabla;

-- o
desc nombre_de_tu_tabla;

