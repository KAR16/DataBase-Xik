--Codigo Adicional PLAN PAGO

--Cración de Secuencias
create sequence Cont_PlanPago;
create sequence Cont_UserCargo;
create sequence Carne;


--Como Iterar sobre las secuencias
Cont_PlanPago.NEXTVAL;
Cont_UserCargo.NEXTVAL;
Carne.NEXTVAL;


--CODIGO SOBRE EL INSERT CARGO 
SELECT *
FROM CARGO;

SELECT *
FROM PLAN_PAGO;

INSERT INTO PLAN_PAGO
VALUES(Cont_PlanPago.NEXTVAL,('201600' || Carne.NEXTVAL),SYSDATE, 50000, 50);

delete from Cargo;
delete from Plan_Pago;
Commit;


--Codigo Adicional PAGO

--Creación de Secuencias
CREATE SEQUENCE SECIdPago;
Commit;

--CÓDIGO SOBRE EL INSERT PAGO
INSERT INTO PAGO
VALUES(SECIdPago.NEXTVAL, '2016001', SYSDATE, 3000, 'Pago 1');

SELECT *
FROM PAGO;