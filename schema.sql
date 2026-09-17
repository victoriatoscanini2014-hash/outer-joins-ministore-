-- MiniStore - Schema y datos de prueba

DROP TABLE IF EXISTS ventas;
DROP TABLE IF EXISTS productos;

CREATE TABLE productos (
    producto_id INT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    categoria VARCHAR(50) NOT NULL,
    precio DECIMAL(10,2)
);

CREATE TABLE ventas (
    venta_id INT PRIMARY KEY,
    producto_id INT,
    cliente_id INT,
    cantidad INT NOT NULL,
    fecha_venta DATE NOT NULL
);

-- Productos
INSERT INTO productos VALUES
(101, 'Laptop Pro 15', 'Computación', 1200.00),
(102, 'Mouse Inalámbrico', 'Accesorios', 28.00),
(103, 'Monitor 4K 27"', 'Computación', 450.00),
(104, 'Teclado Mecánico', 'Accesorios', 95.00),
(105, 'Auriculares BT Pro', 'Audio', 120.00),
(106, 'SSD Externo 1TB', 'Almacenamiento', 130.00),
(107, 'Webcam HD 1080p', 'Accesorios', 85.00),
(108, 'Hub USB-C 7p', 'Accesorios', 45.00),
(109, 'Parlante Bluetooth', 'Audio', 60.00);

-- Ventas
INSERT INTO ventas VALUES
(1, 101, 201, 2, '2024-01-05'),
(2, 102, 202, 5, '2024-01-08'),
(3, 103, 203, 1, '2024-01-12'),
(4, 101, 201, 1, '2024-02-03'),
(5, 104, 204, 3, '2024-02-10'),
(6, 105, 202, 2, '2024-02-18'),
(7, 106, 205, 3, '2024-03-05'),
(8, 102, 203, 8, '2024-03-12'),
(9, 107, 204, 2, '2024-03-20'),
(10, 999, 205, 1, '2024-03-25');
