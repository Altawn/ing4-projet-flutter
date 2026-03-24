

migrate((app) => {
    let collection;
    try {
        collection = app.findCollectionByNameOrId("rappels");
    } catch (e) {
        collection = new Collection({
            name: "rappels",
            type: "base",
            system: false,
        });
    }

    
    const addTextField = (name) => {
        try {
            collection.fields.getByName(name);
        } catch (e) {
            collection.fields.add(new Field({
                name: name,
                type: "text",
            }));
        }
    };

    addTextField("gtin");
    addTextField("numero_fiche");
    addTextField("libelle");
    addTextField("marque_produit");
    addTextField("image");
    addTextField("motif_rappel");
    addTextField("risques_encourus");
    addTextField("distributeurs");
    addTextField("zone_geographique");
    addTextField("date_debut");
    addTextField("date_fin");
    addTextField("conduite_a_tenir");
    addTextField("modalites_compensation");
    addTextField("date_fin_procedure");
    addTextField("lien_fiche");

    
    collection.listRule = "";
    collection.viewRule = "";
    collection.createRule = null;
    collection.updateRule = null;
    collection.deleteRule = null;

    return app.save(collection);
}, (app) => {
    return null;
})
