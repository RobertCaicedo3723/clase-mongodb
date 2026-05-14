// ============================================================
//  Taller 3 - BD II UIS 2026
//  Archivo: 00_reset_db.cypher
//  Descripcion: Limpieza total de la base de datos.
//               Ejecutar SOLO si se desea reiniciar desde cero.
//               Los DROP de constraints e indices estan comentados;
//               descomentarlos si se requiere eliminar el esquema.
// ============================================================

// --- 1. Eliminar todos los nodos y relaciones ---
MATCH (n) DETACH DELETE n;

// --- 2. Eliminar constraints (descomentarlos segun sea necesario) ---

// DROP CONSTRAINT emp_codigo_unique IF EXISTS;
// DROP CONSTRAINT emp_documento_unique IF EXISTS;
// DROP CONSTRAINT post_id_unique IF EXISTS;
// DROP CONSTRAINT comentario_id_unique IF EXISTS;
// DROP CONSTRAINT reporte_id_unique IF EXISTS;

// DROP CONSTRAINT emp_cargo_not_null IF EXISTS;
// DROP CONSTRAINT emp_nombre_not_null IF EXISTS;
// DROP CONSTRAINT emp_apellidos_not_null IF EXISTS;
// DROP CONSTRAINT post_fecha_not_null IF EXISTS;
// DROP CONSTRAINT reporte_naturaleza_not_null IF EXISTS;

// --- 3. Eliminar indices (descomentarlos segun sea necesario) ---

// DROP INDEX idx_empleado_cargo IF EXISTS;
// DROP INDEX idx_post_fecha IF EXISTS;
// DROP INDEX idx_reporte_fecha IF EXISTS;
