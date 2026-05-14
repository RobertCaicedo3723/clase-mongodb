# Taller 3 - Bases de Datos II UIS 2026
## Bases de Datos NoSQL Orientadas a Grafos con Neo4j

**Integrantes:** Kaleth Ceballos, Robert Caicedo  
**Grupo:** E1  
**Docente:** Jathinson Meneses Mendoza  
**Fecha:** Mayo de 2026  
**Universidad Industrial de Santander - Escuela de Ingenieria de Sistemas e Informatica**

---

## Descripcion del proyecto

Implementacion de una red social corporativa para una empresa colombiana, modelada como base de datos orientada a grafos en Neo4j. El modelo captura empleados distribuidos por el pais con su cadena de mando jerarquica, publicaciones en muros personales, interacciones sociales (me gusta, comentarios, amistades) y un sistema de reportes de acoso laboral para analisis de patrones.

---

## Modelo de datos

### Nodos

| Label | Atributos clave |
|---|---|
| `Empleado` | `codigoEmpresarial` (PK), `documento` (unico), `nombre`, `apellidos`, `edad`, `cargo` |
| `Post` | `id` (PK), `fecha`, `titulo`, `descripcion` |
| `Comentario` | `id` (PK), `fecha`, `descripcion` |
| `Reporte` | `id` (PK), `fecha`, `naturaleza` |

La cantidad de me gusta de un Post se deriva contando relaciones `:DIO_LIKE` entrantes; no es un atributo almacenado.

### Relaciones

| Tipo | Origen -> Destino | Descripcion |
|---|---|---|
| `:JEFE_DE` | `Empleado` -> `Empleado` | Cadena de mando jerarquica (solo entre cargos adyacentes) |
| `:AMIGO_DE` | `Empleado` -> `Empleado` | Amistad corporativa (una sola arista, consultas sin direccion) |
| `:PUBLICO` | `Empleado` -> `Post` | Autoria del post |
| `:DIO_LIKE` | `Empleado` -> `Post` | Me gusta dado por el empleado |
| `:COMENTO` | `Empleado` -> `Comentario` | Autoria del comentario |
| `:EN_POST` | `Comentario` -> `Post` | Comentario pertenece al post |
| `:GENERA` | `Empleado` -> `Reporte` | Empleado que realiza el reporte |
| `:CONTRA` | `Reporte` -> `Empleado` | Empleado reportado |

### Cadena de mando

```
Gerente --> Lider Regional --> Lider Seccional --> Administrador --> Empleado
```

La relacion `:JEFE_DE` solo puede existir entre cargos inmediatamente adyacentes en esta cadena.

### Esquema ASCII del grafo

```
(:Empleado)---[:JEFE_DE]--->(:Empleado)
     |
     |---[:AMIGO_DE]--->(:Empleado)
     |
     |---[:PUBLICO]--->(:Post)
     |                     ^
     |---[:DIO_LIKE]--------|
     |
     |---[:COMENTO]--->(:Comentario)---[:EN_POST]--->(:Post)
     |
     |---[:GENERA]--->(:Reporte)---[:CONTRA]--->(:Empleado)
```

### Naturaleza del Reporte (enum)

Valores validos: `maltrato`, `persecucion`, `discriminacion`, `entorpecimiento`, `inequidad`, `desproteccion`, `acoso sexual`

---

## Requisitos

- Neo4j Desktop 1.5 o superior
- Neo4j Community Edition 5.x (local)
- Python 3.10+ con libreria `python-docx` (solo para regenerar el informe Word)

---

## Como cargar los datos paso a paso

### 1. Crear la base de datos en Neo4j Desktop

1. Abrir Neo4j Desktop.
2. En el proyecto deseado, hacer clic en **Add** > **Local DBMS**.
3. Asignarle un nombre (ej. `TallerGrafos`), version Neo4j 5.x y una contrasena.
4. Iniciar la base de datos.

### 2. Copiar los CSVs a la carpeta import

1. En Neo4j Desktop, hacer clic en los tres puntos (...) junto a la base de datos.
2. Seleccionar **Open Folder** > **Import**.
3. Copiar **todos los archivos** de la carpeta `data/` de este proyecto hacia esa carpeta `import`.

### 3. Ejecutar los scripts en Neo4j Browser

Abrir Neo4j Browser (boton **Open** en Neo4j Desktop) y ejecutar los scripts en este orden:

```
-- Opcional: solo si la base ya tenia datos previos --
Ejecutar: scripts/00_reset_db.cypher

-- Obligatorio siempre --
Ejecutar: scripts/01_schema_constraints.cypher
Ejecutar: scripts/02_carga_csv.cypher
```

### 4. Validar la carga

Ejecutar en Neo4j Browser:

```cypher
MATCH (n) RETURN count(n);
-- Resultado esperado: 77 nodos (18 Empleados + 18 Posts + 36 Comentarios + 5 Reportes)

MATCH ()-[r]->() RETURN type(r), count(r) ORDER BY type(r);
-- Muestra el conteo de cada tipo de relacion
```

### 5. Ejecutar los demas scripts (orden recomendado)

```
scripts/03_queries_insercion.cypher   -- Operaciones de insercion
scripts/04_queries_update.cypher      -- Operaciones de actualizacion
scripts/05_queries_delete.cypher      -- Operaciones de eliminacion
scripts/06_queries_search_red.cypher  -- Busquedas: red social y jerarquia
scripts/07_queries_search_posts.cypher -- Busquedas: posts y comentarios
scripts/08_queries_search_acoso.cypher -- Busquedas: reportes de acoso
scripts/09_queries_principales.cypher  -- Consultas principales del analisis
```

**Nota:** Los scripts de delete modifican los datos. Si se desea conservar el estado original para las demas consultas, ejecutar `00_reset_db.cypher` y volver a cargar los datos antes de correr `05_queries_delete.cypher`.

---

## Estructura del proyecto

```
Taller3_BDII_Ceballos_Caicedo/
├── README.md
├── data/
│   ├── empleados.csv
│   ├── posts.csv
│   ├── comentarios.csv
│   ├── reportes.csv
│   ├── rel_jefe_de.csv
│   ├── rel_amigo_de.csv
│   ├── rel_publico.csv
│   ├── rel_comento_post.csv
│   ├── rel_dio_like.csv
│   ├── rel_genera_reporte.csv
│   └── rel_contra_reporte.csv
├── scripts/
│   ├── 00_reset_db.cypher
│   ├── 01_schema_constraints.cypher
│   ├── 02_carga_csv.cypher
│   ├── 03_queries_insercion.cypher
│   ├── 04_queries_update.cypher
│   ├── 05_queries_delete.cypher
│   ├── 06_queries_search_red.cypher
│   ├── 07_queries_search_posts.cypher
│   ├── 08_queries_search_acoso.cypher
│   └── 09_queries_principales.cypher
├── evidencias/
│   └── .gitkeep
└── informe/
    └── Taller3_BDII_Ceballos_Caicedo.docx
```

---

## Creditos

**Estudiantes:** Kaleth Ceballos, Robert Caicedo  
**Curso:** Bases de Datos II - Grupo E1  
**Docente:** Jathinson Meneses Mendoza  
**Universidad Industrial de Santander - UIS 2026**
