// ============================================================
//  Taller 3 - BD II UIS 2026
//  Archivo: 05_queries_delete.cypher
//  Descripcion: Operaciones de eliminacion (Diapositiva 13).
//
//  ADVERTENCIA: Estas operaciones son irreversibles. Se recomienda
//  ejecutar 00_reset_db.cypher y 02_carga_csv.cypher para restaurar
//  el estado original si se necesita volver a consultar los datos.
//
//  ORDEN DE BORRADO RESPONSABLE:
//    1. Comentarios asociados (nodos huerfanos sin significado propio)
//    2. Posts asociados (y sus relaciones de DIO_LIKE)
//    3. Reportes generados por el empleado
//    4. El nodo Empleado (DETACH DELETE elimina relaciones residuales)
// ============================================================

// ------------------------------------------------------------
// a) Eliminar un empleado
//    Se elimina EMP-017 (Yolanda Maria Villanueva Arias).
//    El borrado en cascada sigue el orden responsable descrito arriba.
// ------------------------------------------------------------

// Paso a.1: eliminar los comentarios publicados por EMP-017
// (sin COMENTO el nodo Comentario queda sin autor, pierde sentido)
MATCH (e:Empleado {codigoEmpresarial: 'EMP-017'})-[:COMENTO]->(c:Comentario)
DETACH DELETE c;

// Paso a.2: eliminar los posts de EMP-017 junto con sus comentarios asociados
// (los Comentario EN_POST a ese post tambien se eliminan para no quedar huerfanos)
MATCH (e:Empleado {codigoEmpresarial: 'EMP-017'})-[:PUBLICO]->(p:Post)
OPTIONAL MATCH (c:Comentario)-[:EN_POST]->(p)
DETACH DELETE c, p;

// Paso a.3: eliminar los reportes generados por EMP-017
// (sin GENERA el Reporte pierde su autor; si el reporte es contra alguien
//  tambien desaparece la relacion CONTRA, pero no el empleado reportado)
MATCH (e:Empleado {codigoEmpresarial: 'EMP-017'})-[:GENERA]->(r:Reporte)
DETACH DELETE r;

// Paso a.4: eliminar el nodo Empleado y sus relaciones restantes
// (JEFE_DE, AMIGO_DE, DIO_LIKE y cualquier CONTRA que apunte a el)
MATCH (e:Empleado {codigoEmpresarial: 'EMP-017'})
DETACH DELETE e;

// Verificacion: el empleado ya no debe aparecer
// MATCH (e:Empleado {codigoEmpresarial: 'EMP-017'}) RETURN e;

// ------------------------------------------------------------
// b) Eliminar un reporte de acoso laboral
//    Se elimina REP-005 (inequidad, contra EMP-014).
//    DETACH DELETE elimina el nodo Reporte y sus relaciones
//    GENERA y CONTRA; los empleados vinculados no se ven afectados.
// ------------------------------------------------------------
MATCH (r:Reporte {id: 'REP-005'})
DETACH DELETE r;

// Verificacion: el reporte ya no debe aparecer
// MATCH (r:Reporte {id: 'REP-005'}) RETURN r;

// ------------------------------------------------------------
// c) Eliminar un POST
//    Se elimina POST-018 (Javier Enrique Polo Diaz).
//    Primero se eliminan los Comentario asociados EN_POST para no
//    dejarlos como nodos huerfanos sin post de referencia.
//    Luego se elimina el Post con DETACH DELETE (remueve DIO_LIKE y PUBLICO).
// ------------------------------------------------------------

// Paso c.1: eliminar los comentarios del post
MATCH (c:Comentario)-[:EN_POST]->(p:Post {id: 'POST-018'})
DETACH DELETE c;

// Paso c.2: eliminar el post y sus relaciones restantes (DIO_LIKE, PUBLICO)
MATCH (p:Post {id: 'POST-018'})
DETACH DELETE p;

// Verificacion: el post ya no debe aparecer
// MATCH (p:Post {id: 'POST-018'}) RETURN p;
