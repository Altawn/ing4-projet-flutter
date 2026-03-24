

function performSync(maxRecords) {
    const limit = 50;
    let offset = 0;
    let total = 1;

    console.log("Starting RappelConso sync...");

    while (offset < total && (!maxRecords || offset < maxRecords)) {
        try {
            const response = $http.send({
                url: `https://data.economie.gouv.fr/api/explore/v2.1/catalog/datasets/rappelconso-v2-gtin-trie/records?limit=${limit}&offset=${offset}`,
                method: "GET",
            });

            if (response.statusCode !== 200) {
                console.log("Error fetching from RappelConso API: " + response.statusCode);
                break;
            }

            const data = response.json;
            total = data.total_count;
            const records = data.results;

            if (!records || records.length === 0) break;

            const collection = $app.findCollectionByNameOrId("rappels");

            for (const record of records) {
                try {
                    let existing;
                    try {
                        existing = $app.findFirstRecordByFilter("rappels", `numero_fiche = "${record.numero_fiche}"`);
                    } catch (e) {
                        
                    }

                    const rec = existing || new Record(collection);
                    
                    rec.set("gtin", record.gtin ? record.gtin.toString() : "");
                    rec.set("numero_fiche", record.numero_fiche);
                    rec.set("libelle", record.libelle);
                    rec.set("marque_produit", record.marque_produit);
                    rec.set("image", record.liens_vers_les_images);
                    rec.set("motif_rappel", record.motif_rappel);
                    rec.set("risques_encourus", record.risques_encourus);
                    rec.set("distributeurs", record.distributeurs);
                    rec.set("zone_geographique", record.zone_geographique_de_vente);
                    rec.set("date_debut", record.date_debut_commercialisation);
                    rec.set("date_fin", record.date_date_fin_commercialisation);
                    rec.set("conduite_a_tenir", record.conduites_a_tenir_par_le_consommateur);
                    rec.set("modalites_compensation", record.modalites_de_compensation);
                    rec.set("date_fin_procedure", record.date_de_fin_de_la_procedure_de_rappel);
                    rec.set("lien_fiche", record.lien_vers_la_fiche_rappel);

                    $app.save(rec);
                } catch (e) {
                    
                }
            }

            offset += limit;
            console.log(`Synced ${offset}/${total} records...`);
        } catch (e) {
            console.log("Fetch error: " + e);
            break;
        }
    }

    console.log("RappelConso sync completed.");
}

cronAdd("syncRappels", "0 2 * * *", () => {
    
    console.log("CRON STARTING FULL DAILY SYNC...");
    performSync(null); 
});


