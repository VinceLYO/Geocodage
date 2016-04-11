# Géocodage d'adresses en France avec R et SPSS MODELER

###Desciption :
Ce nœud vous permettra de géocoder des adresses en France, en utilisant l'API de la Base Adresse Nationale, résultat de la collaboration de l'IGN / La Poste / Open Street Map et des services de l'état : http://adresse.data.gouv.fr/api/

Aucune limite journalière, le nombre de requêtes est illimité.

### Fonctionnement :

Récupération des résultats rendus par l'url : http://api-adresse.data.gouv.fr/search/?q=<b>Mes Adresses</b>

###### Étape 1 : Transformer les adresses en requêtes url :

```R
    url <- function(address,return.call = "json") {
    library(RCurl)
    root <- "http://api-adresse.data.gouv.fr/search/"
    u <- paste(root, "?q=", address, sep = "")
    return(gsub(' ','%20',u))
    }
```

###### Étape 2 : Récupérer les [résultats](http://api-adresse.data.gouv.fr/search/?q=8%20bd%20du%20port) sous format .json

```R
u <- url(address)
doc <- getURL(u)
```

###### Étape 3 : Parser le .json pour en extraire le résultat

```R
      x <- fromJSON(doc)
      Adresse <- x$features[1,]$properties["name"]
      Score <- x$features[1,]$properties["score"]
      Ville <- x$features[1,]$properties["city"]
      Type <- x$features[1,]$properties["type"]
      CP <- x$features[1,]$properties["postcode"]
      return(data.frame(lat = as.data.frame(coord)[2,1],
                        long = as.data.frame(coord)[1,1],
                        INSEE,
                        Adresse,
                        CP,
                        Ville,
                        Type,
                        Score))}
```

###### Étape 4 : Restituer les résultats dans Modeler

```R
modelerData<-cbind(modelerData,results$lat)
var1<-c(fieldName="Latitude_result",fieldLabel="",fieldStorage="string",fieldFormat="",fieldMeasure="",  fieldRole="")
modelerDataModel<-data.frame(modelerDataModel,var1)

modelerData<-cbind(modelerData,results$long)
var2<-c(fieldName="Longitude_result",fieldLabel="",fieldStorage="string",fieldFormat="",fieldMeasure="",  fieldRole="")
modelerDataModel<-data.frame(modelerDataModel,var2)
```

###Pré-requis :
- SPSS Modeler 17 ou plus
- IBM SPSS Modeler 'R Essentials' Plugin
- R 3.1

###Interface
Lecture du champ "Adresses" qui contient :
- Le numéro de voie
- La voie
- le Code Postal
- La ville  

Exemple : 17 rue de l'église, 23300 Fenioux

![alt tag](https://raw.githubusercontent.com/VinceLYO/TEST/master/Capture_1.JPG)

###Sorties :
- Latitude_result
- Longitude_result
- INSEE_result : code INSEE de la commune
- CP_result : code postal
- Ville_result : nom de la commune
- Type_result : type de résultat trouvé
    * housenumber : numéro "à la plaque"
    * street : position "à la voie", placé approximativement au centre de celle-ci
    * place : lieu-dit
    * village : numéro "à la commune" dans un village
    * city : numéro "à la commune" dans une grande ville
    * town : numéro "à la commune" dans une ville moyenne
    * Score_result : valeur de 0 à 1 indiquant la pertinence du résultat

![alt tag](https://raw.githubusercontent.com/VinceLYO/TEST/master/Capture_2.JPG)

###R Packages :
[Jsonlite](https://cran.r-project.org/web/packages/jsonlite/index.html)  
[Bitops](https://cran.r-project.org/web/packages/bitops/index.html)  
[RCurl](https://cran.r-project.org/web/packages/RCurl/index.html)  

