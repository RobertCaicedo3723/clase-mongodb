# Sesión 03 - MongoDB find() y Query Operators

Colección usada: `sample_restaurants` (25,359 documentos)
Campos principales: name, cuisine, borough, grades (grade, score, date), address

---

## Operadores de Comparación

### $eq - Igual a
db.restaurants.find({ "cuisine": { $eq: "Italian" } }, { "name": 1, "cuisine": 1 })

### $ne - No igual a
db.restaurants.find({ "cuisine": { $ne: "American" } }, { "name": 1, "cuisine": 1 })

### $gt - Mayor que
db.restaurants.find({ "grades.score": { $gt: 20 } }, { "name": 1, "grades.score": 1 })

### $lte - Menor o igual que
db.restaurants.find({ "grades.score": { $lte: 10 } }, { "name": 1, "grades.score": 1 })

---

## Operadores Lógicos

### $or - Puntajes altos o en Manhattan
db.restaurants.find({ $or: [ { "grades.score": { $gte: 25 } }, { "borough": "Manhattan" } ] }, { "name": 1, "grades.score": 1, "borough": 1 })

### $not - Calificaciones que no son <= 15
db.restaurants.find({ "grades.score": { $not: { $lte: 15 } } }, { "name": 1, "grades.score": 1 })

### $and + $in - Italianos o mexicanos en el Bronx
db.restaurants.find({ $and: [ { "cuisine": { $in: ["Italian", "Mexican"] } }, { "borough": "Bronx" } ] }, { "name": 1, "cuisine": 1, "borough": 1 })

### $nor - Excluir chinos/thaís o Staten Island
db.restaurants.find({ $nor: [ { "cuisine": { $in: ["Chinese", "Thai"] } }, { "borough": "Staten Island" } ] }, { "name": 1, "cuisine": 1, "borough": 1 })

### $and + $not - Grado A pero nunca score < 10
db.restaurants.find({ $and: [ { "grades.grade": "A" }, { "grades.score": { $not: { $lt: 10 } } } ] }, { "name": 1, "grades.grade": 1, "grades.score": 1 })

### Queens o Bronx, no americanos ni chinos, >= 3 calificaciones
db.restaurants.find({ $and: [ { "borough": { $in: ["Queens", "Bronx"] } }, { "cuisine": { $nin: ["American", "Chinese"] } }, { "grades": { $exists: true }, "grades.2": { $exists: true } } ] }, { "name": 1, "cuisine": 1, "borough": 1 })

### $regex + $or - Nombre con "Grill" y score > 20 o en Staten Island
db.restaurants.find({ $or: [ { $and: [ { "name": { $regex: /Grill/i } }, { "grades.score": { $gt: 20 } } ] }, { "borough": "Staten Island" } ] }, { "name": 1, "grades.score": 1, "borough": 1 })

### $exists - Manhattan sin dirección o sin building
db.restaurants.find({ $and: [ { "borough": "Manhattan" }, { $or: [ { "address": { $exists: false } }, { "address.building": { $exists: false } } ] } ] }, { "name": 1, "borough": 1, "address": 1 })

### $elemMatch - Al menos dos calificaciones > 25
db.restaurants.find({ "grades": { $elemMatch: { "score": { $gt: 25 } } } }, { "name": 1, "grades.score": 1 })

### $and + $regex - Seafood con grado A o B pero no C
db.restaurants.find({ $and: [ { "cuisine": { $regex: /Seafood/i } }, { "grades.grade": { $in: ["A", "B"] } }, { "grades.grade": { $ne: "C" } } ] }, { "name": 1, "cuisine": 1, "grades.grade": 1 })

### $ne + $not + $regex - No Manhattan y nombre sin "Pizza" ni "Cafe"
db.restaurants.find({ $and: [ { "borough": { $ne: "Manhattan" } }, { "name": { $not: /Pizza|Cafe/i } } ] }, { "name": 1, "borough": 1 })

---

## Operadores de Evaluación y Arreglos

### $expr + $size + $avg - 5 o mas calificaciones con promedio >= 15
db.restaurants.find({ $expr: { $and: [ { $gte: [{ $size: "$grades" }, 5] }, { $gte: [{ $avg: "$grades.score" }, 15] } ] } }, { "name": 1, "grades.score": 1 })

### $elemMatch - Cocina italiana con grado A y score > 25
db.restaurants.find({ $and: [ { "cuisine": "Italian" }, { "grades": { $elemMatch: { "grade": "A", "score": { $gt: 25 } } } } ] }, { "name": 1, "cuisine": 1, "grades": 1 })

### $regex + $size - Nombre empieza con "Pizza" y exactamente 2 calificaciones
db.restaurants.find({ $and: [ { "name": { $regex: /^Pizza/i } }, { "grades": { $size: 2 } } ] }, { "name": 1, "grades": 1 })

### $jsonSchema + $expr - Campo name tipo string y largo > 10
db.restaurants.find({ $and: [ { $jsonSchema: { bsonType: "object", required: ["name"], properties: { name: { bsonType: "string" } } } }, { $expr: { $gt: [{ $strLenCP: "$name" }, 10] } } ] }, { "name": 1 })

### $text + $expr - Mencionen "sushi" y promedio > 18
// Requiere índice: db.restaurants.createIndex({ "name": "text", "cuisine": "text" })
db.restaurants.find({ $and: [ { $text: { $search: "sushi" } }, { $expr: { $gt: [{ $avg: "$grades.score" }, 18] } } ] }, { "name": 1, "cuisine": 1 })

### $mod - restaurant_id multiplo de 3 con grado B y score >= 20
db.restaurants.find({ $and: [ { "restaurant_id": { $mod: [3, 0] } }, { "grades": { $elemMatch: { "grade": "B", "score": { $gte: 20 } } } } ] }, { "name": 1, "restaurant_id": 1, "grades": 1 })

### $regex + $size - Nombre con "Grill" y exactamente 3 calificaciones
db.restaurants.find({ $and: [ { "name": { $regex: /Grill/i } }, { "grades": { $size: 3 } } ] }, { "name": 1, "grades": 1 })

### $elemMatch + $expr - Grado C y promedio < 12
db.restaurants.find({ $and: [ { "grades": { $elemMatch: { "grade": "C" } } }, { $expr: { $lt: [{ $avg: "$grades.score" }, 12] } } ] }, { "name": 1, "grades": 1 })

### $regex + $size - "burger" en nombre, exactamente 4 calificaciones
db.restaurants.find({ $and: [ { "name": { $regex: /burger/i } }, { "grades": { $size: 4 } } ] }, { "name": 1, "cuisine": 1, "grades": 1 })

### $regex + $elemMatch - Nombre termina en "House" con grado A y score > 20
db.restaurants.find({ $and: [ { "name": { $regex: /House$/i } }, { "grades": { $elemMatch: { "grade": "A", "score": { $gt: 20 } } } } ] }, { "name": 1, "grades": 1 })

---

## Operadores de Proyección

### $slice - Italianos mostrando primeros 2 grades
db.restaurants.find({ "cuisine": "Italian" }, { "name": 1, "grades": { $slice: 2 } })

### $elemMatch en proyección - Score >= 20
db.restaurants.find({ "borough": "Brooklyn" }, { "name": 1, "grades": { $elemMatch: { "score": { $gte: 20 } } } })

### $ - Primer grade que sea "A"
db.restaurants.find({ "grades.grade": "A" }, { "name": 1, "grades.$": 1 }).limit(5)

### $slice negativo - Mexicanos con ultimos 2 grades
db.restaurants.find({ "cuisine": "Mexican" }, { "name": 1, "grades": { $slice: -2 } }).limit(5)

### $text + $meta - Buscar "pizza" con relevancia
db.restaurants.find({ $text: { $search: "pizza" } }, { "name": 1, "score": { $meta: "textScore" } }).sort({ "score": { $meta: "textScore" } }).limit(5)

### $text + $ + $meta - Buscar "italian" con primer grade y relevancia
db.restaurants.find({ $and: [ { $text: { $search: "italian" } }, { "grades.grade": "A" } ] }, { "name": 1, "grades.$": 1, "score": { $meta: "textScore" } }).limit(5)

### $elemMatch - Brooklyn con score >= 25
db.restaurants.find({ "borough": "Brooklyn" }, { "name": 1, "grades": { $elemMatch: { "score": { $gte: 25 } } } }).limit(5)

### $slice + $text + $meta - "italian" con 2 grades y relevancia
db.restaurants.find({ $text: { $search: "italian" } }, { "name": 1, "grades": { $slice: 2 }, "score": { $meta: "textScore" } }).sort({ "score": { $meta: "textScore" } }).limit(5)
