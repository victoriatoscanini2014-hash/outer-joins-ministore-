# MiniStore — Outer JOINs

Práctica de SQL orientada al análisis y auditoría de datos utilizando `LEFT JOIN`, `RIGHT JOIN` y `FULL OUTER JOIN`.

## Objetivo

Analizar la relación entre el catálogo de productos y las ventas de MiniStore, identificando tanto los productos que nunca fueron vendidos como las ventas que contienen productos inexistentes en el catálogo.

---

## Estructura del proyecto

```text
outer-joins-ministore/
├── schema.sql
├── soluciones.sql
└── README.md
```

### `schema.sql`

Contiene la creación de las tablas `productos` y `ventas`, junto con los datos de prueba.

### `soluciones.sql`

Contiene las tres consultas solicitadas utilizando Outer JOINs.

---

# Consulta 1 — LEFT JOIN

### ¿Qué productos del catálogo nunca fueron vendidos?

Se utiliza `LEFT JOIN` porque necesitamos conservar todos los productos de la tabla `productos`, incluso aquellos que no tienen ninguna venta asociada.

```sql
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
WHERE v.venta_id IS NULL;
```

El `LEFT JOIN` mantiene todas las filas de la tabla ubicada a la izquierda, que en este caso es `productos`.

Si utilizáramos `INNER JOIN`, solamente aparecerían los productos que tienen una venta relacionada. Se perderían los productos que nunca fueron vendidos.

En este dataset, los productos `108` y `109` nunca aparecen en `ventas`, por lo que son detectados mediante `LEFT JOIN` y presentan `NULL` en `venta_id`.

---

# Consulta 2 — RIGHT JOIN

### ¿Existen ventas con productos que no figuran en el catálogo?

Para esta consulta se utiliza `RIGHT JOIN` porque queremos conservar todas las filas de `ventas`.

La tabla `productos` está a la izquierda y `ventas` está a la derecha:

```sql
FROM productos p
RIGHT JOIN ventas v
    ON p.producto_id = v.producto_id
```

Esto permite detectar ventas cuyo producto no tiene correspondencia en el catálogo.

El filtro utilizado es:

```sql
WHERE p.producto_id IS NULL
```

En los datos de prueba aparece la venta `10`, cuyo `producto_id` es `999`.

Ese producto no existe en la tabla `productos`, por lo que las columnas correspondientes a `productos` aparecen como `NULL`.

Esto permite identificar un posible registro huérfano o error de carga de datos.

---

# ¿Qué representan los NULL?

Los `NULL` representan la ausencia de una coincidencia entre las dos tablas.

### En la Consulta 1

Cuando `venta_id` aparece como `NULL`, significa que ese producto existe en el catálogo pero no tiene ninguna venta asociada.

Ejemplo:

```text
producto_id = 108
nombre = Hub USB-C 7p
venta_id = NULL
```

Esto significa que el producto está registrado en el catálogo, pero nunca fue vendido.

### En la Consulta 2

Cuando `p.producto_id` aparece como `NULL`, significa que existe una venta cuyo producto no se encuentra en el catálogo.

Ejemplo:

```text
venta_id = 10
producto_id de venta = 999
producto_id de productos = NULL
```

El `999` no existe en `productos`, por lo que la venta queda identificada como un registro sin correspondencia en el catálogo.

---

# Consulta 3 — FULL OUTER JOIN

### ¿Cuándo utilizaría FULL OUTER JOIN?

Utilizaría `FULL OUTER JOIN` cuando necesitara realizar una auditoría completa entre dos fuentes de datos y no quisiera perder registros de ninguna de las dos tablas.

En este ejercicio permite observar en una misma consulta:

* Productos que tienen ventas.
* Productos que nunca fueron vendidos.
* Ventas cuyo producto existe en el catálogo.
* Ventas cuyo producto no existe en el catálogo.

```sql
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
    ON p.producto_id = v.producto_id;
```

En un contexto real podría utilizarse para comparar un catálogo de productos contra un sistema de ventas y detectar diferencias entre ambos sistemas.

---

# Conclusión

Los Outer JOIN permiten analizar registros que un `INNER JOIN` descartaría.

En este ejercicio:

* `LEFT JOIN` permite detectar productos sin ventas.
* `RIGHT JOIN` permite detectar ventas con productos inexistentes.
* `FULL OUTER JOIN` permite realizar una auditoría completa de ambas tablas.
* `NULL` funciona como indicador de que no existe una coincidencia entre las tablas.

Estos casos son importantes para detectar problemas de calidad de datos antes de utilizarlos en reportes o dashboards.
