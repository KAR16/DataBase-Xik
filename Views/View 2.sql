/*DETALLE VIEW 2:
Crear una vista que muestre los cargos a los cuales se les aplica el pago, mostrando el pago, el cargo el monto aplicado
*/

CREATE VIEW PAGO_CARGO_AND_MONTO AS
SELECT A.DESCRIPCION AS DESCRIPCION_PAGO, B.DESCRIPCION AS DESCRIPCION_CARGO, C.MONTO
FROM PAGO_CARGO  C INNER JOIN PAGO A
ON A.PAGO = C.PAGO INNER JOIN CARGO B
ON B.CARGO = C.CARGO
WHERE A.CARNE = B.CARNE;