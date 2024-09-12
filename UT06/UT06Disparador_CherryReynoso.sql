--Creamos un disparador con CREATE OR REPLACE TRIGGER para aplicar restricciones en la tabla agentes
CREATE OR REPLACE TRIGGER AgenteRestriccion
BEFORE INSERT OR UPDATE ON agentes
FOR EACH ROW 

BEGIN
    -- Longitud de la clave de un agente no puede ser inferior a 6 carácteres. Usamos LENGTH 
    IF LENGTH (:new.clave) <6 THEN
        RAISE_APPLICATION_ERROR(-20102, 'La longitud de la clave del agente no puede ser inferior a 6');
    END IF;

    -- La habilidad debe estar entre 0 y 9 (ambos inclusive) si no es así, alzaremos un error.
    IF :new.habilidad NOT BETWEEN 0 AND 9 THEN
        RAISE_APPLICATION_ERROR(-20103, 'La habilidad debe estar comprendida entre 0 y 9(ambos inclusive)');
    END IF;

    --La categoría de un agente sólo puede ser igual a 0, 1 o 2
    IF :new.categoria NOT IN (0,1,2) THEN
        RAISE_APPLICATION_ERROR(-20104, 'La categoría de un agente sólo puede ser igual a 0, 1 o 2');
    END IF;

    -- Si un agente tiene categoría 2 no puede pertenecer a ninguna familia y DEBE pertenecer a una oficina.  
    IF (:new.categoria = 2 AND :new.familia IS NOT NULL) OR (:new.categoria = 2 AND :new.oficina IS NULL) THEN
        RAISE_APPLICATION_ERROR(-20105, 'Un agente con categoría 2 no puede pertenecer a ninguna familia y debe pertenecer a una oficina.');
    END IF;

    --Si un agente tiene categoría 1 no puede pertenecer a ninguna oficina y DEBE pertenecer  a una familia
    IF (:new.categoria = 1 AND :new.familia IS NULL) OR (:new.categoria = 1 AND :new.oficina IS NOT NULL) THEN
        RAISE_APPLICATION_ERROR(-20106, 'Un agente con categoría 1 no puede pertenecer a ninguna oficina y debe pertenecer a una familia.');
    END IF;

    -- Todos los agentes deben pertenecer  a una oficina o a una familia pero nunca a ambas a la vez, si no cumple lanza un error.
    IF (:new.familia IS NOT NULL AND :new.oficina IS NOT NULL) OR (:new.familia IS NULL AND :new.oficina IS NULL) THEN
        RAISE_APPLICATION_ERROR(-20107, 'Todos los agentes deben pertenecer a una oficina o a una familia pero nunca a ambas a la vez');
    END IF;
END;
/