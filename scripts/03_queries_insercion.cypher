// ============================================================
//  Taller 3 - BD II UIS 2026
//  Archivo: 03_queries_insercion.cypher
//  Descripcion: Operaciones de insercion (Diapositiva 11).
//               El nuevo empleado es EMP-019, cargo Empleado,
//               jefe directo EMP-008 (Miguel Angel Acevedo Torres).
// ============================================================

// ------------------------------------------------------------
// a) Insertar un nuevo usuario
//    Crea el nodo Empleado y lo vincula a su jefe inmediato
// ------------------------------------------------------------
MATCH (jefe:Empleado {codigoEmpresarial: 'EMP-008'})
CREATE (e:Empleado {
  codigoEmpresarial: 'EMP-019',
  documento:         '1068901234',
  nombre:            'Roberto',
  apellidos:         'Caicedo Sanchez',
  edad:              28,
  cargo:             'Empleado'
})
MERGE (jefe)-[:JEFE_DE]->(e)
RETURN e.codigoEmpresarial AS codigo,
       e.nombre + ' ' + e.apellidos AS nombreCompleto,
       e.cargo AS cargo,
       jefe.codigoEmpresarial AS codigoJefe;

// ------------------------------------------------------------
// b) Insertar una nueva relacion de amistad para el usuario creado
//    EMP-019 se hace amigo de EMP-014 (Edwin Fabian Zapata Giraldo)
// ------------------------------------------------------------
MATCH (nuevo:Empleado {codigoEmpresarial: 'EMP-019'})
MATCH (amigo:Empleado {codigoEmpresarial: 'EMP-014'})
MERGE (nuevo)-[:AMIGO_DE]->(amigo)
RETURN nuevo.nombre + ' ' + nuevo.apellidos AS empleado,
       amigo.nombre + ' ' + amigo.apellidos AS nuevoAmigo;

// ------------------------------------------------------------
// c) Insertar un nuevo post para el empleado creado (EMP-019)
// ------------------------------------------------------------
MATCH (e:Empleado {codigoEmpresarial: 'EMP-019'})
CREATE (p:Post {
  id:          'POST-019',
  fecha:       datetime('2026-05-13T10:00:00'),
  titulo:      'Mi primer dia en la red corporativa',
  descripcion: 'Hola a todos. Me uno a la red social de la empresa con mucho entusiasmo. Agradezco la bienvenida y espero contribuir al exito del equipo.'
})
MERGE (e)-[:PUBLICO]->(p)
RETURN p.id AS idPost, p.titulo AS titulo, e.nombre AS autor;

// ------------------------------------------------------------
// d) Insertar comentarios de otros empleados en el post anterior
//    EMP-005 (Andres Felipe Mena Palacios) y
//    EMP-011 (Natalia Andrea Cuellar Fonseca) comentan POST-019
// ------------------------------------------------------------
MATCH (post:Post      {id:               'POST-019'})
MATCH (e1:Empleado    {codigoEmpresarial: 'EMP-005'})
MATCH (e2:Empleado    {codigoEmpresarial: 'EMP-011'})
CREATE (c1:Comentario {
  id:          'COM-037',
  fecha:       datetime('2026-05-13T10:30:00'),
  descripcion: 'Bienvenido Roberto. Un gusto tenerte en el equipo. Aqui encontraras un excelente ambiente de trabajo.'
})
CREATE (c2:Comentario {
  id:          'COM-038',
  fecha:       datetime('2026-05-13T11:00:00'),
  descripcion: 'Bienvenido. Cualquier duda nos cuentas sin problema. Pronto te vas a adaptar muy bien.'
})
MERGE (e1)-[:COMENTO]->(c1)
MERGE (c1)-[:EN_POST]->(post)
MERGE (e2)-[:COMENTO]->(c2)
MERGE (c2)-[:EN_POST]->(post)
RETURN c1.id AS comentario1, e1.nombre AS autor1,
       c2.id AS comentario2, e2.nombre AS autor2;
