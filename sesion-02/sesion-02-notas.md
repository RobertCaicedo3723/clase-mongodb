# Sesión 02 - Operadores de Consulta

Colección usada: `sample_restaurants` (25,359 documentos)
Campos principales: name, cuisine, borough, grades (grade, score, date), address

---

## Operadores de Comparación

### $eq - Igual a (forma explícita)
db.restaurants.find({ "cuisine": { $eq: "Italian" } }, { "name": 1, "cuisine": 1 })

### $ne - No igual a
db.restaurants.find({ "cuisine": { $ne: "American" } }, { "name": 1, "cuisine": 1 })

### $gt - Mayor que
db.restaurants.find({ "grades.score": { $gt: 30 } }, { "name": 1, "grades.score": 1 })

### $gte - Mayor o igual que
db.restaurants.find({ "grades.score": { $gte: 25 } }, { "name": 1, "grades.score": 1 })

### $lt - Menor que
db.restaurants.find({ "grades.score": { $lt: 5 } }, { "name": 1, "grades.score": 1 })

### $lte - Menor o igual que
db.restaurants.find({ "grades.score": { $lte: 10 } }, { "name": 1, "grades.score": 1 })

---

## Operadores de Inclusión

### $in - El valor está dentro de la lista
db.restaurants.find({ "cuisine": { $in: ["Italian", "Mexican", "French"] } }, { "name": 1, "cuisine": 1 })

### $nin - El valor NO está en la lista
db.restaurants.find({ "borough": { $nin: ["Manhattan", "Brooklyn"] } }, { "name": 1, "borough": 1 })

### $in con grades.grade
db.restaurants.find({ "grades.grade": { $in: ["A", "B"] } }, { "name": 1, "grades.grade": 1 }).limit(5)

### $nin con grades.grade
db.restaurants.find({ "grades.grade": { $nin: ["C", "Z"] } }, { "name": 1, "grades.grade": 1 }).limit(5)

---

## Operadores Lógicos

### $and - Cumple todas las condiciones
db.restaurants.find({ $and: [ { "cuisine": "Italian" }, { "borough": "Manhattan" } ] }, { "name": 1, "cuisine": 1, "borough": 1 })

### $or - Cumple al menos una condición
db.restaurants.find({ $or: [ { "cuisine": "Italian" }, { "borough": "Queens" } ] }, { "name": 1, "cuisine": 1, "borough": 1 })

### $nor - No cumple ninguna de las condiciones
db.restaurants.find({ $nor: [ { "cuisine": "Chinese" }, { "borough": "Manhattan" } ] }, { "name": 1, "cuisine": 1, "borough": 1 })

### $not - Niega una condición
db.restaurants.find({ "grades.score": { $not: { $gt: 20 } } }, { "name": 1, "grades.score": 1 })

### $and + $or combinados - Italiano o Mexicano en Brooklyn
db.restaurants.find({ $and: [ { $or: [ { "cuisine": "Italian" }, { "cuisine": "Mexican" } ] }, { "borough": "Brooklyn" } ] }, { "name": 1, "cuisine": 1, "borough": 1 })

### $and + $in - Chino o Tailandés en el Bronx
db.restaurants.find({ $and: [ { "cuisine": { $in: ["Chinese", "Thai"] } }, { "borough": "Bronx" } ] }, { "name": 1, "cuisine": 1, "borough": 1 })

---

## Operadores de Existencia y Tipo

### $exists: true - El campo sí existe
db.restaurants.find({ "address.building": { $exists: true } }, { "name": 1, "address.building": 1 }).limit(5)

### $exists: false - El campo no existe
db.restaurants.find({ "address.building": { $exists: false } }, { "name": 1, "address": 1 }).limit(5)

### $type - Filtrar por tipo de dato BSON
db.restaurants.find({ "restaurant_id": { $type: "string" } }, { "name": 1, "restaurant_id": 1 }).limit(5)

---

## Operador $regex

### Nombre que contenga "Pizza"
db.restaurants.find({ "name": { $regex: /Pizza/i } }, { "name": 1, "cuisine": 1 })

### Nombre que empiece con "The"
db.restaurants.find({ "name": { $regex: /^The/i } }, { "name": 1 }).limit(5)

### Cuisine que contenga "sea"
db.restaurants.find({ "cuisine": { $regex: /sea/i } }, { "name": 1, "cuisine": 1 })

---

## Operadores de Arreglos

### $all - El arreglo contiene todos los valores
db.restaurants.find({ "grades.grade": { $all: ["A", "B"] } }, { "name": 1, "grades.grade": 1 }).limit(5)

### $size - Arreglo con exactamente N elementos
db.restaurants.find({ "grades": { $size: 3 } }, { "name": 1, "grades": 1 }).limit(5)

### $elemMatch - Al menos un elemento del arreglo cumple varias condiciones a la vez
db.restaurants.find({ "grades": { $elemMatch: { "grade": "A", "score": { $gt: 20 } } } }, { "name": 1, "grades": 1 }).limit(5)
