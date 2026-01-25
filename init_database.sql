-- =============================================================================
-- FOOD WASTE FIGHTER - DATABASE
-- =============================================================================

CREATE DATABASE IF NOT EXISTS foodwastefighter
CHARACTER SET utf8mb4
COLLATE utf8mb4_unicode_ci;

USE foodwastefighter;

SET NAMES utf8mb4;

-- =============================================================================
-- DROP TABLES (in order of dependencies)
-- =============================================================================
DROP TABLE IF EXISTS alimento;
DROP TABLE IF EXISTS categoria;
DROP TABLE IF EXISTS inventario;
DROP TABLE IF EXISTS usuario;
DROP TABLE IF EXISTS informacion_nutricional;
DROP TABLE IF EXISTS paso_preparacion;
DROP TABLE IF EXISTS ingrediente;
DROP TABLE IF EXISTS receta;

-- =============================================================================
-- CREATE TABLES
-- =============================================================================

-- Table: usuario (NEW - for authentication)
CREATE TABLE usuario (
    id_usuario BIGINT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    contrasena VARCHAR(255) NOT NULL,
    fecha_registro TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_email (email)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Table: inventario (MODIFIED - linked to usuario)
CREATE TABLE inventario (
    id_inventario BIGINT AUTO_INCREMENT PRIMARY KEY,
    id_usuario BIGINT NOT NULL UNIQUE,
    FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Table: categoria
CREATE TABLE categoria (
    id_categoria BIGINT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL UNIQUE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Table: alimento
CREATE TABLE alimento (
    id_alimento BIGINT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    fecha_caducidad DATE NOT NULL,
    cantidad VARCHAR(50) NOT NULL,
    id_categoria BIGINT NOT NULL,
    id_inventario BIGINT NOT NULL,
    FOREIGN KEY (id_categoria) REFERENCES categoria(id_categoria) ON DELETE RESTRICT,
    FOREIGN KEY (id_inventario) REFERENCES inventario(id_inventario) ON DELETE CASCADE,
    INDEX idx_fecha_caducidad (fecha_caducidad),
    INDEX idx_inventario (id_inventario)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Table: receta
CREATE TABLE receta (
    id_receta BIGINT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(200) NOT NULL,
    descripcion TEXT,
    imagen_url VARCHAR(500),
    tiempo_preparacion INT NOT NULL COMMENT 'Tiempo en minutos',
    porciones INT NOT NULL,
    dificultad VARCHAR(50) NOT NULL,
    INDEX idx_nombre (nombre)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Table: ingrediente
CREATE TABLE ingrediente (
    id_ingrediente BIGINT AUTO_INCREMENT PRIMARY KEY,
    id_receta BIGINT NOT NULL,
    nombre VARCHAR(200) NOT NULL,
    cantidad VARCHAR(100) NOT NULL,
    orden INT NOT NULL DEFAULT 0,
    FOREIGN KEY (id_receta) REFERENCES receta(id_receta) ON DELETE CASCADE,
    INDEX idx_receta (id_receta)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Table: paso_preparacion
CREATE TABLE paso_preparacion (
    id_paso BIGINT AUTO_INCREMENT PRIMARY KEY,
    id_receta BIGINT NOT NULL,
    numero_paso INT NOT NULL,
    titulo VARCHAR(200) NOT NULL,
    descripcion TEXT NOT NULL,
    FOREIGN KEY (id_receta) REFERENCES receta(id_receta) ON DELETE CASCADE,
    INDEX idx_receta (id_receta),
    INDEX idx_numero (numero_paso)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Table: informacion_nutricional
CREATE TABLE informacion_nutricional (
    id_nutricional BIGINT AUTO_INCREMENT PRIMARY KEY,
    id_receta BIGINT NOT NULL UNIQUE,
    calorias INT NOT NULL,
    grasas DECIMAL(5,1) NOT NULL,
    carbohidratos DECIMAL(5,1) NOT NULL,
    proteinas DECIMAL(5,1) NOT NULL,
    FOREIGN KEY (id_receta) REFERENCES receta(id_receta) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


-- =============================================================================
-- INSERT INITIAL DATA
-- =============================================================================

-- Insert categories
INSERT INTO categoria (nombre) VALUES
('Frutas'),
('Verduras'),
('Lácteos'),
('Carnes'),
('Panadería'),
('Pescados'),
('Huevos'),
('Cereales'),
('Bebidas'),
('Otros');

-- Receta 1: Ensalada Fresca
INSERT INTO receta (nombre, descripcion, imagen_url, tiempo_preparacion, porciones, dificultad) VALUES
('Ensalada Fresca', 'Una ensalada nutritiva y deliciosa perfecta para aprovechar tus vegetales frescos. Esta receta te ayudará a consumir esa lechuga y tomates antes de que caduquen.', 
'https://placehold.co/600x400/a3e635/ffffff?text=Ensalada+Fresca', 15, 2, 'Fácil');

SET @receta1_id = LAST_INSERT_ID();

INSERT INTO ingrediente (id_receta, nombre, cantidad, orden) VALUES
(@receta1_id, 'Lechuga', '200g', 1),
(@receta1_id, 'Tomates', '2 unidades medianas', 2),
(@receta1_id, 'Pepino', '1 unidad', 3),
(@receta1_id, 'Cebolla morada', '1 pequeña', 4),
(@receta1_id, 'Aceite de oliva', '3 cucharadas', 5),
(@receta1_id, 'Vinagre balsámico', '2 cucharadas', 6),
(@receta1_id, 'Sal y pimienta', 'Al gusto', 7);

INSERT INTO paso_preparacion (id_receta, numero_paso, titulo, descripcion) VALUES
(@receta1_id, 1, 'Lavar y preparar los vegetales', 'Lava bien la lechuga bajo agua fría y escúrrela. Corta los tomates en rodajas, el pepino en medias lunas y la cebolla en aros finos.'),
(@receta1_id, 2, 'Armar la ensalada', 'En un bowl grande, coloca la lechuga como base. Añade los tomates, pepino y cebolla distribuidos uniformemente.'),
(@receta1_id, 3, 'Preparar el aderezo', 'En un recipiente pequeño, mezcla el aceite de oliva, vinagre balsámico, sal y pimienta. Bate bien hasta integrar.'),
(@receta1_id, 4, 'Servir y disfrutar', 'Rocía el aderezo sobre la ensalada justo antes de servir. Mezcla suavemente y disfruta de tu comida fresca y saludable.');

INSERT INTO informacion_nutricional (id_receta, calorias, grasas, carbohidratos, proteinas) VALUES
(@receta1_id, 180, 15.0, 12.0, 3.0);

-- Receta 2: Batido de Frutas
INSERT INTO receta (nombre, descripcion, imagen_url, tiempo_preparacion, porciones, dificultad) VALUES
('Batido de Frutas', 'Perfecto para esa leche y frutas que están por vencer. Nutritivo y delicioso para empezar el día con energía.', 
'https://placehold.co/600x400/fde047/ffffff?text=Batido+de+Frutas', 10, 2, 'Muy Fácil');

SET @receta2_id = LAST_INSERT_ID();

INSERT INTO ingrediente (id_receta, nombre, cantidad, orden) VALUES
(@receta2_id, 'Leche', '1 litro', 1),
(@receta2_id, 'Manzanas', '2 unidades', 2),
(@receta2_id, 'Plátano', '1 unidad', 3),
(@receta2_id, 'Miel', '2 cucharadas', 4),
(@receta2_id, 'Hielo', '1 taza', 5);

INSERT INTO paso_preparacion (id_receta, numero_paso, titulo, descripcion) VALUES
(@receta2_id, 1, 'Preparar las frutas', 'Lava y pela las manzanas, córtalas en trozos. Pela el plátano y córtalo en rodajas.'),
(@receta2_id, 2, 'Mezclar ingredientes', 'Coloca todos los ingredientes en la licuadora: leche, frutas, miel y hielo.'),
(@receta2_id, 3, 'Licuar', 'Licúa a velocidad alta durante 1-2 minutos hasta obtener una mezcla suave y homogénea.'),
(@receta2_id, 4, 'Servir inmediatamente', 'Sirve en vasos altos y disfruta de inmediato para aprovechar todos los nutrientes.');

INSERT INTO informacion_nutricional (id_receta, calorias, grasas, carbohidratos, proteinas) VALUES
(@receta2_id, 220, 4.0, 42.0, 8.0);

-- Receta 3: Pollo al Horno con Verduras
INSERT INTO receta (nombre, descripcion, imagen_url, tiempo_preparacion, porciones, dificultad) VALUES
('Pollo al Horno con Verduras', 'Aprovecha tu pollo fresco antes de que caduque. Una comida completa y saludable perfecta para toda la familia.', 
'https://placehold.co/600x400/f97316/ffffff?text=Pollo+al+Horno', 45, 4, 'Media');

SET @receta3_id = LAST_INSERT_ID();

INSERT INTO ingrediente (id_receta, nombre, cantidad, orden) VALUES
(@receta3_id, 'Pollo fresco', '1 kg', 1),
(@receta3_id, 'Zanahorias', '500g', 2),
(@receta3_id, 'Papas', '4 unidades', 3),
(@receta3_id, 'Aceite de oliva', '4 cucharadas', 4),
(@receta3_id, 'Ajo', '4 dientes', 5),
(@receta3_id, 'Romero', '2 ramitas', 6),
(@receta3_id, 'Sal y pimienta', 'Al gusto', 7);

INSERT INTO paso_preparacion (id_receta, numero_paso, titulo, descripcion) VALUES
(@receta3_id, 1, 'Precalentar el horno', 'Precalienta el horno a 200°C (390°F). Prepara una bandeja para hornear con papel pergamino.'),
(@receta3_id, 2, 'Preparar el pollo', 'Lava y seca el pollo. Frótalo con aceite de oliva, sal, pimienta y ajo picado.'),
(@receta3_id, 3, 'Preparar las verduras', 'Pela y corta las zanahorias y papas en trozos medianos. Mézclalas con aceite, sal y romero.'),
(@receta3_id, 4, 'Hornear', 'Coloca el pollo en el centro de la bandeja rodeado de las verduras. Hornea por 40-45 minutos hasta que esté dorado y cocido.'),
(@receta3_id, 5, 'Reposar y servir', 'Deja reposar el pollo 5 minutos antes de cortar. Sirve caliente acompañado de las verduras.');

INSERT INTO informacion_nutricional (id_receta, calorias, grasas, carbohidratos, proteinas) VALUES
(@receta3_id, 420, 18.0, 28.0, 35.0);

-- Receta 4: Tostadas de Queso Gratinado
INSERT INTO receta (nombre, descripcion, imagen_url, tiempo_preparacion, porciones, dificultad) VALUES
('Tostadas de Queso Gratinado', 'Ideal para usar tu pan integral y queso cheddar. Desayuno rápido y delicioso para aprovechar estos ingredientes.', 
'https://placehold.co/600x400/eab308/ffffff?text=Tostadas+Queso', 10, 2, 'Muy Fácil');

SET @receta4_id = LAST_INSERT_ID();

INSERT INTO ingrediente (id_receta, nombre, cantidad, orden) VALUES
(@receta4_id, 'Pan integral', '4 rebanadas', 1),
(@receta4_id, 'Queso cheddar', '250g', 2),
(@receta4_id, 'Mantequilla', '2 cucharadas', 3),
(@receta4_id, 'Tomate', '1 unidad', 4),
(@receta4_id, 'Orégano', '1 cucharadita', 5);

INSERT INTO paso_preparacion (id_receta, numero_paso, titulo, descripcion) VALUES
(@receta4_id, 1, 'Preparar el pan', 'Unta las rebanadas de pan con mantequilla por ambos lados.'),
(@receta4_id, 2, 'Agregar ingredientes', 'Coloca rodajas de tomate sobre cada pan. Cubre generosamente con queso cheddar rallado y espolvorea orégano.'),
(@receta4_id, 3, 'Gratinar', 'Coloca las tostadas en el horno precalentado a 180°C por 5-7 minutos hasta que el queso se derrita y dore.'),
(@receta4_id, 4, 'Servir caliente', 'Retira del horno y sirve inmediatamente mientras están crujientes y el queso está derretido.');

INSERT INTO informacion_nutricional (id_receta, calorias, grasas, carbohidratos, proteinas) VALUES
(@receta4_id, 320, 18.0, 24.0, 16.0);

-- Receta 5: Arroz con Leche
INSERT INTO receta (nombre, descripcion, imagen_url, tiempo_preparacion, porciones, dificultad) VALUES
('Arroz con Leche', 'Postre tradicional perfecto para aprovechar la leche de tu inventario. Dulce, cremoso y reconfortante.', 
'https://placehold.co/600x400/fbbf24/ffffff?text=Arroz+con+Leche', 35, 4, 'Media');

SET @receta5_id = LAST_INSERT_ID();

INSERT INTO ingrediente (id_receta, nombre, cantidad, orden) VALUES
(@receta5_id, 'Leche', '1 litro', 1),
(@receta5_id, 'Arroz', '1 taza', 2),
(@receta5_id, 'Azúcar', '150g', 3),
(@receta5_id, 'Canela en rama', '1 unidad', 4),
(@receta5_id, 'Ralladura de limón', '1 cucharadita', 5),
(@receta5_id, 'Canela en polvo', 'Para decorar', 6);

INSERT INTO paso_preparacion (id_receta, numero_paso, titulo, descripcion) VALUES
(@receta5_id, 1, 'Cocinar el arroz', 'En una olla, hierve el arroz en 2 tazas de agua hasta que esté tierno. Escurre el exceso de agua.'),
(@receta5_id, 2, 'Agregar la leche', 'Añade la leche, azúcar, canela en rama y ralladura de limón al arroz. Mezcla bien.'),
(@receta5_id, 3, 'Cocinar a fuego lento', 'Cocina a fuego medio-bajo, revolviendo frecuentemente, durante 25-30 minutos hasta que espese y el arroz esté cremoso.'),
(@receta5_id, 4, 'Enfriar y servir', 'Retira la canela en rama. Sirve tibio o frío, espolvoreado con canela en polvo.');

INSERT INTO informacion_nutricional (id_receta, calorias, grasas, carbohidratos, proteinas) VALUES
(@receta5_id, 280, 6.0, 48.0, 8.0);

-- Receta 6: Sándwich Integral Completo
INSERT INTO receta (nombre, descripcion, imagen_url, tiempo_preparacion, porciones, dificultad) VALUES
('Sándwich Integral Completo', 'Combina tu pan integral con vegetales frescos. Almuerzo rápido, nutritivo y delicioso.', 
'https://placehold.co/600x400/84cc16/ffffff?text=Sandwich+Integral', 12, 2, 'Fácil');

SET @receta6_id = LAST_INSERT_ID();

INSERT INTO ingrediente (id_receta, nombre, cantidad, orden) VALUES
(@receta6_id, 'Pan integral', '4 rebanadas', 1),
(@receta6_id, 'Lechuga', '100g', 2),
(@receta6_id, 'Tomates', '2 unidades', 3),
(@receta6_id, 'Queso cheddar', '4 rebanadas', 4),
(@receta6_id, 'Jamón de pavo', '4 rebanadas', 5),
(@receta6_id, 'Mayonesa', '2 cucharadas', 6),
(@receta6_id, 'Mostaza', '1 cucharada', 7);

INSERT INTO paso_preparacion (id_receta, numero_paso, titulo, descripcion) VALUES
(@receta6_id, 1, 'Tostar el pan', 'Tuesta ligeramente las rebanadas de pan integral hasta que estén doradas.'),
(@receta6_id, 2, 'Preparar las salsas', 'Mezcla la mayonesa y mostaza. Unta esta mezcla en todas las rebanadas de pan.'),
(@receta6_id, 3, 'Armar el sándwich', 'Sobre 2 rebanadas de pan, coloca lechuga, tomate en rodajas, queso y jamón de pavo.'),
(@receta6_id, 4, 'Cerrar y servir', 'Cubre con las otras rebanadas de pan. Corta en diagonal y sirve inmediatamente.');

INSERT INTO informacion_nutricional (id_receta, calorias, grasas, carbohidratos, proteinas) VALUES
(@receta6_id, 380, 14.0, 38.0, 22.0);

-- Insert demo user (password: demo123)
-- In production, use proper password hashing (BCrypt)
INSERT INTO usuario (nombre, email, contrasena) VALUES
('Usuario Demo', 'demo@example.com', 'demo123');

-- Create inventory for demo user
INSERT INTO inventario (id_usuario) VALUES (1);

-- Insert API user (ID=2) for REST API access
INSERT INTO usuario (nombre, email, contrasena) VALUES
('API User', 'api@foodwastefighter.com', 'api_internal_user');

-- Create inventory for API user
INSERT INTO inventario (id_usuario) VALUES (2);

-- Insert sample foods for demo user's inventory
INSERT INTO alimento (nombre, fecha_caducidad, cantidad, id_categoria, id_inventario) VALUES
('Lechuga', DATE_ADD(CURDATE(), INTERVAL 1 DAY), '1 unidad', 2, 1),
('Pollo fresco', DATE_ADD(CURDATE(), INTERVAL 2 DAY), '1 kg', 4, 1),
('Yogurt natural', DATE_ADD(CURDATE(), INTERVAL 3 DAY), '4 unidades', 3, 1),
('Pan integral', DATE_ADD(CURDATE(), INTERVAL 4 DAY), '1 pieza', 5, 1),
('Tomates', DATE_ADD(CURDATE(), INTERVAL 5 DAY), '500 g', 2, 1),
('Leche', DATE_ADD(CURDATE(), INTERVAL 6 DAY), '1 litro', 3, 1),
('Manzanas', DATE_ADD(CURDATE(), INTERVAL 10 DAY), '1 kg', 1, 1),
('Queso cheddar', DATE_ADD(CURDATE(), INTERVAL 30 DAY), '250 g', 3, 1),
('Zanahorias', DATE_ADD(CURDATE(), INTERVAL 15 DAY), '500 g', 2, 1),
('Huevos', DATE_ADD(CURDATE(), INTERVAL 20 DAY), '12 unidades', 7, 1);

-- Insert sample foods for API user's inventory
INSERT INTO alimento (nombre, fecha_caducidad, cantidad, id_categoria, id_inventario) VALUES
('Naranja API', DATE_ADD(CURDATE(), INTERVAL 7 DAY), '2 kg', 1, 2),
('Leche API', DATE_ADD(CURDATE(), INTERVAL 5 DAY), '2 litros', 3, 2);



-- =============================================================================
-- VERIFICATION QUERIES
-- =============================================================================

-- View all users with their inventories
SELECT u.id_usuario, u.nombre, u.email, i.id_inventario
FROM usuario u
LEFT JOIN inventario i ON u.id_usuario = i.id_usuario;

-- View foods per user
SELECT u.nombre AS usuario, a.nombre AS alimento, a.fecha_caducidad, c.nombre AS categoria
FROM usuario u
JOIN inventario i ON u.id_usuario = i.id_usuario
JOIN alimento a ON i.id_inventario = a.id_inventario
JOIN categoria c ON a.id_categoria = c.id_categoria
ORDER BY u.nombre, a.fecha_caducidad;

-- Ver todas las recetas con su información
SELECT r.id_receta, r.nombre, r.tiempo_preparacion, r.porciones, r.dificultad,
       COUNT(DISTINCT i.id_ingrediente) as total_ingredientes,
       COUNT(DISTINCT p.id_paso) as total_pasos
FROM receta r
LEFT JOIN ingrediente i ON r.id_receta = i.id_receta
LEFT JOIN paso_preparacion p ON r.id_receta = p.id_receta
GROUP BY r.id_receta, r.nombre, r.tiempo_preparacion, r.porciones, r.dificultad;

-- Ver ingredientes de una receta específica
SELECT i.nombre, i.cantidad
FROM ingrediente i
WHERE i.id_receta = 1
ORDER BY i.orden;

-- Ver pasos de preparación de una receta
SELECT p.numero_paso, p.titulo, p.descripcion
FROM paso_preparacion p
WHERE p.id_receta = 1
ORDER BY p.numero_paso;