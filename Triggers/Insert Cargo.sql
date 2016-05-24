CREATE OR REPLACE TRIGGER INSERTCARGO 
AFTER INSERT ON PLAN_PAGO 

DECLARE 
IDPlanPago INT := (:NEW.Plan_Pago); Monto INT := 0; NoCuotas INT := 0; Cuota INT := 0; Fecha VARCHAR(10); Cont INT := 1;
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
Mes := (EXTRACT(MONTH FROM SYSDATE));
Fecha := CONTACT(Anio, '/', (Mes + 1), '/05');

--AHORA INSERTAMOS EN CARGOS LAS CUOTAS
INSERT INTO Cargo
VALUES(Cont, (:NEW.Carne), (:NEW.Fecha_Transaccion),
Cuota, Cuota, Fecha, CONCAT('Cuota ', Cont));


--ACA INICIAMOS EL WHILE PARA TERMINAR DE INSERTAR LAS CUTOAS RESTANTES
WHILE (Cont < (NoCuotas - 1))
LOOP
--AQUI MODIFICAMOS LAS FECHAS DE TRANSACCION Y VENCIMIENTO PARA LAS CUOTAS
Fecha_Transaccion := CONCAT(Anio, '/', (Mes + Cont), '/06');
Fecha_Vencimiento := CONCAT(Anio, '/', ((Mes + 1)+ Cont), '/05');

INSERT INTO Cargo 
VALUES(Cont, (:NEW.Carne), Fecha_Transaccion, Cuota, Cuota, Fecha_Vencimiento, CONCAT('Cuota', Cont));
Cont := Cont + 1; --AQUI INCREMENTAMOS EL VALOR DEL LOOP DE 1-1
END LOOP;
  NULL;
END;
