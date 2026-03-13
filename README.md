# clase-mongodb

Repositorio de ejercicios, notas y dumps de la clase de MongoDB.

---

## Estructura del repositorio
clase-mongodb/
├── sesion-01/         # find() básico, proyecciones, sort, limit, skip
│   └── notas.md
├── sesion-02/         # Operadores de comparación, lógicos, $regex, $elemMatch
│   └── notas.md
├── sesion-03/         # find() avanzado, $expr, $jsonSchema, proyección
│   └── notas.md
├── dumps/             # Backups de bases de datos con mongodump
└── README.md

## Colección principal

- **Base de datos:** `sample_restaurants` (MongoDB Atlas)
- **Documentos:** 25,359
- **Campos clave:** `name`, `cuisine`, `borough`, `grades`, `address`

---

## Sesiones

| Sesión | Tema | Operadores vistos |
|--------|------|-------------------|
| 01 | Introducción y find() básico | `find()`, `findOne()`, proyecciones, `sort()`, `limit()`, `skip()`, `countDocuments()` |
| 02 | Operadores de consulta | `$eq`, `$ne`, `$gt`, `$lte`, `$in`, `$nin`, `$and`, `$or`, `$nor`, `$not`, `$exists`, `$regex`, `$elemMatch` |
| 03 | Consultas avanzadas | `$expr`, `$size`, `$avg`, `$jsonSchema`, `$text`, `$mod`, `$slice`, `$meta` |

---

## Herramientas

- MongoDB 7.x + mongosh
- mongodb-database-tools (`mongodump`)
- Fedora Linux
- Git + GitHub (SSH)
