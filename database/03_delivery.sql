/* =====================================================================
   RICKZ - Datos de entrega para pedidos a domicilio (ejecutar UNA vez)
   ---------------------------------------------------------------------
   Conéctate a la base BD_RICKZ y ejecuta todo el script (Ctrl+A, F5).
   Se puede volver a ejecutar sin problema.
   ===================================================================== */
IF COL_LENGTH('dbo.pedido', 'direccion_entrega') IS NULL
    ALTER TABLE dbo.pedido ADD direccion_entrega VARCHAR(250) NULL;
GO
IF COL_LENGTH('dbo.pedido', 'distrito') IS NULL
    ALTER TABLE dbo.pedido ADD distrito VARCHAR(100) NULL;
GO
IF COL_LENGTH('dbo.pedido', 'referencia') IS NULL
    ALTER TABLE dbo.pedido ADD referencia VARCHAR(250) NULL;
GO
IF COL_LENGTH('dbo.pedido', 'telefono_contacto') IS NULL
    ALTER TABLE dbo.pedido ADD telefono_contacto VARCHAR(20) NULL;
GO
IF COL_LENGTH('dbo.pedido', 'nombre_receptor') IS NULL
    ALTER TABLE dbo.pedido ADD nombre_receptor VARCHAR(150) NULL;
GO
