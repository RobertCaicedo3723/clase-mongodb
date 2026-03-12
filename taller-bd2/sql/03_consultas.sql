-- =====================================================
-- TALLER BD2 - EMPRESA HUELLITAS
-- 03: Consultas de trazabilidad
-- Autores: Robert Caicedo Sanchez, Kaleth Ceballos
-- =====================================================

USE TallerZapateria;
GO

-- Consulta 1: En que zapatos fue usado determinado molde
DECLARE @MoldeId INT = 1;

SELECT z.zapato_id,
       z.serial,
       z.talla,
       z.fecha_ensamblado,
       z.estado_zapato,
       lp.codigo_lote_prod
FROM   Zapato z
LEFT JOIN Lote_Produccion lp ON z.lote_prod_id = lp.lote_prod_id
WHERE  z.molde_usado_id = @MoldeId
ORDER BY z.fecha_ensamblado DESC;
GO

-- Consulta 2: Que lotes de material fueron usados en la construccion de un zapato
DECLARE @Serial NVARCHAR(150) = 'ZAP-LP001-1';

SELECT DISTINCT
       lm.lote_material_id,
       lm.codigo_lote,
       mat.nombre  AS material,
       lm.fecha_recepcion,
       lm.cantidad_inicial,
       lm.cantidad_disponible
FROM   Zapato z
JOIN   Trozo  t   ON t.zapato_id        = z.zapato_id
JOIN   Lote_Material lm ON t.lote_material_id = lm.lote_material_id
JOIN   Material mat     ON lm.material_id     = mat.material_id
WHERE  z.serial = @Serial
ORDER BY lm.lote_material_id;
GO

-- Consulta 3: Cuantos zapatos se crearon para un diseno determinado
DECLARE @Nombre NVARCHAR(150) = 'Modelo Actividad';

-- Total general
SELECT d.diseno_id,
       d.nombre_diseno,
       COUNT(z.zapato_id) AS total_zapatos
FROM   Diseno d
LEFT JOIN Diseno_Version dv ON dv.diseno_id        = d.diseno_id
LEFT JOIN Zapato         z  ON z.diseno_version_id = dv.diseno_version_id
WHERE  d.nombre_diseno = @Nombre
GROUP BY d.diseno_id, d.nombre_diseno;

-- Desglose por version
SELECT dv.version_num,
       dv.notas,
       COUNT(z.zapato_id) AS zapatos_en_version
FROM   Diseno d
JOIN   Diseno_Version dv ON dv.diseno_id        = d.diseno_id
LEFT JOIN Zapato      z  ON z.diseno_version_id = dv.diseno_version_id
WHERE  d.nombre_diseno = @Nombre
GROUP BY dv.diseno_version_id, dv.version_num, dv.notas
ORDER BY dv.version_num;
GO
