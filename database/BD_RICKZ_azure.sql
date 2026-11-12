/* =====================================================================
   RICKZ - Base de datos para Azure SQL Database
   ---------------------------------------------------------------------
   1) En Azure crea una base de datos llamada BD_RICKZ (plan gratis).
   2) Conectate a BD_RICKZ desde SSMS con el usuario administrador del
      servidor de Azure (Autenticacion de SQL Server).
   3) En la seccion 4 cambia la clave del usuario rickz_app (debe tener
      mayusculas, minusculas, numeros y simbolos).
   4) Selecciona todo (Ctrl + A) y ejecuta (F5). Una sola vez.
   ===================================================================== */

/* ---------------------- 1. Tablas y relaciones ---------------------- */
/****** Objeto: Table [dbo].[calificacion] Fecha de script: 14/10/2026 21:30:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[calificacion](
	[id_calificacion] [int] IDENTITY(1,1) NOT NULL,
	[id_pedido] [int] NOT NULL,
	[puntuacion] [int] NOT NULL,
	[comentario] [varchar](max) NULL,
	[fecha] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[id_calificacion] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[id_pedido] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Objeto: Table [dbo].[categoria] Fecha de script: 14/10/2026 21:30:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[categoria](
	[id_categoria] [int] IDENTITY(1,1) NOT NULL,
	[nombre] [varchar](100) NOT NULL,
	[descripcion] [varchar](max) NULL,
PRIMARY KEY CLUSTERED 
(
	[id_categoria] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Objeto: Table [dbo].[cliente] Fecha de script: 14/10/2026 21:30:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[cliente](
	[id_cliente] [int] IDENTITY(1,1) NOT NULL,
	[nombre] [varchar](100) NOT NULL,
	[apellidos] [varchar](100) NOT NULL,
	[correo] [varchar](150) NOT NULL,
	[password_hash] [varchar](255) NOT NULL,
	[telefono] [varchar](20) NULL,
	[direccion] [varchar](max) NULL,
	[fecha_registro] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[id_cliente] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[correo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Objeto: Table [dbo].[detalle_pedido] Fecha de script: 14/10/2026 21:30:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[detalle_pedido](
	[id_detalle] [int] IDENTITY(1,1) NOT NULL,
	[id_pedido] [int] NOT NULL,
	[id_producto] [int] NOT NULL,
	[cantidad] [int] NOT NULL,
	[precio_unitario] [decimal](10, 2) NOT NULL,
	[subtotal]  AS ([cantidad]*[precio_unitario]) PERSISTED,
PRIMARY KEY CLUSTERED 
(
	[id_detalle] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Objeto: Table [dbo].[ingrediente] Fecha de script: 14/10/2026 21:30:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ingrediente](
	[id_ingrediente] [int] IDENTITY(1,1) NOT NULL,
	[nombre] [varchar](100) NOT NULL,
	[cantidad_stock] [decimal](10, 2) NOT NULL,
	[unidad_medida] [varchar](20) NOT NULL,
	[stock_minimo] [decimal](10, 2) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id_ingrediente] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Objeto: Table [dbo].[metodo_pago] Fecha de script: 14/10/2026 21:30:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[metodo_pago](
	[id_pago] [int] IDENTITY(1,1) NOT NULL,
	[id_pedido] [int] NOT NULL,
	[tipo] [varchar](20) NOT NULL,
	[monto] [decimal](10, 2) NOT NULL,
	[fecha] [datetime] NULL,
	[estado] [varchar](20) NULL,
PRIMARY KEY CLUSTERED 
(
	[id_pago] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[id_pedido] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Objeto: Table [dbo].[pedido] Fecha de script: 14/10/2026 21:30:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[pedido](
	[id_pedido] [int] IDENTITY(1,1) NOT NULL,
	[id_cliente] [int] NOT NULL,
	[id_restaurante] [int] NOT NULL,
	[fecha] [datetime] NULL,
	[estado] [varchar](30) NULL,
	[tipo_pedido] [varchar](20) NOT NULL,
	[total] [decimal](10, 2) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id_pedido] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Objeto: Table [dbo].[plato] Fecha de script: 14/10/2026 21:30:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[plato](
	[id_plato] [int] IDENTITY(1,1) NOT NULL,
	[id_producto] [int] NOT NULL,
	[id_restaurante] [int] NOT NULL,
	[tiempo_preparacion] [int] NOT NULL,
	[alergenos] [varchar](255) NULL,
PRIMARY KEY CLUSTERED 
(
	[id_plato] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[id_producto] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Objeto: Table [dbo].[plato_ingrediente] Fecha de script: 14/10/2026 21:30:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[plato_ingrediente](
	[id_plato] [int] NOT NULL,
	[id_ingrediente] [int] NOT NULL,
	[cantidad_usada] [decimal](10, 2) NOT NULL,
 CONSTRAINT [PK_plato_ingrediente] PRIMARY KEY CLUSTERED 
(
	[id_plato] ASC,
	[id_ingrediente] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Objeto: Table [dbo].[producto] Fecha de script: 14/10/2026 21:30:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[producto](
	[id_producto] [int] IDENTITY(1,1) NOT NULL,
	[id_categoria] [int] NOT NULL,
	[nombre] [varchar](150) NOT NULL,
	[descripcion] [varchar](max) NULL,
	[precio] [decimal](10, 2) NOT NULL,
	[cantidad_stock] [int] NULL,
	[disponibilidad] [bit] NULL,
	[imagen_url] [varchar](255) NULL,
PRIMARY KEY CLUSTERED 
(
	[id_producto] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Objeto: Table [dbo].[promocion] Fecha de script: 14/10/2026 21:30:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[promocion](
	[id_promocion] [int] IDENTITY(1,1) NOT NULL,
	[id_restaurante] [int] NOT NULL,
	[nombre] [varchar](100) NOT NULL,
	[descripcion] [varchar](max) NULL,
	[descuento] [decimal](5, 2) NOT NULL,
	[fecha_inicio] [date] NOT NULL,
	[fecha_fin] [date] NOT NULL,
	[estado] [bit] NULL,
PRIMARY KEY CLUSTERED 
(
	[id_promocion] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Objeto: Table [dbo].[promocion_producto] Fecha de script: 14/10/2026 21:30:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[promocion_producto](
	[id_promocion] [int] NOT NULL,
	[id_producto] [int] NOT NULL,
 CONSTRAINT [PK_promocion_producto] PRIMARY KEY CLUSTERED 
(
	[id_promocion] ASC,
	[id_producto] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Objeto: Table [dbo].[recomendacion] Fecha de script: 14/10/2026 21:30:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[recomendacion](
	[id_recomendacion] [int] IDENTITY(1,1) NOT NULL,
	[id_cliente] [int] NOT NULL,
	[preferencia] [varchar](100) NULL,
	[restriccion_alimentaria] [varchar](100) NULL,
PRIMARY KEY CLUSTERED 
(
	[id_recomendacion] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Objeto: Table [dbo].[restaurante] Fecha de script: 14/10/2026 21:30:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[restaurante](
	[id_restaurante] [int] IDENTITY(1,1) NOT NULL,
	[nombre] [varchar](120) NOT NULL,
	[tipo_establecimiento] [varchar](80) NOT NULL,
	[direccion] [varchar](200) NOT NULL,
	[telefono] [varchar](20) NULL,
	[horario] [varchar](100) NULL,
PRIMARY KEY CLUSTERED 
(
	[id_restaurante] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[calificacion] ADD  DEFAULT (getdate()) FOR [fecha]
GO
ALTER TABLE [dbo].[cliente] ADD  DEFAULT (getdate()) FOR [fecha_registro]
GO
ALTER TABLE [dbo].[ingrediente] ADD  DEFAULT ((0.00)) FOR [cantidad_stock]
GO
ALTER TABLE [dbo].[ingrediente] ADD  DEFAULT ((0.00)) FOR [stock_minimo]
GO
ALTER TABLE [dbo].[metodo_pago] ADD  DEFAULT (getdate()) FOR [fecha]
GO
ALTER TABLE [dbo].[metodo_pago] ADD  DEFAULT ('Completado') FOR [estado]
GO
ALTER TABLE [dbo].[pedido] ADD  DEFAULT (getdate()) FOR [fecha]
GO
ALTER TABLE [dbo].[pedido] ADD  DEFAULT ('Pendiente') FOR [estado]
GO
ALTER TABLE [dbo].[pedido] ADD  DEFAULT ((0.00)) FOR [total]
GO
ALTER TABLE [dbo].[producto] ADD  DEFAULT ((0)) FOR [cantidad_stock]
GO
ALTER TABLE [dbo].[producto] ADD  DEFAULT ((1)) FOR [disponibilidad]
GO
ALTER TABLE [dbo].[promocion] ADD  DEFAULT ((1)) FOR [estado]
GO
ALTER TABLE [dbo].[calificacion]  WITH CHECK ADD  CONSTRAINT [FK_calificacion_pedido] FOREIGN KEY([id_pedido])
REFERENCES [dbo].[pedido] ([id_pedido])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[calificacion] CHECK CONSTRAINT [FK_calificacion_pedido]
GO
ALTER TABLE [dbo].[detalle_pedido]  WITH CHECK ADD  CONSTRAINT [FK_dp_pedido] FOREIGN KEY([id_pedido])
REFERENCES [dbo].[pedido] ([id_pedido])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[detalle_pedido] CHECK CONSTRAINT [FK_dp_pedido]
GO
ALTER TABLE [dbo].[detalle_pedido]  WITH CHECK ADD  CONSTRAINT [FK_dp_producto] FOREIGN KEY([id_producto])
REFERENCES [dbo].[producto] ([id_producto])
GO
ALTER TABLE [dbo].[detalle_pedido] CHECK CONSTRAINT [FK_dp_producto]
GO
ALTER TABLE [dbo].[metodo_pago]  WITH CHECK ADD  CONSTRAINT [FK_pago_pedido] FOREIGN KEY([id_pedido])
REFERENCES [dbo].[pedido] ([id_pedido])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[metodo_pago] CHECK CONSTRAINT [FK_pago_pedido]
GO
ALTER TABLE [dbo].[pedido]  WITH CHECK ADD  CONSTRAINT [FK_pedido_cliente] FOREIGN KEY([id_cliente])
REFERENCES [dbo].[cliente] ([id_cliente])
GO
ALTER TABLE [dbo].[pedido] CHECK CONSTRAINT [FK_pedido_cliente]
GO
ALTER TABLE [dbo].[pedido]  WITH CHECK ADD  CONSTRAINT [FK_pedido_restaurante] FOREIGN KEY([id_restaurante])
REFERENCES [dbo].[restaurante] ([id_restaurante])
GO
ALTER TABLE [dbo].[pedido] CHECK CONSTRAINT [FK_pedido_restaurante]
GO
ALTER TABLE [dbo].[plato]  WITH CHECK ADD  CONSTRAINT [FK_plato_producto] FOREIGN KEY([id_producto])
REFERENCES [dbo].[producto] ([id_producto])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[plato] CHECK CONSTRAINT [FK_plato_producto]
GO
ALTER TABLE [dbo].[plato]  WITH CHECK ADD  CONSTRAINT [FK_plato_restaurante] FOREIGN KEY([id_restaurante])
REFERENCES [dbo].[restaurante] ([id_restaurante])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[plato] CHECK CONSTRAINT [FK_plato_restaurante]
GO
ALTER TABLE [dbo].[plato_ingrediente]  WITH CHECK ADD  CONSTRAINT [FK_pi_ingrediente] FOREIGN KEY([id_ingrediente])
REFERENCES [dbo].[ingrediente] ([id_ingrediente])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[plato_ingrediente] CHECK CONSTRAINT [FK_pi_ingrediente]
GO
ALTER TABLE [dbo].[plato_ingrediente]  WITH CHECK ADD  CONSTRAINT [FK_pi_plato] FOREIGN KEY([id_plato])
REFERENCES [dbo].[plato] ([id_plato])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[plato_ingrediente] CHECK CONSTRAINT [FK_pi_plato]
GO
ALTER TABLE [dbo].[producto]  WITH CHECK ADD  CONSTRAINT [FK_producto_categoria] FOREIGN KEY([id_categoria])
REFERENCES [dbo].[categoria] ([id_categoria])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[producto] CHECK CONSTRAINT [FK_producto_categoria]
GO
ALTER TABLE [dbo].[promocion]  WITH CHECK ADD  CONSTRAINT [FK_promocion_restaurante] FOREIGN KEY([id_restaurante])
REFERENCES [dbo].[restaurante] ([id_restaurante])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[promocion] CHECK CONSTRAINT [FK_promocion_restaurante]
GO
ALTER TABLE [dbo].[promocion_producto]  WITH CHECK ADD  CONSTRAINT [FK_pp_producto] FOREIGN KEY([id_producto])
REFERENCES [dbo].[producto] ([id_producto])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[promocion_producto] CHECK CONSTRAINT [FK_pp_producto]
GO
ALTER TABLE [dbo].[promocion_producto]  WITH CHECK ADD  CONSTRAINT [FK_pp_promocion] FOREIGN KEY([id_promocion])
REFERENCES [dbo].[promocion] ([id_promocion])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[promocion_producto] CHECK CONSTRAINT [FK_pp_promocion]
GO
ALTER TABLE [dbo].[recomendacion]  WITH CHECK ADD  CONSTRAINT [FK_recomendacion_cliente] FOREIGN KEY([id_cliente])
REFERENCES [dbo].[cliente] ([id_cliente])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[recomendacion] CHECK CONSTRAINT [FK_recomendacion_cliente]
GO
ALTER TABLE [dbo].[calificacion]  WITH CHECK ADD CHECK  (([puntuacion]>=(1) AND [puntuacion]<=(5)))
GO
ALTER TABLE [dbo].[metodo_pago]  WITH CHECK ADD CHECK  (([estado]='Rechazado' OR [estado]='Pendiente' OR [estado]='Completado'))
GO
ALTER TABLE [dbo].[metodo_pago]  WITH CHECK ADD CHECK  (([tipo]='Transferencia' OR [tipo]='Plin' OR [tipo]='Yape' OR [tipo]='Tarjeta' OR [tipo]='Efectivo'))
GO
ALTER TABLE [dbo].[pedido]  WITH CHECK ADD CHECK  (([estado]='Cancelado' OR [estado]='Entregado' OR [estado]='Listo' OR [estado]='En Preparacion' OR [estado]='Pendiente'))
GO
ALTER TABLE [dbo].[pedido]  WITH CHECK ADD CHECK  (([tipo_pedido]='Domicilio' OR [tipo_pedido]='Llevar' OR [tipo_pedido]='Mesa'))
GO


/* ---------------------- 2. Rol de cada cliente ---------------------- */
ALTER TABLE cliente ADD rol VARCHAR(10) NOT NULL
    CONSTRAINT DF_cliente_rol DEFAULT 'cliente'
    CONSTRAINT CK_cliente_rol CHECK (rol IN ('admin', 'cliente'));
GO

/* ---------------------- 3. Datos iniciales -------------------------- */
INSERT INTO categoria (nombre, descripcion) VALUES
('Entradas', 'Platos para empezar'),
('Platos de fondo', 'Platos principales'),
('Postres', 'Dulces y postres'),
('Bebidas', 'Refrescos y bebidas');
GO

INSERT INTO restaurante (nombre, tipo_establecimiento, direccion, telefono, horario)
VALUES ('RICKZ', 'Restaurante', 'Direccion de ejemplo', NULL, NULL);
GO

/* Esta base va a estar en internet, asi que NO se crea ninguna cuenta de admin
   con clave conocida. Para ser admin: crea tu cuenta desde la pagina publicada
   (Crea una) y luego ejecuta en SSMS:
   UPDATE cliente SET rol = 'admin' WHERE correo = 'tu_correo@ejemplo.com'; */

/* ---------------------- 4. Usuario de la aplicacion ------------------ */
CREATE USER rickz_app WITH PASSWORD = 'CAMBIA_ESTA_CLAVE';
GO
ALTER ROLE db_datareader ADD MEMBER rickz_app;
ALTER ROLE db_datawriter ADD MEMBER rickz_app;
GO
