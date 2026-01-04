# 🥗 Food Waste Fighter

![Java](https://img.shields.io/badge/Java-17-orange)
![Jakarta EE](https://img.shields.io/badge/Jakarta%20EE-10-blue)
![MySQL](https://img.shields.io/badge/MySQL-8.0-blue)
![Apache Tomcat](https://img.shields.io/badge/Tomcat-10.1-yellow)
![Maven](https://img.shields.io/badge/Maven-3.x-red)

**Food Waste Fighter** es una aplicación web Java diseñada para combatir el desperdicio de alimentos en el hogar. Permite gestionar tu despensa de forma inteligente, recibir alertas sobre productos próximos a caducar y tomar decisiones informadas para reducir el desperdicio alimentario.


---

## ✨ Características

- 📦 **Gestión de Inventario**: Registra, edita y elimina alimentos de tu despensa
- 🔔 **Sistema de Alertas Inteligente**: 
  - Alertas críticas (rojas) para productos que caducan en 1-2 días
  - Alertas de advertencia (amarillas) para productos que caducan en 3-5 días
  - Alertas informativas (grises) para productos que caducan en 6+ días
- 📊 **Dashboard Interactivo**: Visualiza el estado de tus alimentos de un vistazo
- 🗂️ **Categorización de Alimentos**: Organiza tus productos por categorías
- 📅 **Control de Fechas de Caducidad**: Monitoreo automático de fechas de vencimiento
- 🌐 **Interfaz Responsiva**: Diseñada con Tailwind CSS para una experiencia fluida en cualquier dispositivo

---

## 🛠️ Tecnologías

### Backend
- **Java 17** - Lenguaje de programación principal
- **Jakarta EE 10** - Plataforma empresarial (Servlets, JSP, JSTL)
- **JPA 3.0** con **EclipseLink 4.0.2** como proveedor y ORM para persistencia de datos
- **EclipseLink** - Implementación de JPA
- **Maven 3.x** - Gestor de dependencias y construcción

### Frontend
- **JSP (Jakarta Server Pages)** - Vistas dinámicas
- **JSTL** - Librería de etiquetas estándar
- **Tailwind CSS** - Framework de CSS utility-first
- **HTML5 & CSS3** - Estructura y estilos

### Base de Datos
- **MySQL 8.0** - Sistema de gestión de base de datos relacional

### Servidor
- **Apache Tomcat 10.1** - Contenedor de servlets

---

## 📋 Requisitos Previos

Antes de comenzar, asegúrate de tener instalado:

- ☕ **JDK 17** o superior ([Descargar](https://www.oracle.com/java/technologies/downloads/#java17))
- 🐬 **MySQL 8.0** o superior ([Descargar](https://dev.mysql.com/downloads/mysql/))
- 📦 **Apache Maven 3.6+** ([Descargar](https://maven.apache.org/download.cgi))
- 🐱 **Apache Tomcat 10.1** ([Descargar](https://tomcat.apache.org/download-10.cgi))
- 💻 **IDE** recomendado: Eclipse IDE for Enterprise Java Developers o IntelliJ IDEA

---

## 🚀 Instalación

### 1. Clonar el Repositorio

```bash
git clone https://github.com/tu-usuario/food-waste-fighter.git
cd food-waste-fighter
```

### 2. Configurar la Base de Datos

#### Opción A: Desde la línea de comandos (CMD en Windows)

1. **Abrir el símbolo del sistema (CMD)** como administrador

2. **Acceder a MySQL** (reemplaza `root` por tu usuario si es diferente):
```cmd
mysql -u root -p
```

3. **Crear la base de datos**:
```sql
CREATE DATABASE IF NOT EXISTS foodwastefighter 
CHARACTER SET utf8mb4 
COLLATE utf8mb4_unicode_ci;
```

4. **Salir de MySQL**:
```sql
EXIT;
```

5. **Importar el archivo SQL** (asegúrate de estar en el directorio correcto):
```cmd
mysql -u root -p foodwastefighter < init_database_sql.sql
```

Si el archivo `init_database_sql.sql` está en otra ubicación, usa la ruta completa:
```cmd
mysql -u root -p foodwastefighter < "C:\ruta\completa\init_database_sql.sql"
```

6. **Verificar que las tablas se crearon correctamente**:
```cmd
mysql -u root -p foodwastefighter -e "SHOW TABLES;"
```

---

## 📁 Estructura del Proyecto

```
Food_Waste_Fighter/
├── src/
│   └── main/
│       ├── java/
│       │   ├── control/              # Servlets (Controladores)
│       │   │   ├── AlimentoController.java
│       │   │   └── GestorCaducidadController.java
│       │   ├── DAO/                  # Data Access Objects
│       │   │   ├── AlimentoDAO.java
│       │   │   ├── CategoriaDAO.java
│       │   │   └── InventarioDAO.java
│       │   └── entities/             # Entidades JPA
│       │       ├── Alimento.java
│       │       ├── Categoria.java
│       │       └── Inventario.java
│       └── webapp/
│           ├── css/                  # Estilos personalizados
│           ├── META-INF/
│           │   └── persistence.xml   # Configuración JPA
│           ├── WEB-INF/
│           │   └── web.xml          # Configuración del servlet
│           ├── dashboard.jsp         # Dashboard principal
│           ├── landing.html          # Página de inicio
│           ├── listarAlimentos.jsp   # Lista de alimentos
│           ├── registrarAlimento.jsp # Formulario de registro
│           ├── editarAlimento.jsp    # Formulario de edición
│           └── eliminarAlimento.jsp  # Confirmación de eliminación
├── target/                           # Archivos compilados
├── pom.xml                          # Configuración Maven
└── README.md                        # Este archivo
```

---

