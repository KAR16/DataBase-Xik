/*DETALLE DE LA VISTA:
Crear una vista que muestre los cargos y los pagos de cada carné
*/

CREATE VIEW PAGO_AND_CARGO AS
  SELECT *
  FROM (
  SELECT PAGO, CARNE, FECHA_APLICACION, MONTO, NULL AS FECHA_VENCIMIENTO, DESCRIPCION
  FROM PAGO
  UNION
  SELECT CARGO, CARNE, FECHA_TRANSACCION, MONTO, FECHA_VENCIMIENTO, DESCRIPCION
  FROM CARGO
  )
ORDER BY CARNE ASC, FECHA_APLICACION;