--TEST SQL XIK
--KEVIN HERRERA DEVELOPER

CREATE TABLE Plan_Pago
 (
	Plan_Pago 		      INT PRIMARY KEY, --PK
	Carne 			        VARCHAR(12) NOT NULL,
	Fecha_Aplicacion	  DATE NOT NULL,
	Monto			          NUMERIC(11, 2) NOT NULL,
	Cuotas			        INT NOT NULL  
);


CREATE TABLE Cargo(
	Cargo			          INT PRIMARY KEY, --PK
	Carne			          VARCHAR(12) NOT NULL,
	Fecha_Transaccion 	DATE NOT NULL,
  Monto               NUMERIC(11, 2) NOT NULL,
	Saldo			          NUMERIC(11, 2) NOT NULL,
	Fecha_Vencimiento	  DATE NOT NULL,
	Descripcion		      VARCHAR(100) NOT NULL
);


CREATE TABLE Pago(
	Pago			          INT PRIMARY KEY, --PK
	Carne			          VARCHAR(12) NOT NULL,
	Fecha_Aplicacion	  DATE NOT NULL,
	Monto			          NUMERIC(11, 2) NOT NULL,
  Descripcion         VARCHAR(100)
);


CREATE TABLE Pago_Cargo(
  Pago_Cargo          INT PRIMARY KEY,                    --PK
	Pago 			          INT,			                          --FK
	Cargo			          INT NOT NULL,                --FK
	Monto			          NUMERIC(11, 2) NOT NULL,
  CONSTRAINT fk_PCP FOREIGN KEY (Pago) REFERENCES Pago(Pago),
  CONSTRAINT fk_PCC FOREIGN KEY (Cargo) REFERENCES Cargo(Cargo)
);


