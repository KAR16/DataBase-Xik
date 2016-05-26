/*DETALLE VIEW 2:
Crear una vista que muestre los cargos a los cuales se les aplica el pago, mostrando el pago, el cargo el monto aplicado
*/

SELECT  C.CARNE, A.DESCRIPCION AS CARGO , B.DESCRIPCION AS PAGO --C.MONTO AS MONTO
FROM PLAN_PAGO  A
INNER JOIN CARGO B
ON A.CARNE = B.CARNE
INNER JOIN PAGO C
ON B.CARNE = C.CARNE
ORDER BY A.CARNE ASC;