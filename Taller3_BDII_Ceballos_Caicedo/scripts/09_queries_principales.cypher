// ============================================================
//  Taller 3 - BD II UIS 2026
//  Archivo: 09_queries_principales.cypher
//  Descripcion: Las 9 consultas principales del analisis
//               (Diapositiva 7). Archivo autocontenido.
// ============================================================

// ------------------------------------------------------------
// Q1) Listado de POSTs de un empleado determinado
// ------------------------------------------------------------
MATCH (e:Empleado {codigoEmpresarial: $codigoEmpresarial})-[:PUBLICO]->(p:Post)
RETURN p.id AS idPost,
       p.fecha AS fecha,
       p.titulo AS titulo,
       p.descripcion AS descripcion
ORDER BY p.fecha DESC;

// ------------------------------------------------------------
// Q2) Los 3 POSTs mas recientes publicados
// ------------------------------------------------------------
MATCH (e:Empleado)-[:PUBLICO]->(p:Post)
RETURN p.id AS idPost,
       p.fecha AS fecha,
       p.titulo AS titulo,
       e.nombre + ' ' + e.apellidos AS autor
ORDER BY p.fecha DESC
LIMIT 3;

// ------------------------------------------------------------
// Q3) Los 3 POSTs con mas me gusta
// ------------------------------------------------------------
MATCH (e:Empleado)-[:PUBLICO]->(p:Post)
OPTIONAL MATCH (:Empleado)-[like:DIO_LIKE]->(p)
WITH p, e, count(like) AS cantidadLikes
ORDER BY cantidadLikes DESC
LIMIT 3
RETURN p.id AS idPost,
       p.titulo AS titulo,
       e.nombre + ' ' + e.apellidos AS autor,
       cantidadLikes
ORDER BY cantidadLikes DESC;

// ------------------------------------------------------------
// Q4) Empleados que tienen como jefe a un empleado determinado
//     (subordinados directos unicamente)
// ------------------------------------------------------------
MATCH (jefe:Empleado {codigoEmpresarial: $codigoEmpresarial})-[:JEFE_DE]->(sub:Empleado)
RETURN sub.codigoEmpresarial AS codigo,
       sub.nombre + ' ' + sub.apellidos AS nombreCompleto,
       sub.cargo AS cargo
ORDER BY nombreCompleto;

// ------------------------------------------------------------
// Q5) Listado de POSTs a los que un empleado le ha dado me gusta
// ------------------------------------------------------------
MATCH (e:Empleado {codigoEmpresarial: $codigoEmpresarial})-[:DIO_LIKE]->(p:Post)
MATCH (autor:Empleado)-[:PUBLICO]->(p)
RETURN p.id AS idPost,
       p.titulo AS titulo,
       p.fecha AS fecha,
       autor.nombre + ' ' + autor.apellidos AS autorPost
ORDER BY p.fecha DESC;

// ------------------------------------------------------------
// Q6) Empleados con reportes de acoso laboral que ocupen un cargo especifico
// ------------------------------------------------------------
MATCH (reportado:Empleado {cargo: $cargo})<-[:CONTRA]-(r:Reporte)<-[:GENERA]-(reportante:Empleado)
RETURN reportado.codigoEmpresarial AS codigoReportado,
       reportado.nombre + ' ' + reportado.apellidos AS nombreReportado,
       reportado.cargo AS cargo,
       r.id AS idReporte,
       r.naturaleza AS naturaleza,
       r.fecha AS fechaReporte,
       reportante.nombre + ' ' + reportante.apellidos AS nombreReportante
ORDER BY r.fecha DESC;

// ------------------------------------------------------------
// Q7) Lista de amigos de un empleado mostrando sus relaciones
//     de amistad en el grafo
//     (Para ver el grafo en Neo4j Browser seleccionar vista Graph)
// ------------------------------------------------------------
MATCH (e:Empleado {codigoEmpresarial: $codigoEmpresarial})-[rel:AMIGO_DE]-(amigo:Empleado)
RETURN e, rel, amigo;

// ------------------------------------------------------------
// Q8) Los 3 empleados con mas amigos
// ------------------------------------------------------------
MATCH (e:Empleado)-[:AMIGO_DE]-(amigo:Empleado)
WITH e, count(amigo) AS cantidadAmigos
ORDER BY cantidadAmigos DESC
LIMIT 3
RETURN e.codigoEmpresarial AS codigo,
       e.nombre + ' ' + e.apellidos AS nombreCompleto,
       e.cargo AS cargo,
       cantidadAmigos
ORDER BY cantidadAmigos DESC;

// ------------------------------------------------------------
// Q9) POSTs con mas comentarios
// ------------------------------------------------------------
MATCH (c:Comentario)-[:EN_POST]->(p:Post)
MATCH (autor:Empleado)-[:PUBLICO]->(p)
WITH p, autor, count(c) AS cantidadComentarios
ORDER BY cantidadComentarios DESC
RETURN p.id AS idPost,
       p.titulo AS titulo,
       autor.nombre + ' ' + autor.apellidos AS autor,
       cantidadComentarios
ORDER BY cantidadComentarios DESC;

// ============================================================
//  Parametros sugeridos:
//  :param codigoEmpresarial => 'EMP-001'
//  :param cargo             => 'Gerente'
// ============================================================
