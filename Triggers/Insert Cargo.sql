CREATE or REPLACE TRIGGER INSERTCARGO 
AFTER INSERT ON PLAN_PAGO
FOR EACH ROW
DECLARE 
IDPlanPago INT := (:NEW.Plan_Pago); Monto INT := 0; NoCuotas INT := 0; Cuota INT := 0; Fecha DATE; 
Fecha_Final DATE; Cont INT := 1;
Mes INT := 0; Anio INT := 0;
Fecha_Transaccion DATE;
Fecha_Vencimiento DATE;
ContAnio INT := 1;

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
IF Mes > 12 THEN
    Mes := 1;
    Anio:= Anio + ContAnio;
    IF (Mes + 1) <= 9 THEN
    Fecha := TO_DATE(Anio|| '/0' || (Mes + 1) || '/05', 'YYYY/MM/DD');
    ELSE
    Fecha := TO_DATE(Anio|| '/' || (Mes + 1) || '/05', 'YYYY/MM/DD');
    END IF;
ELSE
    IF (Mes + 1 )<= 9 THEN
    Fecha := TO_DATE(Anio|| '/0' || (Mes + 1) || '/05', 'YYYY/MM/DD');
    ELSE
    Fecha := TO_DATE(Anio|| '/' || (Mes + 1) || '/05', 'YYYY/MM/DD');
    END IF;
END IF;

--AHORA INSERTAMOS EN CARGOS LAS CUOTAS
INSERT INTO Cargo
VALUES(cont_usercargo.NEXTVAL, (:NEW.Carne), (:NEW.Fecha_Aplicacion), Cuota, Cuota, Fecha, ('Cuota ' || Cont));


--ACA INICIAMOS EL WHILE PARA TERMINAR DE INSERTAR LAS CUTOAS RESTANTES
WHILE (Cont < NoCuotas) LOOP
--AQUI MODIFICAMOS LAS FECHAS DE TRANSACCION Y VENCIMIENTO PARA LAS CUOTAS
IF Mes > 12 THEN
    Mes := 1;
    Anio:= Anio + ContAnio;
    IF (Mes + Cont) <= 9 THEN
    Fecha_Transaccion := TO_DATE(Anio || '/0' || (Mes + Cont)|| '/06', 'YYYY/MM/DD' );
    ELSE
    Fecha_Transaccion := TO_DATE(Anio || '/' || (Mes + Cont)|| '/06', 'YYYY/MM/DD' );
    END IF;
    ContAnio := ContAnio + 1;
ELSE
    IF (Mes + Cont) <= 9 THEN
    Fecha_Transaccion := TO_DATE(Anio || '/0' || (Mes + Cont)|| '/06', 'YYYY/MM/DD' );
    ELSE
    Fecha_Transaccion := TO_DATE(Anio || '/' || (Mes + Cont)|| '/06', 'YYYY/MM/DD' );
    END IF;
END IF;


IF Mes > 12 THEN
    Mes := 1;
    Anio:= Anio + ContAnio;
    IF (Mes + Cont + 1)<=9 THEN
    Fecha_Vencimiento := TO_DATE(Anio || '/0' || ((Mes + 1) + Cont) || '/05', 'YYYY/MM/DD');
    ELSE
    Fecha_Vencimiento := TO_DATE(Anio || '/' || ((Mes + 1) + Cont) || '/05', 'YYYY/MM/DD');
    END IF;
    ContAnio := ContAnio + 1;
ELSE
    IF (Mes + Cont + 1)<=9 THEN
    Fecha_Vencimiento := TO_DATE(Anio || '/0' || ((Mes + 1) + Cont) || '/05', 'YYYY/MM/DD');
    ELSE
    Fecha_Vencimiento := TO_DATE(Anio || '/' || ((Mes + 1) + Cont) || '/05', 'YYYY/MM/DD');
    END IF;
END IF;
Cont := Cont + 1; --AQUI INCREMENTAMOS EL VALOR DEL LOOP DE 1-1
INSERT INTO Cargo 
VALUES(cont_usercargo.NEXTVAL, (:NEW.Carne), Fecha_Transaccion, Cuota, Cuota, Fecha_Vencimiento, ('Cuota ' || Cont));
END LOOP;
  NULL;
END;