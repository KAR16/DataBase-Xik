CREATE OR REPLACE TRIGGER INSERTCARGO 
AFTER INSERT ON PLAN_PAGO 

DECLARE 
IDPlanPago INT := (:NEW.Plan_Pago); Monto INT := 0; NoCuotas INT := 0; Cuota INT := 0; Fecha VARCHAR(10); Cont INT := 1;
Mes INT := 0; Anio INT := 0;

--FINAL DECLARE
BEGIN
--AQUI OBTENEMOS EL MONTO A PAGAR
Monto := (:NEW.Monto);

--AQUI OBTENEMOS EL No. DE CUOTAS A PAGAR
NoCuotas := (:NEW.Cuotas);

--AQUI OBTENEMOS EL MONTO A PAGAR POR CUOTA
Cuota := (Monto / NoCuotas);
--HACEMOS LA OPERACION PARA LA FECHA

Anio := (select to_char(sysdate,'YYYY') from dual); 
Mes := (select to_char(sysdate,'MM') from dual);
Fecha := CONTACT(Anio, '/', (Mes + 1), '/05');

--AHORA INSERTAMOS EN CARGOS LAS CUOTAS
INSERT INTO Cargo
VALUES(Cont, (:NEW.Carne), (:NEW.Fecha_Transaccion),
Cuota, Cuota, Fecha, CONCAT('Cuota ', Cont));


--ACA INICIAMOS EL WHILE PARA TERMINAR DE INSERTAR LAS CUTOAS RESTANTES
WHILE (Cont < NoCuotas)
BEGIN

--AQUI MODIFICAMOS LAS FECHAS DE TRANSACCION Y VENCIMIENTO PARA LAS CUOTAS
DECLARE Fecha_Transaccion DATE := CONCAT(Anio, '/', (Mes + Cont), '/06');
DECLARE Fecha_Vencimiento DATE := CONCAT(Anio, '/', ((Mes + 1)+ Cont), '/05');

INSERT INTO Cargo 
VALUES(Cont, (:NEW.Carne), Fecha_Transaccion, Cuota, Cuota, Fecha_Vencimiento, CONCAT('Cuota', Cont));
SET Cont += 1; --AQUI INCREMENTAMOS EL VALOR DEL LOOP DE 1-1
END
  NULL;
END;

