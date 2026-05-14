// ============================================================
//  Taller 3 - BD II UIS 2026
//  Archivo: 08_queries_search_acoso.cypher
//  Descripcion: Consultas de busqueda - Reportes de acoso laboral
//               (Diapositiva 16).
// ============================================================

// ------------------------------------------------------------
// a) Dado un cargo, empleados con reportes de acoso laboral
//    Retorna el empleado reportado, su cargo, el reporte y quien lo genero.
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
// b) Numero de reportes de acoso realizados por un empleado
//    (reportes que el empleado ha interpuesto, no los que recibio)
// ------------------------------------------------------------
MATCH (e:Empleado {codigoEmpresarial: $codigoEmpresarial})-[:GENERA]->(r:Reporte)
RETURN e.codigoEmpresarial AS codigo,
       e.nombre + ' ' + e.apellidos AS nombreEmpleado,
       count(r) AS cantidadReportesGenerados,
       collect(r.naturaleza) AS naturalezas;

// ============================================================
//  Parametros sugeridos:
//  :param cargo             => 'Gerente'
//  :param codigoEmpresarial => 'EMP-011'
// ============================================================
