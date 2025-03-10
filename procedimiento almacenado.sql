-- Crear la tabla de cuentas
CREATE TABLE cuentas (
    numero_cuenta INT PRIMARY KEY,
    total_creditos DECIMAL(10,2) DEFAULT 0,
    total_debitos DECIMAL(10,2) DEFAULT 0,
    saldo DECIMAL(10,2) DEFAULT 0
);

-- Crear la tabla de transacciones
CREATE TABLE transacciones (
    id INT AUTO_INCREMENT PRIMARY KEY,
    numero_cuenta INT,
    fecha DATE DEFAULT (NOW()), -- Cambié CURRENT_DATE por NOW()
    credito DECIMAL(10,2) DEFAULT 0,
    debito DECIMAL(10,2) DEFAULT 0,
    FOREIGN KEY (numero_cuenta) REFERENCES cuentas(numero_cuenta)
);


-- Crear el procedimiento almacenado
DELIMITER //
CREATE PROCEDURE agregar_transaccion(
    IN num_cuenta INT,
    IN monto DECIMAL(10,2),
    IN tipo VARCHAR(10)
)
BEGIN
    -- Insertar la transacción según el tipo
    IF tipo = 'credito' THEN
        INSERT INTO transacciones (numero_cuenta, fecha, credito) VALUES (num_cuenta, NOW(), monto);
        UPDATE cuentas SET total_creditos = total_creditos + monto, saldo = saldo + monto WHERE numero_cuenta = num_cuenta;
    ELSEIF tipo = 'debito' THEN
        INSERT INTO transacciones (numero_cuenta, fecha, debito) VALUES (num_cuenta, NOW(), monto);
        UPDATE cuentas SET total_debitos = total_debitos + monto, saldo = saldo - monto WHERE numero_cuenta = num_cuenta;
    END IF;
END //
DELIMITER ;

-- Insertar cuentas de ejemplo
INSERT INTO cuentas (numero_cuenta, saldo) VALUES (20010001, 0), (20010002, 0), (20010003, 0), (20010004, 0), (20010005, 0);

-- Agregar transacciones de prueba
CALL agregar_transaccion(20010001, 800.00, 'credito');
CALL agregar_transaccion(20010002, 560.00, 'credito');
CALL agregar_transaccion(20010003, 1254.00, 'credito');
CALL agregar_transaccion(20010004, 15000.00, 'credito');
CALL agregar_transaccion(20010005, 256.00, 'credito');

-- Ver resultados
SELECT * FROM cuentas;
SELECT * FROM transacciones;
