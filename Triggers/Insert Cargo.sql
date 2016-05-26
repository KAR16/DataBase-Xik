/*DETALLE TRIGGER 1:
Crear un trigger que después de inserte una tupla en la tabla PLAN_PAGO 
inserte en la tabla CARGO de la siguiente forma:

* Debe insertar un número de cargos igual a la cantidad insertada en el campo CUOTAS en la tabla PLAN_PAGO.

* La descripción de cada cargo debe tener la palabra CUOTA seguida de un numero indicando el número de cuota (ejemplo CUOTA 1).

* La fecha_transacción del primer cargo debe ser la insertada en el campo FECHA_APLICACION de la tabla PLAN_PAGO, 
  la fecha_transaccion de los cargos siguientes debe ser un dia siguiente de la fecha_vencimiento del cargo anterior.

* La fecha_vencimiento de cada cargo debe ser 30 dias despues a la fecha_transaccion del cargo.

* El monto de cada cargo debe ser el (MONTO del PLAN_PAGO )/(CUOTAS del PLAN_PAGO).

* El SALDO del cargo debe ser el MONTO del cargo
*/


CREATE OR REPLACE TRIGGER INSERTCARGO 
AFTER INSERT ON PLAN_PAGO
FOR EACH ROW
DECLARE 
IDPlanPago INT := (:NEW.Plan_Pago); Monto INT := 0; NoCuotas INT := 0; Cuota INT := 0; Fecha DATE; 
Fecha_Final DATE; Cont INT := 1;
Mes INT := 0; Anio INT := 0;
Fecha_Transaccion DATE;
Fecha_Vencimiento DATE;

--FINAL DECLARE
BEGIN
--AQUI OBTENEMOS EL MONTO A PAGAR
Monto := (:NEW.Monto);

--AQUI OBTENEMOS EL No. DE CUOTAS A PAGAR
NoCuotas := (:NEW.Cuotas);

--AQUI OBTENEMOS EL MONTO A PAGAR POR CUOTA
Cuota := (Monto / NoCuotas);

--HACEMOS LA OPERACION PARA LA FECHA
Anio := (EXTRACT(YEAR FROM SYSDATE));

--Fecha_Final := TO_DATE(Fecha, 'YYYY/MON/DD');
Mes := (EXTRACT(MONTH FROM SYSDATE));

  IF (Mes) <= 9 THEN
  Fecha := TO_DATE(Anio|| '/0' || (Mes + 1) || '/05', 'YYYY/MM/DD');
  ELSE
  Fecha := TO_DATE(Anio|| '/' || (Mes + 1) || '/05', 'YYYY/MM/DD');
  END IF;

--AHORA INSERTAMOS EN CARGOS LAS CUOTAS
INSERT INTO Cargo
VALUES(cont_usercargo.NEXTVAL, (:NEW.Carne), (:NEW.Fecha_Aplicacion), Cuota, Cuota, Fecha, ('Cuota ' || Cont));

--ACA INICIAMOS EL WHILE PARA TERMINAR DE INSERTAR LAS CUTOAS RESTANTES
WHILE (Cont < NoCuotas) LOOP
--AQUI MODIFICAMOS LAS FECHAS DE TRANSACCION Y VENCIMIENTO PARA LAS CUOTAS
Mes:= Mes + 1;

IF Mes > 12 THEN
    Mes := 1;
    Anio:= Anio + 1;
    IF (Mes + Cont) <= 9 THEN
    Fecha_Transaccion := TO_DATE(Anio || '/0' || (Mes)|| '/06', 'YYYY/MM/DD' );
    ELSE
    Fecha_Transaccion := TO_DATE(Anio || '/' || (Mes )|| '/06', 'YYYY/MM/DD' );
    END IF;
ELSE
    IF (Mes) <= 9 THEN
    Fecha_Transaccion := TO_DATE(Anio || '/0' || (Mes)|| '/06', 'YYYY/MM/DD' );
    ELSE
    Fecha_Transaccion := TO_DATE(Anio || '/' || (Mes)|| '/06', 'YYYY/MM/DD' );
    END IF;
END IF;


IF (EXTRACT(MONTH FROM Fecha_Transaccion)) >= 12 THEN
    Mes := 0;
    Anio:= Anio + 1 ;
    IF (Mes + Cont + 1)<=9 THEN
    Fecha_Vencimiento := TO_DATE(Anio || '/0' || (Mes + 1) || '/05', 'YYYY/MM/DD');
    ELSE
    Fecha_Vencimiento := TO_DATE(Anio || '/' || (Mes + 1) || '/05', 'YYYY/MM/DD');
    END IF;
ELSE
    IF (Mes + Cont + 1)<=9 THEN
    Fecha_Vencimiento := TO_DATE(Anio || '/0' || (Mes + 1) || '/05', 'YYYY/MM/DD');
    ELSE
    Fecha_Vencimiento := TO_DATE(Anio || '/' || (Mes + 1) || '/05', 'YYYY/MM/DD');
    END IF;
END IF;

Cont := Cont + 1; --AQUI INCREMENTAMOS EL VALOR DEL LOOP DE 1-1
INSERT INTO Cargo 
VALUES(cont_usercargo.NEXTVAL, (:NEW.Carne), Fecha_Transaccion, Cuota, Cuota, Fecha_Vencimiento, ('Cuota ' || Cont));
END LOOP;
  NULL;
END;