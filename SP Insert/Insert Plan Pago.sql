CREATE OR REPLACE 
PROCEDURE Insert_Plan_Pago(
  Pago INT, 
  Carne VARCHAR,
  Monto NUMBER,
  Cuotas INT
  )
IS
  -- Declaracion de variables locales
BEGIN
  -- Sentencias
  INSERT INTO Plan_Pago VALUES(Pago, Carne, SYSDATE, Monto, Cuotas);

END Insert_Plan_Pago; 

