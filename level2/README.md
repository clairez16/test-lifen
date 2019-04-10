# Niveau 2

Nous venons de recevoir le MVP de notre application de communication e-santé. Nous souhaitons une API avec 2 endpoints pour créer une `Communication` puis pour consulter toutes les `Communication` émises.

Voici les instructions pour lancer l'application :

```bash
bundle install
rails db:create
rails db:migrate
rake populate:init
rails server
```

Cela vous permettra d'avoir une application rails avec un volume de donnée similaire à notre prédictions d'usage.

Nos premiers utilisateurs nous ont signalé que l'application était particulièrement lente ...

La consigne principale pour ce niveau est d'améliorer ces 2 endpoints.
Nous attendons une approche data driven ainsi que des explications claires sur les améliorations proposées.

## Endpoints

### Lister les `Communication`

```bash
curl -X GET http://localhost:3000/api/communications -H 'Content-Type: application/json'
```

### Créer une `Communication`

Pour cet exemple vous aurez besoin de créer un `Practitioner` en amont via : `Practitioner.create(first_name: 'Fritz', last_name: 'Kertzmann')`

```bash
curl -X POST \
  http://localhost:3000/api/communications \
  -H 'Content-Type: application/json' \
  -d '{
	"communication" : {
		"first_name" : "Fritz",
		"last_name" : "Kertzmann",
		"sent_at" : "2019-01-01"
	}
}'
```


Amélioration de la méthode index (pour 10 itérations):
- Avant tout changement > 63.154729157 s
- Passer à Communication.includes(:practitioner).to_json > 7.236124021 s


Amélioration de la méthode create (pour 10000 itérations):
- Avant toute modification > 146.370824222 s
- Passer à find_by à la place de where().first > 142.651312388 s
- Changer schema de db pour ajouter reference à practitioner dans table communication + passer à Communication.new(practitioner: practitioner...) > supprime une requête SQL > 134.45091281
- Si beaucoup de create par batch, possible de le passer en background job
