-- =====================================================
-- TALLER BD2 - EMPRESA HUELLITAS
-- 01: Creacion del esquema completo
-- Autores: Robert Caicedo Sanchez, Kaleth Ceballos
-- =====================================================

IF DB_ID('TallerZapateria') IS NULL
  CREATE DATABASE TallerZapateria;
GO
USE TallerZapateria;
GO

CREATE TABLE Proveedor (
  proveedor_id      INT IDENTITY PRIMARY KEY,
  nombre_proveedor  NVARCHAR(150) NOT NULL,
  tipo_proveedor    NVARCHAR(50)  NULL,
  contacto_nombre   NVARCHAR(100) NULL,
  contacto_telefono NVARCHAR(50)  NULL,
  contacto_email    NVARCHAR(150) NULL,
  pais              NVARCHAR(80)  NULL
);
GO

CREATE TABLE Material (
  material_id             INT IDENTITY PRIMARY KEY,
  nombre                  NVARCHAR(150) NOT NULL UNIQUE,
  descripcion             NVARCHAR(300) NULL,
  unidad_medida           NVARCHAR(20)  NULL,
  costo_unitario_estimado DECIMAL(12,2) NULL
);
GO

CREATE TABLE Accesorio (
  accesorio_id   INT IDENTITY PRIMARY KEY,
  nombre         NVARCHAR(150) NOT NULL UNIQUE,
  descripcion    NVARCHAR(300) NULL,
  proveedor_id   INT NULL REFERENCES Proveedor(proveedor_id),
  costo_unitario DECIMAL(12,2) NULL
);
GO

CREATE TABLE Empleado (
  empleado_id      INT IDENTITY PRIMARY KEY,
  tipo_documento   NVARCHAR(20)  NULL,
  numero_documento NVARCHAR(50)  NULL,
  nombre           NVARCHAR(100) NOT NULL,
  apellido         NVARCHAR(100) NOT NULL,
  fecha_nacimiento DATE          NULL,
  telefono         NVARCHAR(50)  NULL,
  email            NVARCHAR(150) NULL,
  fecha_ingreso    DATE          NULL,
  estado_empleado  NVARCHAR(50)  NULL
);
GO

CREATE TABLE Historial_Rol_Empleado (
  historial_id INT IDENTITY PRIMARY KEY,
  empleado_id  INT          NOT NULL REFERENCES Empleado(empleado_id),
  rol          NVARCHAR(50) NOT NULL,
  fecha_inicio DATETIME2    NOT NULL DEFAULT SYSUTCDATETIME(),
  fecha_fin    DATETIME2    NULL,
  cambiado_por INT          NULL REFERENCES Empleado(empleado_id),
  motivo       NVARCHAR(300) NULL,
  activo       BIT          NOT NULL DEFAULT 1
);
GO

CREATE TABLE Lote_Material (
  lote_material_id    INT IDENTITY PRIMARY KEY,
  material_id         INT NOT NULL REFERENCES Material(material_id),
  proveedor_id        INT NULL REFERENCES Proveedor(proveedor_id),
  codigo_lote         NVARCHAR(100) NOT NULL,
  cantidad_inicial    DECIMAL(12,3) NOT NULL,
  cantidad_disponible DECIMAL(12,3) NOT NULL,
  fecha_recepcion     DATE NULL,
  fecha_agotado       DATE NULL,
  gestionado_por      INT  NULL REFERENCES Empleado(empleado_id)
);
GO

CREATE TABLE Lote_Molde (
  lote_molde_id       INT IDENTITY PRIMARY KEY,
  proveedor_id        INT NULL REFERENCES Proveedor(proveedor_id),
  codigo_lote         NVARCHAR(100) NULL,
  fecha_recepcion     DATE NULL,
  cantidad_total      INT  NULL,
  cantidad_disponible INT  NULL
);
GO

CREATE TABLE Lote_Suela (
  lote_suela_id       INT IDENTITY PRIMARY KEY,
  proveedor_id        INT NULL REFERENCES Proveedor(proveedor_id),
  codigo_lote         NVARCHAR(100) NULL,
  fecha_recepcion     DATE NULL,
  cantidad_inicial    INT  NULL,
  cantidad_disponible INT  NULL
);
GO

CREATE TABLE Lote_Accesorio (
  lote_accesorio_id   INT IDENTITY PRIMARY KEY,
  accesorio_id        INT NULL REFERENCES Accesorio(accesorio_id),
  proveedor_id        INT NULL REFERENCES Proveedor(proveedor_id),
  codigo_lote         NVARCHAR(100) NULL,
  fecha_recepcion     DATE NULL,
  cantidad_inicial    INT  NULL,
  cantidad_disponible INT  NULL
);
GO

CREATE TABLE Molde (
  molde_id        INT IDENTITY PRIMARY KEY,
  lote_molde_id   INT NULL REFERENCES Lote_Molde(lote_molde_id),
  numero_serie    NVARCHAR(100) NULL,
  talla           INT NULL,
  tipo_molde      NVARCHAR(100) NULL,
  material_molde  NVARCHAR(100) NULL,
  uso_acumulado   INT NULL DEFAULT 0,
  estado          NVARCHAR(50) NULL
);
CREATE UNIQUE INDEX UQ_Molde_Serie ON Molde(numero_serie) WHERE numero_serie IS NOT NULL;
GO

CREATE TABLE Suela (
  suela_id       INT IDENTITY PRIMARY KEY,
  lote_suela_id  INT NOT NULL REFERENCES Lote_Suela(lote_suela_id),
  talla          INT NULL,
  material_suela NVARCHAR(100) NULL,
  estado         NVARCHAR(50)  NULL
);
GO

CREATE TABLE Diseno (
  diseno_id     INT IDENTITY PRIMARY KEY,
  nombre_diseno NVARCHAR(150) NOT NULL,
  descripcion   NVARCHAR(MAX) NULL,
  creado_por    INT NULL REFERENCES Empleado(empleado_id),
  fecha_creacion DATETIME2 DEFAULT SYSUTCDATETIME()
);
CREATE UNIQUE INDEX UQ_Diseno_Nombre ON Diseno(nombre_diseno);
GO

CREATE TABLE Diseno_Version (
  diseno_version_id INT IDENTITY PRIMARY KEY,
  diseno_id         INT NOT NULL REFERENCES Diseno(diseno_id),
  version_num       INT NOT NULL,
  creado_por        INT NULL REFERENCES Empleado(empleado_id),
  fecha_creacion    DATETIME2 DEFAULT SYSUTCDATETIME(),
  notas             NVARCHAR(MAX) NULL,
  CONSTRAINT UQ_DV UNIQUE (diseno_id, version_num)
);
GO

CREATE TABLE Diseno_Material (
  diseno_version_id   INT           NOT NULL REFERENCES Diseno_Version(diseno_version_id),
  material_id         INT           NOT NULL REFERENCES Material(material_id),
  cantidad_por_unidad DECIMAL(10,3) NOT NULL,
  posicion            NVARCHAR(100) NULL,
  PRIMARY KEY (diseno_version_id, material_id)
);
GO

CREATE TABLE Diseno_Accesorio (
  diseno_version_id INT NOT NULL REFERENCES Diseno_Version(diseno_version_id),
  accesorio_id      INT NOT NULL REFERENCES Accesorio(accesorio_id),
  cantidad          INT NOT NULL DEFAULT 1,
  PRIMARY KEY (diseno_version_id, accesorio_id)
);
GO

CREATE TABLE Lote_Produccion (
  lote_prod_id           INT IDENTITY PRIMARY KEY,
  diseno_version_id      INT NOT NULL REFERENCES Diseno_Version(diseno_version_id),
  codigo_lote_prod       NVARCHAR(100) NULL,
  fecha_inicio           DATETIME2 NULL,
  cantidad_objetivo      INT NOT NULL,
  cantidad_producida     INT NOT NULL DEFAULT 0,
  estado_lote            NVARCHAR(50) NULL,
  responsable_maestro_id INT NULL REFERENCES Empleado(empleado_id)
);
GO

CREATE TABLE Zapato (
  zapato_id         INT IDENTITY PRIMARY KEY,
  serial            NVARCHAR(150) NOT NULL,
  lote_prod_id      INT NOT NULL REFERENCES Lote_Produccion(lote_prod_id),
  diseno_version_id INT NOT NULL REFERENCES Diseno_Version(diseno_version_id),
  talla             INT NULL,
  fecha_ensamblado  DATETIME2 NULL,
  maestro_id        INT NULL REFERENCES Empleado(empleado_id),
  ayudante_id       INT NULL REFERENCES Empleado(empleado_id),
  molde_usado_id    INT NULL REFERENCES Molde(molde_id),
  suela_usada_id    INT NULL REFERENCES Suela(suela_id),
  estado_zapato     NVARCHAR(50) NULL,
  CONSTRAINT UQ_Zapato_Serial UNIQUE (serial)
);
GO

CREATE TABLE Trozo (
  trozo_id         INT IDENTITY PRIMARY KEY,
  material_id      INT NOT NULL REFERENCES Material(material_id),
  lote_material_id INT NULL REFERENCES Lote_Material(lote_material_id),
  cortador_id      INT NULL REFERENCES Empleado(empleado_id),
  zapato_id        INT NULL REFERENCES Zapato(zapato_id),
  fecha_corte      DATETIME2 NULL,
  dimensiones      NVARCHAR(100) NULL,
  pieza_posicion   NVARCHAR(100) NULL,
  estado           NVARCHAR(50)  NULL
);
GO

CREATE TABLE Zapato_Accesorio (
  zapato_accesorio_id INT IDENTITY PRIMARY KEY,
  zapato_id           INT NOT NULL REFERENCES Zapato(zapato_id),
  accesorio_id        INT NOT NULL REFERENCES Accesorio(accesorio_id),
  lote_accesorio_id   INT NULL REFERENCES Lote_Accesorio(lote_accesorio_id),
  cantidad            INT NOT NULL DEFAULT 1,
  instalado_por       INT NULL REFERENCES Empleado(empleado_id),
  fecha_instalacion   DATETIME2 NULL
);
GO

PRINT 'Esquema TallerZapateria creado correctamente.';
GO

