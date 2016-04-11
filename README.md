# Géocodage d'adresses en France avec R et SPSS MODELER

###Desciption :
Ce nœud vous permettra de géocoder des adresses en France, en utilisant l'API de la Base Adresse Nationale, résultat de la collaboration de l'IGN / La Poste / Open Street Map et des services de l'état : http://adresse.data.gouv.fr/api/

Aucune limite journalière, le nombre de requêtes est illimité.

### Fonctionnement :

Récupération des résultats rendus par l'url : http://api-adresse.data.gouv.fr/search/?q=<b>Mon Adresse</b>  
    - Avant traitement : <b>Mon Adresse</b> = 17 rue de la Mairie 11300 Limoux  
    - Après traitement : <b>Mon Adresse</b> = 17%20rue%20de%20la%20Mairie%2011300%20Limoux  

###### Étape 1 : Transformer les adresses en requêtes url :

```R
    url <- function(address,return.call = "json") {
    library(RCurl)
    root <- "http://api-adresse.data.gouv.fr/search/"
    u <- paste(root, "?q=", address, sep = "")
    return(gsub(' ','%20',u))
    }
```

###### Étape 2 : Récupérer les [résultats](http://api-adresse.data.gouv.fr/search/?q=17%20rue%20de%20la%20Mairie%2011300%20Limoux) sous format .json , puis mise en forme.

```R
geoCode <- function(address,verbose=FALSE) {
  library(jsonlite)
  if(verbose) cat(address,"\n")
  u <- url(address)
  doc <- getURL(u)
  #### Cas où pas de résultat ####
  if (doc != "Missing query") {
    x <- fromJSON(doc)
    #### Cas où le code INSEE ne peut être déterminé ####
    if(is.null(dim(x$features)) == FALSE) {
      coord <- x$features[1,]$geometry$coordinates
      if ("citycode" %in% colnames(x$features$properties) == TRUE) {
        INSEE <- x$features[1,]$properties["citycode"]
      } else {INSEE <- "NA"}
      #### Récupération des résultats du .json ####
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
    else {return(data.frame(NA,NA,NA,NA,NA,NA,NA,NA))}}
  else {return(data.frame(NA,NA,NA,NA,NA,NA,NA,NA))}
}
```

###### Étape 3 : Restituer les résultats dans Modeler

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

![alt tag]()

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

###Installation

####R Packages :
######1 - Installer les packages suivant dans l'environnement 3.1 de R
- [Jsonlite](https://cran.r-project.org/web/packages/jsonlite/index.html)  
- [Bitops](https://cran.r-project.org/web/packages/bitops/index.html)  
- [RCurl](https://cran.r-project.org/web/packages/RCurl/index.html)  

######2- Installer le noeud directement dans modeler
Si vous êtes en version 17 installez le .cfd disponible [ici](https://raw.githubusercontent.com/downloads/VinceLYO/TEST/blob/master/GeocodageDataGouv.cfd)   
Si vous êtes en version 18 , installez la .mpe disponible [ici](https://github.com/VinceLYO/TEST/blob/master/Geocodage_DataGouv.mpe)  

