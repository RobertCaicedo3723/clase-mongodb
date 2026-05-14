# Sesión 01 - Introducción a MongoDB y find() básico

Colección usada: `sample_restaurants` (25,359 documentos)
Campos principales: name, cuisine, borough, grades (grade, score, date), address

---

## Conexión y navegación

### Conectarse a MongoDB Atlas con mongosh
mongosh "mongodb+srv://<cluster-url>" --username <usuario>

### Ver bases de datos disponibles
show dbs

### Seleccionar base de datos
use sample_restaurants

### Ver colecciones disponibles
show collections

### Ver estructura de un documento
db.restaurants.findOne()

---

## find() sin filtro

### Traer todos los documentos
db.restaurants.find()

### Traer con límite
db.restaurants.find().limit(5)

### Formato legible
db.restaurants.find().pretty()

### Contar todos los documentos
db.restaurants.countDocuments()

---

## find() con filtro simple (igualdad)

### Buscar por cuisine
db.restaurants.find({ "cuisine": "Italian" })

### Buscar por borough
db.restaurants.find({ "borough": "Manhattan" })

### Buscar por nombre exacto
db.restaurants.find({ "name": "Wendy'S" })

### Buscar por campo anidado con dot notation
db.restaurants.find({ "address.zipcode": "10075" })

### Buscar por campo dentro del arreglo grades
db.restaurants.find({ "grades.grade": "A" })

---

## Proyecciones (incluir / excluir campos)

### Incluir solo name y cuisine (1 = mostrar)
db.restaurants.find({ "cuisine": "Italian" }, { "name": 1, "cuisine": 1 })

### Excluir grades y address (0 = ocultar)
db.restaurants.find({ "borough": "Brooklyn" }, { "grades": 0, "address": 0 })

### Ocultar _id
db.restaurants.find({ "cuisine": "Mexican" }, { "name": 1, "borough": 1, "_id": 0 })

### Mostrar solo nombre y zipcode
db.restaurants.find({ "borough": "Queens" }, { "name": 1, "address.zipcode": 1, "_id": 0 })

---

## sort(), limit() y skip()

### Ordenar por nombre ascendente (1 = A→Z)
db.restaurants.find({ "cuisine": "Chinese" }, { "name": 1 }).sort({ "name": 1 })

### Ordenar por nombre descendente (-1 = Z→A)
db.restaurants.find({ "cuisine": "Chinese" }, { "name": 1 }).sort({ "name": -1 })

### Combinar sort + limit
db.restaurants.find({ "borough": "Queens" }, { "name": 1, "cuisine": 1 }).sort({ "name": 1 }).limit(10)

### skip() para paginación - página 2 de 5 resultados
db.restaurants.find({ "borough": "Bronx" }, { "name": 1 }).skip(5).limit(5)

---

## Contar documentos

### Contar todos
db.restaurants.countDocuments()

### Contar con filtro
db.restaurants.countDocuments({ "cuisine": "Italian" })

### Contar por borough
db.restaurants.countDocuments({ "borough": "Manhattan" })
