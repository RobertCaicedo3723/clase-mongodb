// ============================================================
//  Taller 3 - BD II UIS 2026
//  Archivo: 04_queries_update.cypher
//  Descripcion: Operaciones de actualizacion (Diapositiva 12).
// ============================================================

// ------------------------------------------------------------
// a) Actualizar informacion de un empleado
//    Se actualiza la edad y el cargo de EMP-016
//    (Ferney Andres Chavez Beltran pasa de Empleado a Administrador
//     tras una promocion interna)
// ------------------------------------------------------------
MATCH (e:Empleado {codigoEmpresarial: 'EMP-016'})
SET e.edad  = 27,
    e.cargo = 'Administrador'
RETURN e.codigoEmpresarial AS codigo,
       e.nombre + ' ' + e.apellidos AS nombreCompleto,
       e.cargo AS nuevoCargo,
       e.edad  AS nuevaEdad;

// ------------------------------------------------------------
// b) Actualizar el contenido de un POST
//    Se corrige el titulo y la descripcion de POST-004
// ------------------------------------------------------------
MATCH (p:Post {id: 'POST-004'})
SET p.titulo      = 'Reunion de seguimiento - jueves 3 p.m.',
    p.descripcion = 'Este jueves a las 3 p.m. tenemos la reunion de seguimiento del plan operativo. La sala de juntas quedo reservada. Favor confirmar asistencia antes del mediodia.'
RETURN p.id AS idPost, p.titulo AS nuevoTitulo;

// ------------------------------------------------------------
// c) Actualizar un comentario
//    Se amplia la descripcion de COM-001
// ------------------------------------------------------------
MATCH (c:Comentario {id: 'COM-001'})
SET c.descripcion = 'Excelentes resultados Carlos Andres. El equipo ha trabajado con mucho compromiso este trimestre. Estos numeros son un reflejo del liderazgo y la dedicacion de todos.'
RETURN c.id AS idComentario, c.descripcion AS nuevaDescripcion;
