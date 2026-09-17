-- MiniStore - Soluciones con Outer JOINs
-- Autor: Victoria Toscanini
-- Fecha: 17/09/2026


-- CONSULTA 1: LEFT JOIN
-- Productos del catálogo nunca vendidos

SELECT
    p.producto_id,
    p.nombre,
    p.categoria,
    p.precio,
    v.venta_id,
    v.fecha_venta
FROM productos p
LEFT JOIN ventas v
    ON p.producto_id = v.producto_id
WHERE v.venta_id IS NULL
ORDER BY p.producto_id;


-- CONSULTA 2: RIGHT JOIN
-- Ventas con productos inexistentes

SELECT
    p.producto_id,
    p.nombre,
    p.categoria,
    v.venta_id,
    v.cliente_id,
    v.cantidad,
    v.fecha_venta
FROM productos p
RIGHT JOIN ventas v
    ON p.producto_id = v.producto_id
WHERE p.producto_id IS NULL
ORDER BY v.venta_id;


-- CONSULTA 3: FULL OUTER JOIN
-- Auditoría completa de productos y ventas

SELECT
    p.producto_id,
    p.nombre,
    p.categoria,
    v.venta_id,
    v.cliente_id,
    v.cantidad,
    v.fecha_venta
FROM productos p
FULL OUTER JOIN ventas v
    ON p.producto_id = v.producto_id
ORDER BY
    COALESCE(p.producto_id, v.producto_id),
    v.venta_id;

-- ==========================================
-- RetailChain — Inventario por Sucursal
-- ==========================================

DROP TABLE IF EXISTS inventario_sucursal_norte;
DROP TABLE IF EXISTS inventario_sucursal_sur;

CREATE TABLE inventario_sucursal_norte (
    id_producto     INT,
    nombre_producto VARCHAR(100) NOT NULL,
    categoria       VARCHAR(50),
    stock           INT NOT NULL
);

CREATE TABLE inventario_sucursal_sur (
    id_producto     INT,
    nombre_producto VARCHAR(100) NOT NULL,
    categoria       VARCHAR(50),
    stock           INT NOT NULL
);

-- Sucursal Norte
INSERT INTO inventario_sucursal_norte VALUES
(101, 'Laptop Pro 15', 'Computación', 8),
(102, 'Mouse Inalámbrico', 'Accesorios', 30),
(103, 'Monitor 4K 27"', 'Computación', 5),
(104, 'Teclado Mecánico', 'Accesorios', 20),
(105, 'Auriculares BT Pro', 'Audio', 15),
(106, 'SSD Externo 1TB', 'Almacenamiento', 10),
(107, 'Webcam HD 1080p', 'Accesorios', 12);

-- Sucursal Sur
INSERT INTO inventario_sucursal_sur VALUES
(103, 'Monitor 4K 27"', 'Computación', 3),
(104, 'Teclado Mecánico', 'Accesorios', 18),
(106, 'SSD Externo 1TB', 'Almacenamiento', 7),
(108, 'Laptop Basic 14', 'Computación', 6),
(109, 'Parlante Bluetooth', 'Audio', 22),
(110, 'Hub USB-C 7p', 'Accesorios', 35),
(111, 'Webcam HD 1080p', 'Accesorios', 9);
