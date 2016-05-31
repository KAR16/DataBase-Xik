/*DETALLE DEL TRIGGER 2:
Crear un trigger que después de que se inserte en la tabla de pagos debe aplicar 
el pago actualizando el saldo de cada cobro en orden de fecha de vencimiento del más 
antiguo al más reciente aplicando el pago completo, para este se debe insertar en la 
tabla PAGO_CARGO la relación entre PAGO Y CARGO, relacionando el pago realizado con el cargo pagado.
*/

CREATE OR REPLACE TRIGGER INSERT_AND_UPDATE 
AFTER INSERT ON PAGO
FOR EACH ROW
DECLARE
CURSOR CURCargoEstudiante IS
SELECT CARGO, CARNE, MONTO, SALDO, FECHA_VENCIMIENTO, DESCRIPCION 
FROM CARGO 
WHERE CARNE = (:NEW.CARNE)
ORDER BY FECHA_VENCIMIENTO ASC AND CARGO;

PAGO INT;
RESULTADO INT;
--FIN DECLARE

BEGIN
PAGO:= (:NEW.MONTO);
FOR Iteracion IN CURCargoEstudiante
LOOP
 IF (PAGO > 0) THEN
    IF (PAGO <= Iteracion.SALDO) THEN
        RESULTADO := Iteracion.SALDO - PAGO;
        --UPDATE ENTIDAD CARGO
        UPDATE CARGO
        SET SALDO = RESULTADO
        WHERE CARGO = Iteracion.CARGO AND FECHA_VENCIMIENTO = Iteracion.FECHA_VENCIMIENTO;
        
        --INSERT ENTIDAD PAGO_CARGO
        INSERT INTO PAGO_CARGO
        VALUES(SECIdPC.NEXTVAL, :NEW.PAGO, Iteracion.CARGO, PAGO);
    ELSE
        --UPDATE ENTIDAD CARGO
        UPDATE CARGO
        SET SALDO = 0
        WHERE CARGO = Iteracion.CARGO AND FECHA_VENCIMIENTO = Iteracion.FECHA_VENCIMIENTO;
        
        --INSERT ENTIDAD PAGO_CARGO
        INSERT INTO PAGO_CARGO
        VALUES(SECIdPC.NEXTVAL, :NEW.PAGO, Iteracion.CARGO, Iteracion.SALDO);
    END IF;
PAGO := PAGO - Iteracion.SALDO;
ELSE
    EXIT WHEN PAGO <= 0;
END IF;
END LOOP;
  NULL;
END;