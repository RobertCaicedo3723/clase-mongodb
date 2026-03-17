# Sesión 04 — MongoDB
## Tema: Operadores de evaluación, arreglos y proyección
## Base de datos: sample_restaurants y sample_mflix (MongoDB Atlas)

---

## 1. Operadores de Evaluación

### $regex — Buscar por expresión regular
```js
// Restaurantes cuyo nombre contenga "A"
db.restaurants.find({name: {$regex: /A/}})

// Insensible a mayúsculas/minúsculas
db.restaurants.find({name: {$regex: /A/i}})

// Restaurantes con "Pizza" pero sin "Valentino"
db.restaurants.find({name: {$regex: /Pizza/i, $not: /Valentino/i}})
```

### $type — Filtrar por tipo de dato BSON
```js
// Usar sample_mflix
use sample_mflix

// Películas donde "year" es entero
db.movies.find({year: {$type: "int"}})

// Con conteo
db.movies.find({year: {$type: "int"}}).count()

// Proyectando solo el campo year
db.movies.find({year: {$type: "int"}}, {year: 1, _id: 0})

// Con título incluido
db.movies.find({year: {$type: "int"}}, {title: 1, year: 1, _id: 0})
```

---

## 2. Operadores de Arreglos

### Dot notation — Acceder a campos dentro de un array
```js
use sample_restaurants

// Acceder a campos dentro del array grades
db.restaurants.find({}, {"grades.score": 1, _id: 0})

// Filtrar por grade igual a "A" usando $eq
db.restaurants.find({"grades.grade": {$eq: "A"}}, {"grades.grade": 1, _id: 0})
```

---

## 3. Operadores de Proyección

### Proyección básica con filtro en array
```js
// Nombre y grades completos de restaurantes con grade "A"
db.restaurants.find({"grades.grade": {$eq: "A"}}, {name: 1, grades: 1, _id: 0})
```

### $slice — Limitar elementos devueltos de un array
```js
// Solo los primeros 2 elementos del array grades
db.restaurants.find(
  {"grades.grade": {$eq: "A"}},
  {name: 1, grades: {$slice: 2}, _id: 0}
).limit(5)
```

### $meta — Puntaje de relevancia en búsqueda de texto
```js
// Crear índice de texto (si no existe)
db.restaurants.createIndex({name: "text"})

// Buscar "Pizza" con puntaje de relevancia
db.restaurants.find(
  {$text: {$search: "Pizza"}},
  {name: 1, grades: {$slice: 2}, score: {$meta: "textScore"}, _id: 0}
).limit(5)
```

> Nota: En Atlas puede existir un índice de texto previo con más campos (ej. name + cuisine).
> En ese caso no es necesario crear uno nuevo, el existente funciona para la búsqueda.
