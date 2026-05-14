// ============================================================
//  Taller 3 - BD II UIS 2026
//  Archivo: 02_carga_csv.cypher
//  Descripcion: Carga masiva de nodos y relaciones desde los
//               CSVs ubicados en la carpeta import de Neo4j.
//               Usar MERGE evita duplicados en re-ejecuciones.
// ============================================================

// ============================================================
//  PASO 1: Nodos
// ============================================================

// --- Empleados ---
LOAD CSV WITH HEADERS FROM 'file:///empleados.csv' AS row
MERGE (e:Empleado {codigoEmpresarial: row.codigoEmpresarial})
SET e.documento = row.documento,
    e.nombre    = row.nombre,
    e.apellidos = row.apellidos,
    e.edad      = toInteger(row.edad),
    e.cargo     = row.cargo;

// --- Posts ---
LOAD CSV WITH HEADERS FROM 'file:///posts.csv' AS row
MERGE (p:Post {id: row.id})
SET p.fecha       = datetime(row.fecha),
    p.titulo      = row.titulo,
    p.descripcion = row.descripcion;

// --- Comentarios ---
LOAD CSV WITH HEADERS FROM 'file:///comentarios.csv' AS row
MERGE (c:Comentario {id: row.id})
SET c.fecha       = datetime(row.fecha),
    c.descripcion = row.descripcion;

// --- Reportes ---
LOAD CSV WITH HEADERS FROM 'file:///reportes.csv' AS row
MERGE (r:Reporte {id: row.id})
SET r.fecha      = datetime(row.fecha),
    r.naturaleza = row.naturaleza;

// ============================================================
//  PASO 2: Relaciones
//  Orden: primero relaciones entre Empleados, luego las que
//         involucran Posts, Comentarios y Reportes.
// ============================================================

// --- JEFE_DE: cadena de mando ---
LOAD CSV WITH HEADERS FROM 'file:///rel_jefe_de.csv' AS row
MATCH (jefe:Empleado {codigoEmpresarial: row.codigoJefe})
MATCH (sub:Empleado  {codigoEmpresarial: row.codigoSubordinado})
MERGE (jefe)-[:JEFE_DE]->(sub);

// --- AMIGO_DE: amistad (una sola arista, patron simetrico sin direccion en consultas) ---
LOAD CSV WITH HEADERS FROM 'file:///rel_amigo_de.csv' AS row
MATCH (origen:Empleado  {codigoEmpresarial: row.codigoOrigen})
MATCH (destino:Empleado {codigoEmpresarial: row.codigoDestino})
MERGE (origen)-[:AMIGO_DE]->(destino);

// --- PUBLICO: autoria del post ---
LOAD CSV WITH HEADERS FROM 'file:///rel_publico.csv' AS row
MATCH (e:Empleado {codigoEmpresarial: row.codigoEmpleado})
MATCH (p:Post     {id:               row.idPost})
MERGE (e)-[:PUBLICO]->(p);

// --- COMENTO + EN_POST: una sola pasada crea las dos relaciones del comentario ---
LOAD CSV WITH HEADERS FROM 'file:///rel_comento_post.csv' AS row
MATCH (e:Empleado   {codigoEmpresarial: row.codigoEmpleado})
MATCH (c:Comentario {id:               row.idComentario})
MATCH (p:Post       {id:               row.idPost})
MERGE (e)-[:COMENTO]->(c)
MERGE (c)-[:EN_POST]->(p);

// --- DIO_LIKE: me gusta ---
LOAD CSV WITH HEADERS FROM 'file:///rel_dio_like.csv' AS row
MATCH (e:Empleado {codigoEmpresarial: row.codigoEmpleado})
MATCH (p:Post     {id:               row.idPost})
MERGE (e)-[:DIO_LIKE]->(p);

// --- GENERA: empleado que crea el reporte ---
LOAD CSV WITH HEADERS FROM 'file:///rel_genera_reporte.csv' AS row
MATCH (e:Empleado {codigoEmpresarial: row.codigoEmpleado})
MATCH (r:Reporte  {id:               row.idReporte})
MERGE (e)-[:GENERA]->(r);

// --- CONTRA: reporte dirigido contra un empleado ---
LOAD CSV WITH HEADERS FROM 'file:///rel_contra_reporte.csv' AS row
MATCH (r:Reporte  {id:               row.idReporte})
MATCH (e:Empleado {codigoEmpresarial: row.codigoEmpleado})
MERGE (r)-[:CONTRA]->(e);

// ============================================================
//  VALIDACION (ejecutar de forma independiente al finalizar)
// ============================================================
// MATCH (n) RETURN labels(n)[0] AS tipo, count(n) AS cantidad ORDER BY tipo;
// MATCH ()-[r]->() RETURN type(r) AS relacion, count(r) AS cantidad ORDER BY relacion;
