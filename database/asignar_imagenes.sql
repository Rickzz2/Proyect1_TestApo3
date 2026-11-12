/* =====================================================================
   RICKZ - Asignar una imagen a cada plato que ya existe
   ---------------------------------------------------------------------
   1) Copia tus fotos a la carpeta  src/main/webapp/images  del proyecto.
      Nombres simples: minusculas, sin espacios ni tildes (ceviche.jpg).
   2) En cada linea cambia el nombre del archivo por el tuyo.
   3) Borra las lineas de los platos que no tengas, o dejalas: un plato
      sin imagen se ve con el fondo granate de RICKZ.
   4) Selecciona todo (Ctrl + A) y ejecuta (F5).
   ===================================================================== */
USE BD_RICKZ;

-- Mira como se llaman exactamente tus platos:
SELECT id_producto, nombre, imagen_url FROM producto ORDER BY id_producto;

-- Una linea por plato (LIKE busca por el inicio del nombre)
UPDATE producto SET imagen_url = 'images/tequenos.jpg'      WHERE nombre LIKE 'Teque%';
UPDATE producto SET imagen_url = 'images/causa.jpg'         WHERE nombre LIKE 'Causa%';
UPDATE producto SET imagen_url = 'images/lomoSaltado.webp'  WHERE nombre LIKE 'Lomo Saltado%';
UPDATE producto SET imagen_url = 'images/pollo-brasa.jpg'   WHERE nombre LIKE 'Pollo%';
UPDATE producto SET imagen_url = 'images/hamburguesa.jpg'   WHERE nombre LIKE 'Hamburguesa%';
UPDATE producto SET imagen_url = 'images/cheesecake.jpg'    WHERE nombre LIKE 'Cheesecake%';
UPDATE producto SET imagen_url = 'images/chicha-morada.jpg' WHERE nombre LIKE 'Chicha%';
UPDATE producto SET imagen_url = 'images/limonada.jpg'      WHERE nombre LIKE 'Limonada%';
UPDATE producto SET imagen_url = 'images/ceviche.jpg'       WHERE nombre LIKE 'Ceviche%';

-- Comprobar el resultado
SELECT id_producto, nombre, imagen_url FROM producto ORDER BY id_producto;
