-- =============================================================================
-- FOOD WASTE FIGHTER - SCRIPT DE INICIALIZACIÓN DE BASE DE DATOS
-- =============================================================================

-- Crear la base de datos
CREATE DATABASE IF NOT EXISTS foodwastefighter
CHARACTER SET utf8mb4
COLLATE utf8mb4_unicode_ci;

USE foodwastefighter;

-- =============================================================================
-- ELIMINAR TABLAS SI EXISTEN (en orden por dependencias)
-- =============================================================================
DROP TABLE IF EXISTS ingrediente_receta;
DROP TABLE IF EXISTS receta;
DROP TABLE IF EXISTS alimento;
DROP TABLE IF EXISTS categoria;
DROP TABLE IF EXISTS usuario;

-- =============================================================================
-- CREAR TABLAS
-- =============================================================================

-- Tabla: usuario
CREATE TABLE usuario (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    contrasena VARCHAR(255) NOT NULL,
    fecha_registro TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_email (email)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Tabla: categoria
CREATE TABLE categoria (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL UNIQUE,
    descripcion VARCHAR(200),
    INDEX idx_nombre (nombre)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Tabla: alimento
CREATE TABLE alimento (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    fecha_caducidad DATE NOT NULL,
    cantidad VARCHAR(50),
    categoria_id BIGINT NOT NULL,
    usuario_id BIGINT NOT NULL,
    fecha_registro TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (categoria_id) REFERENCES categoria(id) ON DELETE RESTRICT,
    FOREIGN KEY (usuario_id) REFERENCES usuario(id) ON DELETE CASCADE,
    INDEX idx_fecha_caducidad (fecha_caducidad),
    INDEX idx_usuario (usuario_id),
    INDEX idx_categoria (categoria_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Tabla: receta
CREATE TABLE receta (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(150) NOT NULL,
    descripcion TEXT,
    tiempo_preparacion INT, -- en minutos
    dificultad VARCHAR(20), -- facil, media, dificil
    instrucciones TEXT,
    usuario_id BIGINT NOT NULL,
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (usuario_id) REFERENCES usuario(id) ON DELETE CASCADE,
    INDEX idx_usuario (usuario_id),
    INDEX idx_dificultad (dificultad)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Tabla: ingrediente_receta (relación muchos a muchos)
CREATE TABLE ingrediente_receta (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    receta_id BIGINT NOT NULL,
    alimento_id BIGINT NOT NULL,
    cantidad VARCHAR(50),
    FOREIGN KEY (receta_id) REFERENCES receta(id) ON DELETE CASCADE,
    FOREIGN KEY (alimento_id) REFERENCES alimento(id) ON DELETE CASCADE,
    UNIQUE KEY uk_receta_alimento (receta_id, alimento_id),
    INDEX idx_receta (receta_id),
    INDEX idx_alimento (alimento_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =============================================================================
-- INSERTAR DATOS INICIALES
-- =============================================================================

-- Insertar usuario de prueba
INSERT INTO usuario (nombre, email, contrasena) VALUES
('Usuario Demo', 'demo@foodwastefighter.com', 'demo123'),
('Carlos Pérez', 'carlos@example.com', 'carlos123'),
('María González', 'maria@example.com', 'maria123');

-- Insertar categorías
INSERT INTO categoria (nombre, descripcion) VALUES
('Frutas', 'Frutas frescas y derivados'),
('Verduras', 'Verduras y hortalizas'),
('Lácteos', 'Leche, queso, yogurt y derivados'),
('Carnes', 'Carnes rojas, blancas y embutidos'),
('Panadería', 'Pan, pasteles y productos de panadería'),
('Pescados', 'Pescados y mariscos'),
('Huevos', 'Huevos y productos derivados'),
('Cereales', 'Cereales, granos y legumbres'),
('Bebidas', 'Bebidas en general'),
('Otros', 'Otros productos alimenticios');

-- Insertar alimentos de ejemplo para el usuario demo (id=1)
-- Productos críticos (1-2 días)
INSERT INTO alimento (nombre, fecha_caducidad, cantidad, categoria_id, usuario_id) VALUES
('Lechuga', DATE_ADD(CURDATE(), INTERVAL 1 DAY), '1 unidad', 2, 1),
('Pollo fresco', DATE_ADD(CURDATE(), INTERVAL 2 DAY), '1 kg', 4, 1);

-- Productos advertencia (3-5 días)
INSERT INTO alimento (nombre, fecha_caducidad, cantidad, categoria_id, usuario_id) VALUES
('Yogurt natural', DATE_ADD(CURDATE(), INTERVAL 3 DAY), '4 unidades', 3, 1),
('Pan integral', DATE_ADD(CURDATE(), INTERVAL 4 DAY), '1 pieza', 5, 1),
('Tomates', DATE_ADD(CURDATE(), INTERVAL 5 DAY), '500 g', 2, 1);

-- Productos normales (6+ días)
INSERT INTO alimento (nombre, fecha_caducidad, cantidad, categoria_id, usuario_id) VALUES
('Leche', DATE_ADD(CURDATE(), INTERVAL 6 DAY), '1 litro', 3, 1),
('Manzanas', DATE_ADD(CURDATE(), INTERVAL 10 DAY), '1 kg', 1, 1),
('Queso cheddar', DATE_ADD(CURDATE(), INTERVAL 30 DAY), '250 g', 3, 1),
('Zanahorias', DATE_ADD(CURDATE(), INTERVAL 15 DAY), '500 g', 2, 1),
('Huevos', DATE_ADD(CURDATE(), INTERVAL 20 DAY), '12 unidades', 7, 1);

-- Insertar recetas de ejemplo
INSERT INTO receta (nombre, descripcion, tiempo_preparacion, dificultad, instrucciones, usuario_id) VALUES
('Ensalada César', 'Ensalada fresca con pollo y aderezo césar', 15, 'facil', 
'1. Lavar y cortar la lechuga\n2. Cocinar el pollo a la plancha\n3. Preparar el aderezo\n4. Mezclar todos los ingredientes', 1),

('Omelette de verduras', 'Omelette nutritivo con verduras frescas', 10, 'facil',
'1. Batir los huevos\n2. Picar las verduras\n3. Cocinar en sartén\n4. Servir caliente', 1),

('Pollo al horno con verduras', 'Pollo jugoso con vegetales asados', 45, 'media',
'1. Precalentar horno a 180°C\n2. Condimentar el pollo\n3. Cortar las verduras\n4. Hornear por 40 minutos', 1);

-- Relacionar ingredientes con recetas
-- Ensalada César
INSERT INTO ingrediente_receta (receta_id, alimento_id, cantidad) VALUES
(1, 1, '200 g'), -- Lechuga
(1, 2, '150 g'); -- Pollo

-- Omelette de verduras
INSERT INTO ingrediente_receta (receta_id, alimento_id, cantidad) VALUES
(2, 5, '2 unidades'), -- Tomates
(2, 10, '2 unidades'); -- Huevos

-- Pollo al horno con verduras
INSERT INTO ingrediente_receta (receta_id, alimento_id, cantidad) VALUES
(3, 2, '500 g'), -- Pollo
(3, 10, '200 g'), -- Zanahorias
(3, 5, '150 g'); -- Tomates

-- =============================================================================
-- CONSULTAS DE VERIFICACIÓN
-- =============================================================================

-- Ver todos los usuarios
SELECT * FROM usuario;

-- Ver todas las categorías
SELECT * FROM categoria;

-- Ver todos los alimentos con sus categorías
SELECT 
    a.id,
    a.nombre,
    a.fecha_caducidad,
    a.cantidad,
    c.nombre AS categoria,
    u.nombre AS usuario,
    DATEDIFF(a.fecha_caducidad, CURDATE()) AS dias_para_caducar
FROM alimento a
JOIN categoria c ON a.categoria_id = c.id
JOIN usuario u ON a.usuario_id = u.id
ORDER BY a.fecha_caducidad;

-- Ver productos próximos a caducar (menos de 30 días)
SELECT 
    a.nombre,
    a.fecha_caducidad,
    c.nombre AS categoria,
    DATEDIFF(a.fecha_caducidad, CURDATE()) AS dias_restantes,
    CASE 
        WHEN DATEDIFF(a.fecha_caducidad, CURDATE()) <= 2 THEN 'CRÍTICO'
        WHEN DATEDIFF(a.fecha_caducidad, CURDATE()) <= 5 THEN 'ADVERTENCIA'
        ELSE 'NORMAL'
    END AS estado
FROM alimento a
JOIN categoria c ON a.categoria_id = c.id
WHERE a.usuario_id = 1 
  AND a.fecha_caducidad <= DATE_ADD(CURDATE(), INTERVAL 30 DAY)
ORDER BY a.fecha_caducidad;

-- Ver recetas con sus ingredientes
SELECT 
    r.nombre AS receta,
    r.tiempo_preparacion,
    r.dificultad,
    a.nombre AS ingrediente,
    ir.cantidad
FROM receta r
LEFT JOIN ingrediente_receta ir ON r.id = ir.receta_id
LEFT JOIN alimento a ON ir.alimento_id = a.id
WHERE r.usuario_id = 1
ORDER BY r.nombre, a.nombre;

-- =============================================================================
-- INFORMACIÓN ADICIONAL
-- =============================================================================

-- Para crear un nuevo usuario:
-- INSERT INTO usuario (nombre, email, contrasena) VALUES ('Tu Nombre', 'tu@email.com', 'tupassword');

-- Para agregar un nuevo alimento:
-- INSERT INTO alimento (nombre, fecha_caducidad, cantidad, categoria_id, usuario_id) 
-- VALUES ('Nombre Producto', '2025-12-31', '1 unidad', 1, 1);

-- Para ver estadísticas del inventario:
SELECT 
    c.nombre AS categoria,
    COUNT(a.id) AS total_productos,
    SUM(CASE WHEN DATEDIFF(a.fecha_caducidad, CURDATE()) <= 2 THEN 1 ELSE 0 END) AS criticos,
    SUM(CASE WHEN DATEDIFF(a.fecha_caducidad, CURDATE()) BETWEEN 3 AND 5 THEN 1 ELSE 0 END) AS advertencia,
    SUM(CASE WHEN DATEDIFF(a.fecha_caducidad, CURDATE()) > 5 THEN 1 ELSE 0 END) AS normales
FROM categoria c
LEFT JOIN alimento a ON c.id = a.categoria_id AND a.usuario_id = 1
GROUP BY c.id, c.nombre
ORDER BY c.nombre;
