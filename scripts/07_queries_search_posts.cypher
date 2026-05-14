// ============================================================
//  Taller 3 - BD II UIS 2026
//  Archivo: 07_queries_search_posts.cypher
//  Descripcion: Consultas de busqueda - Posts y comentarios
//               (Diapositiva 15).
// ============================================================

// ------------------------------------------------------------
// a) POSTs de un empleado determinado
// ------------------------------------------------------------
MATCH (e:Empleado {codigoEmpresarial: $codigoEmpresarial})-[:PUBLICO]->(p:Post)
RETURN p.id AS idPost,
       p.fecha AS fecha,
       p.titulo AS titulo,
       p.descripcion AS descripcion
ORDER BY p.fecha DESC;

// ------------------------------------------------------------
// b) Comentarios de un POST determinado
//    Incluye el autor de cada comentario.
// ------------------------------------------------------------
MATCH (c:Comentario)-[:EN_POST]->(p:Post {id: $idPost})
MATCH (autor:Empleado)-[:COMENTO]->(c)
RETURN c.id AS idComentario,
       c.fecha AS fecha,
       autor.nombre + ' ' + autor.apellidos AS autor,
       c.descripcion AS comentario
ORDER BY c.fecha ASC;

// ------------------------------------------------------------
// c) Empleados que dieron me gusta a un POST determinado
// ------------------------------------------------------------
MATCH (e:Empleado)-[:DIO_LIKE]->(p:Post {id: $idPost})
RETURN e.codigoEmpresarial AS codigo,
       e.nombre + ' ' + e.apellidos AS nombreCompleto,
       e.cargo AS cargo
ORDER BY nombreCompleto;

// ------------------------------------------------------------
// d) Los 3 POSTs con mas me gusta
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

// ============================================================
//  Parametros sugeridos:
//  :param codigoEmpresarial => 'EMP-001'
//  :param idPost            => 'POST-001'
// ============================================================
