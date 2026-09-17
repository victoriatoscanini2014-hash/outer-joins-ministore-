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
