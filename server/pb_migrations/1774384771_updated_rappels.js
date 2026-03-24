/// <reference path="../pb_data/types.d.ts" />
migrate((app) => {
  const collection = app.findCollectionByNameOrId("pbc_1758851292")

  // remove field
  collection.fields.removeById("text_modeles_references")

  // remove field
  collection.fields.removeById("text_date_publication")

  // remove field
  collection.fields.removeById("text_preconisations")

  // remove field
  collection.fields.removeById("text_categorie")

  // remove field
  collection.fields.removeById("text_sous_categorie")

  // remove field
  collection.fields.removeById("text_nature_juridique")

  // remove field
  collection.fields.removeById("text_numero_contact")

  return app.save(collection)
}, (app) => {
  const collection = app.findCollectionByNameOrId("pbc_1758851292")

  // add field
  collection.fields.addAt(3, new Field({
    "autogeneratePattern": "",
    "hidden": false,
    "id": "text_modeles_references",
    "max": 0,
    "min": 0,
    "name": "modeles_ou_references",
    "pattern": "",
    "presentable": false,
    "primaryKey": false,
    "required": false,
    "system": false,
    "type": "text"
  }))

  // add field
  collection.fields.addAt(6, new Field({
    "autogeneratePattern": "",
    "hidden": false,
    "id": "text_date_publication",
    "max": 0,
    "min": 0,
    "name": "date_publication",
    "pattern": "",
    "presentable": false,
    "primaryKey": false,
    "required": false,
    "system": false,
    "type": "text"
  }))

  // add field
  collection.fields.addAt(11, new Field({
    "autogeneratePattern": "",
    "hidden": false,
    "id": "text_preconisations",
    "max": 0,
    "min": 0,
    "name": "preconisations_sanitaires",
    "pattern": "",
    "presentable": false,
    "primaryKey": false,
    "required": false,
    "system": false,
    "type": "text"
  }))

  // add field
  collection.fields.addAt(12, new Field({
    "autogeneratePattern": "",
    "hidden": false,
    "id": "text_categorie",
    "max": 0,
    "min": 0,
    "name": "categorie_produit",
    "pattern": "",
    "presentable": false,
    "primaryKey": false,
    "required": false,
    "system": false,
    "type": "text"
  }))

  // add field
  collection.fields.addAt(13, new Field({
    "autogeneratePattern": "",
    "hidden": false,
    "id": "text_sous_categorie",
    "max": 0,
    "min": 0,
    "name": "sous_categorie_produit",
    "pattern": "",
    "presentable": false,
    "primaryKey": false,
    "required": false,
    "system": false,
    "type": "text"
  }))

  // add field
  collection.fields.addAt(14, new Field({
    "autogeneratePattern": "",
    "hidden": false,
    "id": "text_nature_juridique",
    "max": 0,
    "min": 0,
    "name": "nature_juridique_rappel",
    "pattern": "",
    "presentable": false,
    "primaryKey": false,
    "required": false,
    "system": false,
    "type": "text"
  }))

  // add field
  collection.fields.addAt(18, new Field({
    "autogeneratePattern": "",
    "hidden": false,
    "id": "text_numero_contact",
    "max": 0,
    "min": 0,
    "name": "numero_contact",
    "pattern": "",
    "presentable": false,
    "primaryKey": false,
    "required": false,
    "system": false,
    "type": "text"
  }))

  return app.save(collection)
})
