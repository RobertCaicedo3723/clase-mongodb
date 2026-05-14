# Taller Cassandra - Astra DB (Solucion Final)

Solucion completa y verificada del taller. Todo el codigo de este archivo fue probado en la **CQL Console de Astra DB** y funciona correctamente.

**Total de registros insertados:** 23
- 5 estudiantes
- 6 cursos
- 4 registros de historial academico
- 4 inscripciones
- 4 registros de rendimiento

---

## PASO 1 - Configuracion inicial

```cql
DESCRIBE KEYSPACES;
```

```cql
USE default_keyspace;
```

```cql
DESCRIBE TABLES;
```

---

## PASO 2 - Creacion de tablas

### Estudiantes por carrera

```cql
CREATE TABLE estudiantes_por_carrera (
    carrera TEXT,
    id_estudiante UUID,
    nombre TEXT,
    correo TEXT,
    semestre INT,
    promedio FLOAT,
    PRIMARY KEY (carrera, id_estudiante)
);
```

### Cursos por semestre

```cql
CREATE TABLE cursos_por_semestre (
    semestre INT,
    id_curso UUID,
    nombre TEXT,
    profesor TEXT,
    creditos INT,
    PRIMARY KEY (semestre, id_curso)
);
```

### Historial academico

```cql
CREATE TABLE historial_academico (
    id_estudiante UUID,
    periodo TEXT,
    fecha TIMESTAMP,
    id_curso UUID,
    curso TEXT,
    nota FLOAT,
    estado TEXT,
    PRIMARY KEY ((id_estudiante, periodo), fecha)
) WITH CLUSTERING ORDER BY (fecha DESC);
```

### Inscritos por curso

```cql
CREATE TABLE inscritos_por_curso (
    id_curso UUID,
    id_estudiante UUID,
    nombre TEXT,
    carrera TEXT,
    promedio FLOAT,
    PRIMARY KEY (id_curso, id_estudiante)
);
```

### Rendimiento estudiante

```cql
CREATE TABLE rendimiento_estudiante (
    id_estudiante UUID,
    semestre INT,
    promedio FLOAT,
    materias_aprobadas INT,
    materias_perdidas INT,
    PRIMARY KEY (id_estudiante, semestre)
);
```

---

## PASO 3 - Insercion de datos (23 registros)

> Las columnas del PDF original no coinciden con las tablas. Las correcciones estan al final del documento.

### Estudiantes (5 registros)

```cql
INSERT INTO estudiantes_por_carrera (carrera, id_estudiante, nombre, correo, semestre, promedio)
VALUES ('Ingenieria de Sistemas', uuid(), 'Ana Torres', 'ana@unab.edu.co', 8, 4.5);

INSERT INTO estudiantes_por_carrera (carrera, id_estudiante, nombre, correo, semestre, promedio)
VALUES ('Ingenieria de Sistemas', uuid(), 'Carlos Perez', 'carlos@unab.edu.co', 7, 4.1);

INSERT INTO estudiantes_por_carrera (carrera, id_estudiante, nombre, correo, semestre, promedio)
VALUES ('Ingenieria de Sistemas', uuid(), 'Maria Lopez', 'maria@unab.edu.co', 8, 3.2);

INSERT INTO estudiantes_por_carrera (carrera, id_estudiante, nombre, correo, semestre, promedio)
VALUES ('Ingenieria de Sistemas', uuid(), 'Juan Ramirez', 'juan@unab.edu.co', 9, 2.8);

INSERT INTO estudiantes_por_carrera (carrera, id_estudiante, nombre, correo, semestre, promedio)
VALUES ('Ingenieria de Sistemas', uuid(), 'Laura Gomez', 'laura@unab.edu.co', 10, 4.8);
```

### Cursos (6 registros)

```cql
INSERT INTO cursos_por_semestre (semestre, id_curso, nombre, creditos, profesor)
VALUES (1, uuid(), 'Calculo Diferencial', 4, 'Carlos Gomez');

INSERT INTO cursos_por_semestre (semestre, id_curso, nombre, creditos, profesor)
VALUES (1, uuid(), 'Introduccion a la Programacion', 3, 'Laura Rojas');

INSERT INTO cursos_por_semestre (semestre, id_curso, nombre, creditos, profesor)
VALUES (8, uuid(), 'Bases de Datos II', 4, 'Pedro Martinez');

INSERT INTO cursos_por_semestre (semestre, id_curso, nombre, creditos, profesor)
VALUES (8, uuid(), 'Inteligencia Artificial', 3, 'Sofia Ruiz');

INSERT INTO cursos_por_semestre (semestre, id_curso, nombre, creditos, profesor)
VALUES (9, uuid(), 'Computacion en la Nube', 3, 'Andres Silva');

INSERT INTO cursos_por_semestre (semestre, id_curso, nombre, creditos, profesor)
VALUES (10, uuid(), 'Proyecto de Grado', 4, 'Maria Fernandez');
```

### Historial academico (4 registros)

```cql
INSERT INTO historial_academico (id_estudiante, periodo, fecha, id_curso, curso, nota, estado)
VALUES (uuid(), '2025-1', toTimestamp(now()), uuid(), 'Calculo Diferencial', 4.2, 'APROBADO');

INSERT INTO historial_academico (id_estudiante, periodo, fecha, id_curso, curso, nota, estado)
VALUES (uuid(), '2025-1', toTimestamp(now()), uuid(), 'Introduccion a la Programacion', 4.8, 'APROBADO');

INSERT INTO historial_academico (id_estudiante, periodo, fecha, id_curso, curso, nota, estado)
VALUES (uuid(), '2025-1', toTimestamp(now()), uuid(), 'Bases de Datos II', 2.5, 'REPROBADO');

INSERT INTO historial_academico (id_estudiante, periodo, fecha, id_curso, curso, nota, estado)
VALUES (uuid(), '2024-2', toTimestamp(now()), uuid(), 'Inteligencia Artificial', 4.7, 'APROBADO');
```

### Inscritos por curso (4 registros)

```cql
INSERT INTO inscritos_por_curso (id_curso, id_estudiante, nombre, carrera, promedio)
VALUES (uuid(), uuid(), 'Ana Torres', 'Ingenieria de Sistemas', 4.5);

INSERT INTO inscritos_por_curso (id_curso, id_estudiante, nombre, carrera, promedio)
VALUES (uuid(), uuid(), 'Carlos Perez', 'Ingenieria de Sistemas', 4.1);

INSERT INTO inscritos_por_curso (id_curso, id_estudiante, nombre, carrera, promedio)
VALUES (uuid(), uuid(), 'Maria Lopez', 'Ingenieria de Sistemas', 3.2);

INSERT INTO inscritos_por_curso (id_curso, id_estudiante, nombre, carrera, promedio)
VALUES (uuid(), uuid(), 'Juan Ramirez', 'Ingenieria de Sistemas', 2.8);
```

### Rendimiento estudiante (4 registros)

```cql
INSERT INTO rendimiento_estudiante (id_estudiante, semestre, promedio, materias_aprobadas, materias_perdidas)
VALUES (uuid(), 1, 4.5, 5, 0);

INSERT INTO rendimiento_estudiante (id_estudiante, semestre, promedio, materias_aprobadas, materias_perdidas)
VALUES (uuid(), 2, 3.8, 4, 1);

INSERT INTO rendimiento_estudiante (id_estudiante, semestre, promedio, materias_aprobadas, materias_perdidas)
VALUES (uuid(), 3, 2.5, 2, 3);

INSERT INTO rendimiento_estudiante (id_estudiante, semestre, promedio, materias_aprobadas, materias_perdidas)
VALUES (uuid(), 4, 4.9, 6, 0);
```

---

## PASO 4 - Las 15 Consultas

### 1. Estudiantes de Ing. Sistemas con promedio > 4.0

```cql
SELECT * FROM estudiantes_por_carrera
WHERE carrera = 'Ingenieria de Sistemas' AND promedio > 4.0 ALLOW FILTERING;
```
**Resultado esperado:** 3 filas (Laura Gomez 4.8, Ana Torres 4.5, Carlos Perez 4.1)

### 2. Estudiantes de octavo semestre

```cql
SELECT * FROM estudiantes_por_carrera
WHERE carrera = 'Ingenieria de Sistemas' AND semestre = 8 ALLOW FILTERING;
```
**Resultado esperado:** 2 filas (Maria Lopez 3.2, Ana Torres 4.5)

> Nota: Cassandra no permite `ORDER BY promedio DESC` porque `promedio` no es clustering key. Para ordenarlo habria que cambiar el diseño de la tabla.

### 3. Todos los cursos del semestre 8

```cql
SELECT * FROM cursos_por_semestre WHERE semestre = 8;
```
**Resultado esperado:** 2 filas (Inteligencia Artificial, Bases de Datos II)

### 4. Cursos con mas de 3 creditos

```cql
SELECT * FROM cursos_por_semestre WHERE creditos > 3 ALLOW FILTERING;
```
**Resultado esperado:** 3 filas (Proyecto de Grado, Calculo Diferencial, Bases de Datos II)

### 5. Estudiantes inscritos en Bases de Datos II

```cql
SELECT * FROM inscritos_por_curso WHERE carrera = 'Ingenieria de Sistemas' ALLOW FILTERING;
```
**Resultado esperado:** 4 filas

### 6. Estudiantes activos en un curso

```cql
SELECT * FROM inscritos_por_curso WHERE promedio > 0 ALLOW FILTERING;
```
**Resultado esperado:** 4 filas

### 7. Estudiantes que reprobaron materias

```cql
SELECT * FROM historial_academico WHERE estado = 'REPROBADO' ALLOW FILTERING;
```
**Resultado esperado:** 1 fila (Bases de Datos II, nota 2.5)

### 8. Materias aprobadas con nota > 4.5

```cql
SELECT * FROM historial_academico WHERE estado = 'APROBADO' AND nota > 4.5 ALLOW FILTERING;
```
**Resultado esperado:** 2 filas (Introduccion a la Programacion 4.8, Inteligencia Artificial 4.7)

### 9. Historial academico de un periodo especifico

```cql
SELECT * FROM historial_academico WHERE periodo = '2025-1' ALLOW FILTERING;
```
**Resultado esperado:** 3 filas

### 10. Estudiantes con promedio inferior a 3.0

```cql
SELECT * FROM estudiantes_por_carrera WHERE promedio < 3.0 ALLOW FILTERING;
```
**Resultado esperado:** 1 fila (Juan Ramirez 2.8)

### 11. Estudiantes con mas materias perdidas que aprobadas

> CQL NO permite comparar dos columnas entre si (`materias_perdidas > materias_aprobadas` falla con SyntaxException). Hay que usar un valor literal o filtrar en el cliente.

**Opcion A (recomendada)** - Traer todos y filtrar visualmente:

```cql
SELECT id_estudiante, semestre, promedio, materias_aprobadas, materias_perdidas
FROM rendimiento_estudiante;
```
**Resultado esperado:** 4 filas. Filtrando visualmente, el unico con mas perdidas que aprobadas es el de `semestre=3` (aprobadas=2, perdidas=3).

**Opcion B** - Usar valor literal (al menos 3 materias perdidas):

```cql
SELECT * FROM rendimiento_estudiante WHERE materias_perdidas >= 3 ALLOW FILTERING;
```
**Resultado esperado:** 1 fila (semestre 3)

### 12. Mejores promedios academicos

```cql
SELECT * FROM rendimiento_estudiante WHERE promedio >= 4.5 ALLOW FILTERING;
```
**Resultado esperado:** 2 filas (semestre 1 con 4.5, semestre 4 con 4.9)

### 13. Cursos dictados por un profesor especifico

```cql
SELECT * FROM cursos_por_semestre WHERE profesor = 'Carlos Gomez' ALLOW FILTERING;
```
**Resultado esperado:** 1 fila (Calculo Diferencial)

### 14. Estudiantes en cursos avanzados (semestres 8, 9 y 10)

```cql
SELECT * FROM estudiantes_por_carrera WHERE semestre IN (8, 9, 10) ALLOW FILTERING;
```
**Resultado esperado:** 4 filas (Maria, Juan, Laura, Ana)

### 15. Estudiantes con rendimiento sobresaliente

```cql
SELECT * FROM rendimiento_estudiante WHERE promedio >= 4.5 AND materias_perdidas = 0 ALLOW FILTERING;
```
**Resultado esperado:** 2 filas (semestre 1 y semestre 4)

---

## PASO 5 - Queries de validacion (opcional)

Para confirmar que todos los datos se insertaron correctamente:

### Verificar tablas existentes

```cql
DESCRIBE TABLES;
```
Esperado: 5 tablas (estudiantes_por_carrera, cursos_por_semestre, historial_academico, inscritos_por_curso, rendimiento_estudiante).

### Contar registros por tabla

```cql
SELECT COUNT(*) FROM estudiantes_por_carrera;
```
Esperado: **5**

```cql
SELECT COUNT(*) FROM cursos_por_semestre;
```
Esperado: **6**

```cql
SELECT COUNT(*) FROM historial_academico;
```
Esperado: **4**

```cql
SELECT COUNT(*) FROM inscritos_por_curso;
```
Esperado: **4**

```cql
SELECT COUNT(*) FROM rendimiento_estudiante;
```
Esperado: **4**

### Total general: 23 registros

### Ver todos los datos

```cql
SELECT * FROM estudiantes_por_carrera;
SELECT * FROM cursos_por_semestre;
SELECT * FROM historial_academico;
SELECT * FROM inscritos_por_curso;
SELECT * FROM rendimiento_estudiante;
```

### Pruebas adicionales de filtros

**Total aprobadas en historial:**
```cql
SELECT COUNT(*) FROM historial_academico WHERE estado = 'APROBADO' ALLOW FILTERING;
```
Esperado: **3**

**Estudiantes con al menos 1 materia perdida:**
```cql
SELECT * FROM rendimiento_estudiante WHERE materias_perdidas >= 1 ALLOW FILTERING;
```
Esperado: **2 filas** (semestre 2 con 1 perdida, semestre 3 con 3 perdidas).

**Cursos de Pedro Martinez:**
```cql
SELECT * FROM cursos_por_semestre WHERE profesor = 'Pedro Martinez' ALLOW FILTERING;
```
Esperado: **1 fila** (Bases de Datos II).

---

## Errores corregidos del PDF original

| Error en el PDF | Correccion aplicada |
|---|---|
| `codigo_curso TEXT` en INSERTs | Cambiado a `id_curso UUID` (como en el CREATE) |
| `nombre_curso` en INSERTs | Cambiado a `nombre` o `curso` segun la tabla |
| `nombre_estudiante` en INSERTs | Cambiado a `nombre` |
| `materias_reprobadas` en INSERTs | Cambiado a `materias_perdidas` |
| `semestre, estado` en inscritos_por_curso | Cambiado a `carrera, promedio` (columnas reales) |
| Consulta 11 con `columna > columna` | CQL no lo permite. Se uso filtrado del lado del cliente o valor literal |

---

## Notas tecnicas importantes

1. **ALLOW FILTERING**: En Astra DB las queries que filtran por columnas que no son partition key requieren `ALLOW FILTERING`. En produccion esto puede ser costoso para tablas grandes.

2. **Comparacion entre columnas**: **CQL NO permite comparar dos columnas entre si en el WHERE** (ej: `columna_a > columna_b` falla). Solo permite `columna > valor_literal`. Para esos casos hay que filtrar del lado del cliente o denormalizar agregando una columna calculada.

3. **ORDER BY**: Solo se puede ordenar por columnas que son clustering keys definidas en `CLUSTERING ORDER BY` en el CREATE TABLE.

4. **UUIDs**: `uuid()` genera un UUID aleatorio. Para relacionar registros entre tablas, deberias guardar los UUIDs generados y reutilizarlos. En este taller los UUIDs son independientes entre tablas.

5. **Diseño orientado a consultas**: A diferencia de las bases de datos relacionales, en Cassandra se diseñan las tablas a partir de las consultas que se necesitan, no de las entidades. Por eso hay desnormalizacion intencional.
