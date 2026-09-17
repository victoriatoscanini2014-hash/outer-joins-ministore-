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


# RetailChain — UNION y UNION ALL

## Objetivo

En esta práctica se utilizan `UNION` y `UNION ALL` para combinar información de inventario proveniente de dos sucursales de RetailChain.

El objetivo es comprender la diferencia entre eliminar filas duplicadas y conservar todos los registros para realizar análisis de volumen.

---

## 1. ¿Cuántas filas devuelve cada consulta y por qué son distintas?

En el ejercicio existen 7 registros en la sucursal Norte y 7 registros en la sucursal Sur.

Al utilizar `UNION ALL`, se conservan todos los registros:

**7 + 7 = 14 filas.**

`UNION`, en cambio, elimina únicamente las filas que son completamente iguales en todas las columnas seleccionadas.

Por ejemplo, los productos 103, 104 y 106 aparecen en ambas sucursales, pero tienen diferente stock:

* Producto 103: 5 unidades en Norte y 3 en Sur.
* Producto 104: 20 unidades en Norte y 18 en Sur.
* Producto 106: 10 unidades en Norte y 7 en Sur.

Como las filas no son idénticas, `UNION` no las elimina cuando se seleccionan las cuatro columnas.

Por eso, utilizando las cuatro columnas del inventario, ambas consultas devuelven 14 filas.

Para obtener un catálogo de productos únicos se pueden seleccionar solamente las columnas que identifican al producto:

```sql
SELECT id_producto, nombre_producto, categoria
FROM inventario_sucursal_norte

UNION

SELECT id_producto, nombre_producto, categoria
FROM inventario_sucursal_sur;
```

En este caso, los productos 103, 104 y 106 aparecen en ambas sucursales y son eliminados por `UNION`, por lo que el resultado es de 11 filas.

---

## 2. ¿Por qué UNION ALL es más eficiente que UNION?

`UNION ALL` simplemente combina los resultados de ambas consultas y conserva todas las filas.

`UNION` necesita realizar una operación adicional para detectar y eliminar duplicados.

Esta eliminación puede requerir operaciones internas como ordenamiento o comparación de filas, lo que consume más recursos de CPU y memoria.

Por eso, cuando no necesitamos eliminar duplicados, `UNION ALL` suele ser más eficiente.

---

## 3. ¿En qué casos de negocio usaría cada uno?

### UNION

Utilizaría `UNION` cuando necesito obtener información sin duplicados.

**Ejemplo 1:** consolidar un catálogo de clientes provenientes de dos sistemas comerciales, evitando repetir clientes que aparecen en ambos sistemas.

**Ejemplo 2:** construir una lista única de productos disponibles en diferentes canales de venta, evitando mostrar dos veces el mismo producto.

### UNION ALL

Utilizaría `UNION ALL` cuando necesito conservar todos los registros originales.

**Ejemplo 1:** consolidar las ventas de dos sucursales para calcular el volumen total de operaciones realizadas.

**Ejemplo 2:** unir registros de movimientos de stock de diferentes depósitos para auditar todos los movimientos físicos realizados.

En estos casos no conviene eliminar duplicados porque cada registro representa un hecho diferente.

---

## 4. ¿Qué pasa si las columnas no coinciden?

Las dos consultas de un `UNION` o `UNION ALL` deben tener la misma cantidad de columnas y tipos de datos compatibles.

Por ejemplo, esta consulta genera un error porque la primera consulta devuelve tres columnas y la segunda solamente dos:

```sql
SELECT
    id_producto,
    nombre_producto,
    categoria
FROM inventario_sucursal_norte

UNION

SELECT
    id_producto,
    nombre_producto
FROM inventario_sucursal_sur;
```

SQL Server devuelve un error indicando que todas las consultas combinadas mediante `UNION` deben tener el mismo número de expresiones en sus listas de selección.

También puede producirse un error cuando los tipos de datos no son compatibles.

Por ejemplo, no sería correcto intentar combinar directamente una columna `INT` con otra columna cuyo tipo de dato no sea compatible.

---

## Conclusión

`UNION` y `UNION ALL` tienen comportamientos diferentes:

* `UNION` combina resultados y elimina filas duplicadas.
* `UNION ALL` combina resultados y conserva todas las filas.
* `UNION ALL` suele ser más eficiente porque no necesita realizar la eliminación de duplicados.
* La elección depende del objetivo del análisis: obtener información única o conservar todos los registros.
* Un producto repetido no necesariamente representa una fila duplicada. Para que `UNION` elimine una fila, los valores de las columnas seleccionadas deben coincidir completamente.
