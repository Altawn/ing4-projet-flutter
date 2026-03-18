/// <reference path="../pb_data/types.d.ts" />
migrate((app) => {
  const collection = app.findCollectionByNameOrId("products");

  // Ajouter les champs
  collection.fields.add(new Field({
    "hidden": false,
    "id": "text_picture",
    "name": "picture",
    "presentable": false,
    "required": false,
    "system": false,
    "type": "text"
  }));
  
  collection.fields.add(new Field({
    "hidden": false,
    "id": "text_nutriscore",
    "name": "nutriscore",
    "presentable": false,
    "required": false,
    "system": false,
    "type": "text"
  }));

  // Débloquer les règles de base pour que le token soit accepté
  collection.createRule = "";
  collection.viewRule = "";
  collection.listRule = "";
  collection.updateRule = "";
  collection.deleteRule = "";

  return app.save(collection);
}, (app) => {
  const collection = app.findCollectionByNameOrId("products");
  collection.fields.removeById("text_picture");
  collection.fields.removeById("text_nutriscore");
  collection.createRule = null;
  collection.viewRule = null;
  collection.listRule = null;
  collection.updateRule = null;
  collection.deleteRule = null;
  return app.save(collection);
})
