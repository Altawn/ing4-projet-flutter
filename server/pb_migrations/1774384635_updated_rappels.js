/// <reference path="../pb_data/types.d.ts" />
migrate((app) => {
  const collection = app.findCollectionByNameOrId("pbc_1758851292")

  // remove field
  collection.fields.removeById("text_numero_fiche")

  // remove field
  collection.fields.removeById("text_marque_produit")

  // remove field
  collection.fields.removeById("text_date_fin_procedure")

  // remove field
  collection.fields.removeById("text_modalites_compensation")

  return app.save(collection)
}, (app) => {
  const collection = app.findCollectionByNameOrId("pbc_1758851292")

  // add field
  collection.fields.addAt(2, new Field({
    "autogeneratePattern": "",
    "hidden": false,
    "id": "text_numero_fiche",
    "max": 0,
    "min": 0,
    "name": "numero_fiche",
    "pattern": "",
    "presentable": false,
    "primaryKey": false,
    "required": false,
    "system": false,
    "type": "text"
  }))

  // add field
  collection.fields.addAt(4, new Field({
    "autogeneratePattern": "",
    "hidden": false,
    "id": "text_marque_produit",
    "max": 0,
    "min": 0,
    "name": "marque_produit",
    "pattern": "",
    "presentable": false,
    "primaryKey": false,
    "required": false,
    "system": false,
    "type": "text"
  }))

  // add field
  collection.fields.addAt(9, new Field({
    "autogeneratePattern": "",
    "hidden": false,
    "id": "text_date_fin_procedure",
    "max": 0,
    "min": 0,
    "name": "date_de_fin_de_la_procedure_de_rappel",
    "pattern": "",
    "presentable": false,
    "primaryKey": false,
    "required": false,
    "system": false,
    "type": "text"
  }))

  // add field
  collection.fields.addAt(22, new Field({
    "autogeneratePattern": "",
    "hidden": false,
    "id": "text_modalites_compensation",
    "max": 0,
    "min": 0,
    "name": "modalites_de_compensation",
    "pattern": "",
    "presentable": false,
    "primaryKey": false,
    "required": false,
    "system": false,
    "type": "text"
  }))

  return app.save(collection)
})
