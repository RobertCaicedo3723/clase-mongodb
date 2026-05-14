# Taller Cassandra - Astra DB

**Modelado distribuido, optimizacion y analisis de rendimiento en Cassandra usando Astra DB Cloud**

- **Autor:** Robert Caicedo Sanchez
- **Codigo:** 2224513
- **Programa:** Ingenieria de Sistemas - UIS
- **Asignatura:** Bases de Datos II
- **Semestre:** 2026-1

---

## Descripcion

Taller practico de modelado de datos distribuidos en **Apache Cassandra** a traves de **Astra DB Cloud** de DataStax.

Caso de estudio: sistema academico universitario que requiere alta disponibilidad, tolerancia a fallos y soporte para millones de registros, aplicando principios de desnormalizacion, modelado orientado a consultas y particionamiento.

## Contenido de la carpeta

| Archivo | Descripcion |
|---|---|
| [`Taller_Cassandra_Robert_Caicedo.docx`](Taller_Cassandra_Robert_Caicedo.docx) | Documento Word con la entrega completa (portada UIS, problema, metodologia, evidencias, conclusiones) |
| [`CassandraTaller_Solucion.md`](CassandraTaller_Solucion.md) | Documentacion tecnica detallada con todos los CREATE TABLE, INSERTs y las 15 consultas explicadas |
| [`CassandraTaller_Consultas.cql`](CassandraTaller_Consultas.cql) | Script CQL con solo las 15 consultas, listo para ejecutar en Astra DB |
| [`CassandraTaller.pdf`](CassandraTaller.pdf) | PDF original del taller (enunciado del profesor) |
| [`screenshots/`](screenshots/) | Capturas de pantalla de la CQL Console de Astra DB con la ejecucion de las consultas |

## Resumen tecnico

- **Tecnologias:** Apache Cassandra, Astra DB Cloud, CQL 3.4.5, cqlsh 6.8.0
- **5 tablas** creadas siguiendo el modelado orientado a consultas
- **23 registros** insertados (5 estudiantes, 6 cursos, 4 historial, 4 inscritos, 4 rendimiento)
- **15 consultas** ejecutadas exitosamente

### Tablas creadas

1. `estudiantes_por_carrera` - particion por `carrera`
2. `cursos_por_semestre` - particion por `semestre`
3. `historial_academico` - clave compuesta `(id_estudiante, periodo)` + clustering por `fecha DESC`
4. `inscritos_por_curso` - particion por `id_curso`
5. `rendimiento_estudiante` - particion por `id_estudiante`

### Errores corregidos del PDF original

| Error en el PDF | Correccion aplicada |
|---|---|
| `codigo_curso TEXT` en INSERTs | Cambiado a `id_curso UUID` |
| `nombre_curso` en INSERTs | Cambiado a `nombre` o `curso` segun la tabla |
| `nombre_estudiante` en INSERTs | Cambiado a `nombre` |
| `materias_reprobadas` en INSERTs | Cambiado a `materias_perdidas` |
| `semestre, estado` en `inscritos_por_curso` | Cambiado a `carrera, promedio` |
| Consulta 11 con `columna > columna` | CQL no lo permite; se filtra del lado del cliente |

## Notas tecnicas relevantes

- **ALLOW FILTERING** es necesario cuando se filtra por columnas que no son partition key.
- **CQL no permite comparar dos columnas** entre si en el WHERE - solo columna vs valor literal.
- **ORDER BY** solo funciona sobre clustering keys definidas en `CLUSTERING ORDER BY`.
- En Cassandra **se diseñan las tablas a partir de las consultas**, no de las entidades.
