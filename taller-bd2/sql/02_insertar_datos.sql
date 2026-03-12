-- =====================================================
-- TALLER BD2 - EMPRESA HUELLITAS
-- 02: Operaciones de insercion, actualizacion y eliminacion
-- Autores: Robert Caicedo Sanchez, Kaleth Ceballos
-- =====================================================

USE TallerZapateria;
SET NOCOUNT ON;
GO

-- A) 3 maestros, 2 ayudantes, 2 cortadores
BEGIN TRY
  BEGIN TRAN;
  INSERT INTO Empleado (nombre, apellido, fecha_ingreso)
  VALUES ('Carlos',  'Gomez',    '2021-03-01'),
         ('Lucia',   'Perez',    '2020-07-15'),
         ('Juan',    'Martinez', '2019-11-10'),
         ('Andres',  'Lopez',    '2023-01-05'),
         ('Mariana', 'Suarez',   '2022-06-20'),
         ('Pedro',   'Ramirez',  '2021-08-10'),
         ('Sofia',   'Ramirez',  '2022-02-25');

  INSERT INTO Historial_Rol_Empleado (empleado_id, rol, activo, motivo)
  VALUES (1,'maestro',  1,'Insercion inicial'),
         (2,'maestro',  1,'Insercion inicial'),
         (3,'maestro',  1,'Insercion inicial'),
         (4,'ayudante', 1,'Insercion inicial'),
         (5,'ayudante', 1,'Insercion inicial'),
         (6,'cortador', 1,'Insercion inicial'),
         (7,'cortador', 1,'Insercion inicial');
  COMMIT;
END TRY
BEGIN CATCH ROLLBACK; PRINT 'Error A: ' + ERROR_MESSAGE(); END CATCH;
GO

-- B) Nuevo diseno de zapato
BEGIN TRY
  BEGIN TRAN;
  INSERT INTO Material (nombre, descripcion, unidad_medida)
  VALUES ('Cuero natural',  'Cuero vacuno curtido', 'm2'),
         ('Tela sintetica', 'Tela poliester 600D',  'm2');

  INSERT INTO Diseno (nombre_diseno, descripcion, creado_por)
  VALUES ('Modelo Actividad', 'Zapato clasico para taller', 1);

  INSERT INTO Diseno_Version (diseno_id, version_num, creado_por, notas)
  VALUES (1, 1, 1, 'Version inicial - 2 trozos');

  INSERT INTO Diseno_Material (diseno_version_id, material_id, cantidad_por_unidad, posicion)
  VALUES (1, 1, 0.30, 'empeine'),
         (1, 2, 0.10, 'lengueta');
  COMMIT;
END TRY
BEGIN CATCH ROLLBACK; PRINT 'Error B: ' + ERROR_MESSAGE(); END CATCH;
GO

-- C) Lote de 10 zapatos
BEGIN TRY
  BEGIN TRAN;
  INSERT INTO Molde (tipo_molde, material_molde, estado)
  VALUES ('plantilla', 'acero', 'operativo');

  INSERT INTO Lote_Produccion
    (diseno_version_id, codigo_lote_prod, fecha_inicio, cantidad_objetivo, estado_lote, responsable_maestro_id)
  VALUES (1, 'LP-2026-001', SYSUTCDATETIME(), 10, 'en_produccion', 1);

  DECLARE @i INT = 1;
  WHILE @i <= 10
  BEGIN
    INSERT INTO Zapato (serial, lote_prod_id, diseno_version_id, talla, fecha_ensamblado, maestro_id, estado_zapato, molde_usado_id)
    VALUES (CONCAT('ZAP-LP001-', @i), 1, 1, 42, SYSUTCDATETIME(), 1, 'ensamblado', 1);
    SET @i = @i + 1;
  END

  UPDATE Lote_Produccion SET cantidad_producida = 10 WHERE lote_prod_id = 1;
  COMMIT;
END TRY
BEGIN CATCH ROLLBACK; PRINT 'Error C: ' + ERROR_MESSAGE(); END CATCH;
GO

-- D) Cambio de rol: ayudante -> maestro (Andres Lopez, id=4)
BEGIN TRY
  BEGIN TRAN;
  UPDATE Historial_Rol_Empleado
  SET fecha_fin = SYSUTCDATETIME(), activo = 0
  WHERE empleado_id = 4 AND activo = 1;

  INSERT INTO Historial_Rol_Empleado (empleado_id, rol, activo, cambiado_por, motivo)
  VALUES (4, 'maestro', 1, 1, 'Promovido de ayudante a maestro');
  COMMIT;
END TRY
BEGIN CATCH ROLLBACK; PRINT 'Error D: ' + ERROR_MESSAGE(); END CATCH;
GO

-- E) Actualizar diseno: agregar accesorio nuevo (nueva version)
BEGIN TRY
  BEGIN TRAN;
  INSERT INTO Accesorio (nombre, descripcion)
  VALUES ('Hebilla dorada', 'Hebilla metalica decorativa dorada');

  INSERT INTO Diseno_Version (diseno_id, version_num, creado_por, notas)
  VALUES (1, 2, 1, 'Version 2: agrega hebilla dorada');

  INSERT INTO Diseno_Material (diseno_version_id, material_id, cantidad_por_unidad, posicion)
  SELECT 2, material_id, cantidad_por_unidad, posicion FROM Diseno_Material WHERE diseno_version_id = 1;

  INSERT INTO Diseno_Accesorio (diseno_version_id, accesorio_id, cantidad)
  VALUES (2, 1, 1);
  COMMIT;
END TRY
BEGIN CATCH ROLLBACK; PRINT 'Error E: ' + ERROR_MESSAGE(); END CATCH;
GO

-- F) Actualizar diseno: agregar trozo de material diferente (nueva version)
BEGIN TRY
  BEGIN TRAN;
  INSERT INTO Material (nombre, descripcion, unidad_medida)
  VALUES ('Refuerzo PU', 'Poliuretano para refuerzo lateral', 'm2');

  INSERT INTO Diseno_Version (diseno_id, version_num, creado_por, notas)
  VALUES (1, 3, 1, 'Version 3: 3 trozos, agrega refuerzo PU');

  INSERT INTO Diseno_Material (diseno_version_id, material_id, cantidad_por_unidad, posicion)
  SELECT 3, material_id, cantidad_por_unidad, posicion FROM Diseno_Material WHERE diseno_version_id = 2;

  INSERT INTO Diseno_Material (diseno_version_id, material_id, cantidad_por_unidad, posicion)
  VALUES (3, 3, 0.05, 'refuerzo lateral');
  COMMIT;
END TRY
BEGIN CATCH ROLLBACK; PRINT 'Error F: ' + ERROR_MESSAGE(); END CATCH;
GO

-- G) Eliminar el quinto zapato del lote LP-2026-001
BEGIN TRY
  BEGIN TRAN;
  DECLARE @zap_id INT = (
    SELECT zapato_id FROM (
      SELECT zapato_id, ROW_NUMBER() OVER (ORDER BY zapato_id) AS rn
      FROM Zapato WHERE lote_prod_id = 1
    ) t WHERE rn = 5
  );
  IF @zap_id IS NOT NULL DELETE FROM Zapato WHERE zapato_id = @zap_id;
  UPDATE Lote_Produccion SET cantidad_producida = (SELECT COUNT(*) FROM Zapato WHERE lote_prod_id = 1) WHERE lote_prod_id = 1;
  COMMIT;
END TRY
BEGIN CATCH ROLLBACK; PRINT 'Error G: ' + ERROR_MESSAGE(); END CATCH;
GO

-- H) Intentar eliminar diseno con produccion asociada
BEGIN TRY
  BEGIN TRAN;
  IF EXISTS (
    SELECT 1 FROM Lote_Produccion lp
    JOIN Diseno_Version dv ON lp.diseno_version_id = dv.diseno_version_id
    WHERE dv.diseno_id = 1
  )
    PRINT 'No se puede eliminar: el diseno tiene lotes de produccion asociados.';
  ELSE
  BEGIN
    DELETE FROM Diseno_Material WHERE diseno_version_id IN (SELECT diseno_version_id FROM Diseno_Version WHERE diseno_id = 1);
    DELETE FROM Diseno_Version  WHERE diseno_id = 1;
    DELETE FROM Diseno          WHERE diseno_id = 1;
  END
  COMMIT;
END TRY
BEGIN CATCH ROLLBACK; PRINT 'Error H: ' + ERROR_MESSAGE(); END CATCH;
GO

-- I) Nuevo accesorio y diseno que lo use
BEGIN TRY
  BEGIN TRAN;
  INSERT INTO Accesorio (nombre, descripcion)
  VALUES ('Cordones reflectivos', 'Cordones con banda reflectiva 120cm');

  INSERT INTO Diseno (nombre_diseno, descripcion, creado_por)
  VALUES ('Modelo Cordon', 'Zapato deportivo con cordones reflectivos', 1);

  INSERT INTO Diseno_Version (diseno_id, version_num, creado_por, notas)
  VALUES (2, 1, 1, 'Version inicial con cordones');

  INSERT INTO Diseno_Accesorio (diseno_version_id, accesorio_id, cantidad)
  VALUES (4, 2, 2);
  COMMIT;
END TRY
BEGIN CATCH ROLLBACK; PRINT 'Error I: ' + ERROR_MESSAGE(); END CATCH;
GO
