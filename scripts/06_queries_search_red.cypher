// ============================================================
//  Taller 3 - BD II UIS 2026
//  Archivo: 06_queries_search_red.cypher
//  Descripcion: Consultas de busqueda - Red social y jerarquia
//               (Diapositiva 14).
// ============================================================

// ------------------------------------------------------------
// a) Empleados que desempenan un rol (cargo) determinado
// ------------------------------------------------------------
MATCH (e:Empleado {cargo: $cargo})
RETURN e.codigoEmpresarial AS codigo,
       e.nombre + ' ' + e.apellidos AS nombreCompleto,
       e.edad AS edad,
       e.cargo AS cargo
ORDER BY nombreCompleto;

// ------------------------------------------------------------
// b) Empleados a cargo de un empleado dado (todos los niveles)
//    Recorre la cadena JEFE_DE de longitud variable hacia abajo.
// ------------------------------------------------------------
MATCH (jefe:Empleado {codigoEmpresarial: $codigoEmpresarial})-[:JEFE_DE*1..]->(sub:Empleado)
RETURN DISTINCT sub.codigoEmpresarial AS codigo,
       sub.nombre + ' ' + sub.apellidos AS nombreCompleto,
       sub.cargo AS cargo
ORDER BY sub.cargo, nombreCompleto;

// ------------------------------------------------------------
// c) Amigos de un empleado
//    El patron sin direccion (-[:AMIGO_DE]-) recorre la arista
//    en ambos sentidos, cubriendo el modelo de arista unica.
// ------------------------------------------------------------
MATCH (e:Empleado {codigoEmpresarial: $codigoEmpresarial})-[:AMIGO_DE]-(amigo:Empleado)
RETURN amigo.codigoEmpresarial AS codigo,
       amigo.nombre + ' ' + amigo.apellidos AS nombreCompleto,
       amigo.cargo AS cargo
ORDER BY nombreCompleto;

// ------------------------------------------------------------
// d) Amigos de los amigos de un empleado
//    Excluye al empleado consultado y a sus amigos directos.
// ------------------------------------------------------------
MATCH (e:Empleado {codigoEmpresarial: $codigoEmpresarial})-[:AMIGO_DE]-(amigo:Empleado)
WITH e, collect(amigo) AS amigosDirectos
UNWIND amigosDirectos AS amigo
MATCH (amigo)-[:AMIGO_DE]-(amigodeamigo:Empleado)
WHERE amigodeamigo <> e
  AND NOT amigodeamigo IN amigosDirectos
RETURN DISTINCT amigodeamigo.codigoEmpresarial AS codigo,
       amigodeamigo.nombre + ' ' + amigodeamigo.apellidos AS nombreCompleto,
       amigodeamigo.cargo AS cargo
ORDER BY nombreCompleto;

// ------------------------------------------------------------
// e) Empleado con mas amigos
// ------------------------------------------------------------
MATCH (e:Empleado)-[:AMIGO_DE]-(amigo:Empleado)
WITH e, count(amigo) AS cantidadAmigos
ORDER BY cantidadAmigos DESC
LIMIT 1
RETURN e.codigoEmpresarial AS codigo,
       e.nombre + ' ' + e.apellidos AS nombreCompleto,
       e.cargo AS cargo,
       cantidadAmigos;

// ============================================================
//  Parametros sugeridos:
//  :param cargo             => 'Administrador'
//  :param codigoEmpresarial => 'EMP-001'
// ============================================================
