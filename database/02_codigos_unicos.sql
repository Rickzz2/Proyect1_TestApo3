/* =====================================================================
   RICKZ - Códigos únicos para clientes e ítems (ejecutar UNA vez)
   ---------------------------------------------------------------------
   1) Conéctate a la base BD_RICKZ en SSMS (o ejecuta "USE BD_RICKZ;"
      justo antes si estás en SQL Server local).
   2) Selecciona todo (Ctrl + A) y ejecuta (F5).
   Se puede volver a ejecutar sin problema: no repite lo ya hecho.
   Las ventas usan las tablas pedido y detalle_pedido que ya existen.
   ===================================================================== */

/* ---------- Clientes: columna codigo ---------- */
IF COL_LENGTH('dbo.cliente', 'codigo') IS NULL
    ALTER TABLE dbo.cliente ADD codigo VARCHAR(20) NULL;
GO

-- Los clientes que ya existen reciben un código automático: USR-0001, USR-0002...
UPDATE dbo.cliente
SET codigo = 'USR-' + RIGHT('0000' + CAST(id_cliente AS VARCHAR(10)), 4)
WHERE codigo IS NULL;
GO

ALTER TABLE dbo.cliente ALTER COLUMN codigo VARCHAR(20) NOT NULL;
GO

IF NOT EXISTS (SELECT 1 FROM sys.key_constraints WHERE name = 'UQ_cliente_codigo')
    ALTER TABLE dbo.cliente ADD CONSTRAINT UQ_cliente_codigo UNIQUE (codigo);
GO

/* ---------- Productos / ítems: columna codigo ---------- */
IF COL_LENGTH('dbo.producto', 'codigo') IS NULL
    ALTER TABLE dbo.producto ADD codigo VARCHAR(20) NULL;
GO

-- Los productos que ya existen reciben un código automático: ITM-0001, ITM-0002...
UPDATE dbo.producto
SET codigo = 'ITM-' + RIGHT('0000' + CAST(id_producto AS VARCHAR(10)), 4)
WHERE codigo IS NULL;
GO

ALTER TABLE dbo.producto ALTER COLUMN codigo VARCHAR(20) NOT NULL;
GO

IF NOT EXISTS (SELECT 1 FROM sys.key_constraints WHERE name = 'UQ_producto_codigo')
    ALTER TABLE dbo.producto ADD CONSTRAINT UQ_producto_codigo UNIQUE (codigo);
GO

-- Comprobar
SELECT id_cliente, codigo, nombre, correo FROM dbo.cliente;
SELECT id_producto, codigo, nombre FROM dbo.producto;
