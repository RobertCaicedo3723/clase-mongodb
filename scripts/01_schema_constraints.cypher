// ============================================================
//  Taller 3 - BD II UIS 2026
//  Archivo: 01_schema_constraints.cypher
//  Descripcion: Definicion de constraints e indices del esquema
//               de grafo. Ejecutar antes de cargar cualquier dato.
// ============================================================

// ============================================================
//  CONSTRAINTS DE UNICIDAD
// ============================================================

// Empleado: codigo empresarial unico
CREATE CONSTRAINT emp_codigo_unique IF NOT EXISTS
FOR (e:Empleado)
REQUIRE e.codigoEmpresarial IS UNIQUE;

// Empleado: numero de documento unico
CREATE CONSTRAINT emp_documento_unique IF NOT EXISTS
FOR (e:Empleado)
REQUIRE e.documento IS UNIQUE;

// Post: identificador unico
CREATE CONSTRAINT post_id_unique IF NOT EXISTS
FOR (p:Post)
REQUIRE p.id IS UNIQUE;

// Comentario: identificador unico
CREATE CONSTRAINT comentario_id_unique IF NOT EXISTS
FOR (c:Comentario)
REQUIRE c.id IS UNIQUE;

// Reporte: identificador unico
CREATE CONSTRAINT reporte_id_unique IF NOT EXISTS
FOR (r:Reporte)
REQUIRE r.id IS UNIQUE;

// ============================================================
//  CONSTRAINTS NOT NULL
// ============================================================

// Empleado: cargo obligatorio
CREATE CONSTRAINT emp_cargo_not_null IF NOT EXISTS
FOR (e:Empleado)
REQUIRE e.cargo IS NOT NULL;

// Empleado: nombre obligatorio
CREATE CONSTRAINT emp_nombre_not_null IF NOT EXISTS
FOR (e:Empleado)
REQUIRE e.nombre IS NOT NULL;

// Empleado: apellidos obligatorio
CREATE CONSTRAINT emp_apellidos_not_null IF NOT EXISTS
FOR (e:Empleado)
REQUIRE e.apellidos IS NOT NULL;

// Post: fecha obligatoria
CREATE CONSTRAINT post_fecha_not_null IF NOT EXISTS
FOR (p:Post)
REQUIRE p.fecha IS NOT NULL;

// Reporte: naturaleza obligatoria
CREATE CONSTRAINT reporte_naturaleza_not_null IF NOT EXISTS
FOR (r:Reporte)
REQUIRE r.naturaleza IS NOT NULL;

// ============================================================
//  INDICES
// ============================================================

// Indice sobre cargo de Empleado (consultas frecuentes por cargo)
CREATE INDEX idx_empleado_cargo IF NOT EXISTS
FOR (e:Empleado)
ON (e.cargo);

// Indice sobre fecha de Post (consultas de posts mas recientes)
CREATE INDEX idx_post_fecha IF NOT EXISTS
FOR (p:Post)
ON (p.fecha);

// Indice sobre fecha de Reporte
CREATE INDEX idx_reporte_fecha IF NOT EXISTS
FOR (r:Reporte)
ON (r.fecha);
