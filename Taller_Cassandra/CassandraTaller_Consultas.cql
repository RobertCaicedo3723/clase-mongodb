-- 1. Estudiantes de Ing. Sistemas con promedio > 4.0
SELECT * FROM estudiantes_por_carrera
WHERE carrera = 'Ingenieria de Sistemas' AND promedio > 4.0 ALLOW FILTERING;

-- 2. Estudiantes de octavo semestre
SELECT * FROM estudiantes_por_carrera
WHERE carrera = 'Ingenieria de Sistemas' AND semestre = 8 ALLOW FILTERING;

-- 3. Cursos del semestre 8
SELECT * FROM cursos_por_semestre WHERE semestre = 8;

-- 4. Cursos con mas de 3 creditos
SELECT * FROM cursos_por_semestre WHERE creditos > 3 ALLOW FILTERING;

-- 5. Estudiantes inscritos en Bases de Datos II
SELECT * FROM inscritos_por_curso WHERE carrera = 'Ingenieria de Sistemas' ALLOW FILTERING;

-- 6. Estudiantes activos en un curso
SELECT * FROM inscritos_por_curso WHERE promedio > 0 ALLOW FILTERING;

-- 7. Estudiantes que reprobaron materias
SELECT * FROM historial_academico WHERE estado = 'REPROBADO' ALLOW FILTERING;

-- 8. Materias aprobadas con nota > 4.5
SELECT * FROM historial_academico WHERE estado = 'APROBADO' AND nota > 4.5 ALLOW FILTERING;

-- 9. Historial academico de un periodo especifico
SELECT * FROM historial_academico WHERE periodo = '2025-1' ALLOW FILTERING;

-- 10. Estudiantes con promedio inferior a 3.0
SELECT * FROM estudiantes_por_carrera WHERE promedio < 3.0 ALLOW FILTERING;

-- 11. Estudiantes con mas materias perdidas que aprobadas
SELECT * FROM rendimiento_estudiante WHERE materias_perdidas >= 3 ALLOW FILTERING;

-- 12. Mejores promedios academicos
SELECT * FROM rendimiento_estudiante WHERE promedio >= 4.5 ALLOW FILTERING;

-- 13. Cursos dictados por un profesor especifico
SELECT * FROM cursos_por_semestre WHERE profesor = 'Carlos Gomez' ALLOW FILTERING;

-- 14. Estudiantes en cursos avanzados (semestres 8, 9, 10)
SELECT * FROM estudiantes_por_carrera WHERE semestre IN (8, 9, 10) ALLOW FILTERING;

-- 15. Estudiantes con rendimiento sobresaliente
SELECT * FROM rendimiento_estudiante WHERE promedio >= 4.5 AND materias_perdidas = 0 ALLOW FILTERING;
