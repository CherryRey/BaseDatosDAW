/** CONSULTAS **/
 -- en sqlplus para saber que tablas tenemos:
SELECT TABLE_NAME FROM CAT;


-- 1. Obtener los nombres y salarios de los empleados con más de 1000 euros de salario por orden alfabético.
-- Aunque la consulta solo pide el nombre, quisimos probar el operador de concatenar ||
SELECT NOMBRE || ' '  || APE1 AS NOMBRE, SALARIO  FROM EMPLEADO WHERE SALARIO > 1000 ORDER BY NOMBRE;
-- CON CONCAT:
SELECT CONCAT(NOMBRE, APE1) AS NOMBRE, SALARIO FROM EMPLEADO WHERE SALARIO > 1000 ORDER BY NOMBRE;

-- 2. Obtener el nombre de los empleados cuya comisión es superior al 20% de su salario.

SELECT NOMBRE || ' '  || APE1 AS NOMBRE, SALARIO, COMISION FROM EMPLEADO WHERE COMISION > (SALARIO * 0.02 )ORDER BY NOMBRE;

/** 3. Obtener el código de empleado, código de departamento, nombre y sueldo total en pesetas de 
aquellos empleados cuyo sueldo total (salario más comisión) supera los 1800 euros. 
Presentarlos ordenados por código de departamento y dentro de éstos por orden alfabético**/

-- Hemos agregado una columna cadena de texto para indicar que son pesetas y no euros. 
SELECT CODEMPLE, CODDPTO, NOMBRE, (NVL(SALARIO+COMISION, SALARIO)* 166.386) AS SUELDOTOTAL, 'PTAS' AS MONEDA
FROM EMPLEADO WHERE NVL(SALARIO+COMISION, SALARIO) > 1800 
ORDER BY 2,3;

-- 4. Obtener por orden alfabético los nombres de empleados cuyo salario igualen o superen en más de un 5% al salario de la empleada ‘MARIA JAZMIN'
SELECT NOMBRE, SALARIO FROM EMPLEADO WHERE SALARIO >= (SELECT SALARIO * 1.05 
FROM EMPLEADO WHERE NOMBRE IN('MARIA', 'JAZMIN')) 
ORDER BY NOMBRE;

-- 5. Obtener una listado ordenado por años en la empresa con los nombres, y apellidos de los empleados y los años de antigüedad en la empresa.
SELECT NOMBRE,APE1, APE2, EXTRACT(YEAR FROM SYSDATE)- EXTRACT(YEAR FROM FECHAINGRESO) AS ANTIGUEDAD 
FROM EMPLEADO 
ORDER BY ANTIGUEDAD DESC;

-- 6. Obtener el nombre de los empleados que trabajan en un departamento con presupuesto superior a 50.000 euros. Hay que usar predicado cuantificado.
-- Usamos "ANY" para extraer por medio de una subconsulta cualquier departamento que tenga un presupuesto de más de 50000.
SELECT NOMBRE 
FROM EMPLEADO 
WHERE CODDPTO = ANY(SELECT CODDPTO FROM DPTO WHERE PRESUPUESTO > 50000);

--7. Obtener los nombres y apellidos de empleados que más cobran en la empresa.Considerar el salario más la comisión
--Usamos la función NVL, similar a COALESCE en otros SGBD. NVL funciona bien cuando tenemos campos nulos, en este caso en COMISION.
--También usamos ROWNUM para reducir las entradas. Una especie de SELECT TOP
SELECT NOMBRE, APE1,APE2 
FROM EMPLEADO 
WHERE ROWNUM <=5 
ORDER BY NVL(SALARIO+COMISION,SALARIO) DESC;

--8. Obtener en orden alfabético los nombres de empleado cuyo salario es inferior al mínimo de los empleados del departamento 1.
--Usamos la funcion de agregado MIN en la subconsulta.
SELECT NOMBRE, APE1, APE2, SALARIO 
FROM EMPLEADO WHERE SALARIO < (SELECT MIN(SALARIO) FROM EMPLEADO WHERE CODDPTO = 1);

--9. Obtener los nombre de empleados que trabajan en el departamento del cuál es jefe el empleado con código 1.
SELECT NOMBRE, APE1, APE2 
FROM EMPLEADO WHERE CODDPTO = (SELECT CODDPTO FROM DPTO WHERE CODEMPLEJEFE = 1);

--10. Obtener los nombres de los empleados cuyo primer apellido empiece por las letras p, q, r, s.
--Usamos LIKE e indicamos la primera letra que deseabamos buscar.
SELECT NOMBRE, APE1, APE2 
FROM EMPLEADO WHERE APE1 LIKE 'P%' OR APE1 LIKE 'Q%' OR APE1 LIKE 'S%' OR APE1 LIKE 'R%';

--11. Obtener los empleados cuyo nombre de pila contenga el nombre JUAN
SELECT * 
FROM EMPLEADO WHERE NOMBRE IN ('JUAN');

--12. Obtener los nombres de los empleados que viven en ciudades en las que hay algún centro de trabajo
--Usamos UPPER() pues los valores de la tabla de CENTRO y los valores de la tabla EMPLEADOS estaban en Mayúsculas y Minúsculas.
--También usamos un JOIN.
SELECT e.NOMBRE, e.LOCALIDAD 
FROM EMPLEADO e JOIN CENTRO c ON UPPER(e.LOCALIDAD) = UPPER(c.LOCALIDAD);

--13. Obtener el nombre del jefe de departamento que tiene mayor salario de entre los jefes de departamento.
-- En este caso Solo hace mención al salario Y NO A LAS COMISIONES por lo que la  consulta devuelve dos valores
SELECT d.codemplejefe, e.NOMBRE, e.salario 
FROM EMPLEADO e 
INNER JOIN DPTO d 
ON d.CODEMPLEJEFE= e.CODEMPLE 
WHERE e.salario >= ALL(SELECT MAX(SALARIO) FROM EMPLEADO);

-- 14. Obtener en orden alfabético los salarios y nombres de los empleados cuyo salario sea superior al 60% del máximo salario de la empresa.
SELECT NOMBRE, SALARIO 
FROM EMPLEADO WHERE SALARIO > (SELECT MAX(SALARIO) * 0.6 FROM EMPLEADO) ORDER BY NOMBRE;


--15. Obtener en cuántas ciudades distintas viven los empleados
SELECT COUNT (DISTINCT LOCALIDAD) AS DISTLOCALIDADES FROM EMPLEADO;

--16. El nombre y apellidos del empleado que más salario cobra.
SELECT NOMBRE||' '|| APE1|| ' ' ||APE2 AS EMPLEADOSMAYORSALARIO, SALARIO 
FROM EMPLEADO WHERE SALARIO >= ALL (SELECT(SALARIO) FROM EMPLEADO);

--17. Obtener las localidades y número de empleados de aquellas en las que viven más de 3 empleados.
--Usamos un HAVING para contar aquellas entradas con más de tres empleados.
SELECT LOCALIDAD, COUNT(*) AS NUMEPLEADOS 
FROM EMPLEADO GROUP BY LOCALIDAD HAVING COUNT(*) > 3;

/**18. Obtener para cada departamento cuántos empleados trabajan, 
la suma de sus salarios y la suma de sus comisiones para aquellos departamentos 
en los que hay algún empleado cuyo salario es superior a 1700 euros.**/
-- Usamos un JOIN USING para obtener el Nombre del departamento y que fuese más claro.
-- Aqui WHERE buscará en una subconsulta los empleados con un salario superior a 1700 euros
SELECT DPTO.DENOMINACION AS DPTO, COUNT(EMPLEADO.NOMBRE) AS NUMEMPLEADOS, SUM(EMPLEADO.SALARIO) SALARIOTOTAL, SUM(NVL(COMISION, 0)) COMISIONTOTAL
FROM EMPLEADO
JOIN DPTO USING (CODDPTO)
WHERE CODDPTO IN (SELECT CODDPTO FROM EMPLEADO WHERE SALARIO > 1700 ) GROUP BY DPTO.DENOMINACION;

--19. Obtener el departamento que más empleados tiene.
SELECT DPTO.DENOMINACION, COUNT(EMPLEADO.NOMBRE) AS NUMEMPLEADOS
FROM EMPLEADO
JOIN DPTO USING (CODDPTO)
GROUP BY DPTO.DENOMINACION
HAVING COUNT(*) > 1
ORDER BY NUMEMPLEADOS DESC
FETCH FIRST 1 ROW ONLY; -- para que solo nos muestre el dpto con mas empleados

--20. Obtener los nombres de todos los centros y los departamentos que se ubican en cada uno,así como aquellos centros que no tienen departamentos.
-- usamos LEFT JOIN para que en el caso de que un centro no tenga departamentos igualmente aparezca.PAREZCA.
SELECT C.CODCENTRO, C.DIRECCION AS NOMBRECENTRO, D.CODDPTO, D.DENOMINACION AS DEPARTAMENTO
FROM CENTRO C
LEFT JOIN DPTO D
ON C.CODCENTRO= D.CODCENTRO;
--21. Obtener el nombre del departamento de más alto nivel, es decir, aquel que no depende de ningún otro.
-- utilizamos un is null en la columna codptodepende que indica el codigo de dependencia de un dpto-
SELECT CODDPTO, DENOMINACION 
FROM DPTO 
WHERE CODDPTODEPENDE IS NULL;

--22. Obtener todos los departamentos existentes en la empresa y los empleados (si los tiene) que pertenecen a él.
--  Nuevamente usamos left join porque si un departamento no tiene empleados asi nos puede aparecer
SELECT D.DENOMINACION, E.NOMBRE, E.APE1, E.APE2
FROM DPTO D
LEFT JOIN EMPLEADO E
ON E.CODDPTO=D.CODDPTO;

--23. Obtener un listado en el que aparezcan todos los departamentos existentes y el departamento del cual depende,si depende de alguno.
SELECT CODDPTO,DENOMINACION,CODDPTODEPENDE 
FROM DPTO;

/**24. Obtener un listado ordenado alfabéticamente donde aparezcan los nombres de los empleados 
y a continuación el literal "tiene comisión" si la tiene,y "no tiene comisión" si no la tiene.**/

-- usamos DECODE para evaluar dos expresiones:
SELECT NOMBRE, APE1, DECODE( COMISION, NULL, 'No tiene comision', 'Tiene comision') 
FROM EMPLEADO ORDER BY NOMBRE;

--25. Obtener un listado de las localidades en las que hay centros y no vive ningún empleado ordenado alfabéticamente.
-- Nos sale una tabla vacía porque en todos los centros hay un empleado trabajando en la localidad donde hay un centro.
--También hemos usado UPPER debido a la discrepancia de mayusculas y minusculas en ambas tablas
SELECT LOCALIDAD
FROM CENTRO
WHERE UPPER(LOCALIDAD) NOT IN (SELECT UPPER(LOCALIDAD) FROM EMPLEADO) ORDER BY LOCALIDAD ASC;

--26. Obtener un listado de las localidades en las que hay centros y además vive al menos un empleado ordenado alfabéticamente.
-- SI NO HAY EMPLEADO NO APARECE EN EL JOIN.
SELECT  DISTINCT C.LOCALIDAD, COUNT(E.NOMBRE) AS NUMEMPLEADOS
FROM CENTRO C
JOIN EMPLEADO E
ON UPPER(E.LOCALIDAD) = UPPER(C.LOCALIDAD)
WHERE UPPER(C.LOCALIDAD) IN (SELECT UPPER(E.LOCALIDAD) FROM EMPLEADO)
GROUP BY C.LOCALIDAD
ORDER BY C.LOCALIDAD ASC;

/**27. Esta cuestión puntúa por 2. Se desea dar una gratificación por navidades en función de la antigüedad en la empresa siguiendo estas pautas:
Si lleva entre 1 y 5 años, se le dará 100 euros
Si lleva entre 6 y 10 años, se le dará 50 euros por año
Si lleva entre 11 y 20 años, se le dará 70 euros por año
Si lleva más de 21 años, se le dará 100 euros por año
**/

-- Use un CASE WHEN aunque aun no se ha tratado en la unidad. Debido a que hay que evaluar muchas expresiones, pensé que serái lo más correcto
SELECT EXTRACT(YEAR FROM SYSDATE)- EXTRACT(YEAR FROM FECHAINGRESO) AS ANTIGUEDAD , CASE 
    WHEN  EXTRACT(YEAR FROM SYSDATE)- EXTRACT(YEAR FROM FECHAINGRESO) BETWEEN 1 AND 5 
    THEN 100
    WHEN  EXTRACT(YEAR FROM SYSDATE)- EXTRACT(YEAR FROM FECHAINGRESO) BETWEEN 6 AND 10 
    THEN 50 * (EXTRACT(YEAR FROM SYSDATE)- EXTRACT(YEAR FROM FECHAINGRESO))
    WHEN  EXTRACT(YEAR FROM SYSDATE)- EXTRACT(YEAR FROM FECHAINGRESO) BETWEEN 11 AND 20 
    THEN 70 * (EXTRACT(YEAR FROM SYSDATE)- EXTRACT(YEAR FROM FECHAINGRESO))
    WHEN  EXTRACT(YEAR FROM SYSDATE)- EXTRACT(YEAR FROM FECHAINGRESO) >= 21
    THEN 100 * (EXTRACT(YEAR FROM SYSDATE)- EXTRACT(YEAR FROM FECHAINGRESO))
END AS GRATIFICACION, FECHAINGRESO
FROM EMPLEADO 
ORDER BY ANTIGUEDAD DESC;

--28. Obtener un listado de los empleados,ordenado alfabéticamente,indicando cuánto le corresponde de gratificación.
SELECT NOMBRE,APE1, APE2, EXTRACT(YEAR FROM SYSDATE)- EXTRACT(YEAR FROM FECHAINGRESO) AS ANTIGUEDAD , FECHAINGRESO,
CASE 
    WHEN  EXTRACT(YEAR FROM SYSDATE)- EXTRACT(YEAR FROM FECHAINGRESO) BETWEEN 1 AND 5 
    THEN 100
    WHEN  EXTRACT(YEAR FROM SYSDATE)- EXTRACT(YEAR FROM FECHAINGRESO) BETWEEN 6 AND 10 
    THEN 50 * (EXTRACT(YEAR FROM SYSDATE)- EXTRACT(YEAR FROM FECHAINGRESO))
    WHEN  EXTRACT(YEAR FROM SYSDATE)- EXTRACT(YEAR FROM FECHAINGRESO) BETWEEN 11 AND 20 
    THEN 70 * (EXTRACT(YEAR FROM SYSDATE)- EXTRACT(YEAR FROM FECHAINGRESO))
    WHEN  EXTRACT(YEAR FROM SYSDATE)- EXTRACT(YEAR FROM FECHAINGRESO) >= 21
    THEN 100 * (EXTRACT(YEAR FROM SYSDATE)- EXTRACT(YEAR FROM FECHAINGRESO))
END AS GRATIFICACION 
FROM EMPLEADO 
ORDER BY NOMBRE;

--29. Obtener a los nombres, apellidos de los empleados que no son jefes de departamento.
--Usamos un NOT IN
SELECT CODEMPLE, NOMBRE, APE1, APE2
FROM EMPLEADO
WHERE CODEMPLE NOT IN(SELECT CODEMPLEJEFE FROM DPTO);




