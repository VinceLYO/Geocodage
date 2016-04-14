# Géocodage d'adresses en France avec R et SPSS Modeler
<a href="url"><img src= "https://raw.githubusercontent.com/VinceLYO/Geocodage/master/Files/Rlogo.png" align="center" height="45" width="55" ></a>
<a href="url"><img src= "https://raw.githubusercontent.com/VinceLYO/Geocodage/master/Files/optima.gif" align="center" height="20" width="20" ></a>
<a href="url"><img src= "https://raw.githubusercontent.com/VinceLYO/Geocodage/master/Files/spss.png" align="center" height="40" width="120" ></a>  

###Desciption :
Ce nœud vous permettra de géocoder des adresses <b>en France</b>, en utilisant l'API de la Base Adresse Nationale, résultat de la collaboration de La Poste / L'IGN / Open Street Map et des services de l'état : http://adresse.data.gouv.fr/api/

<a href="url"><img src= "https://raw.githubusercontent.com/VinceLYO/Geocodage/master/Files/Logo-laposte.png" align="left" height="48" width="65" ></a>
<a href="url"><img src= "https://raw.githubusercontent.com/VinceLYO/Geocodage/master/Files/IGN_logo_2012.png" align="left" height="48" width="56" ></a>
<a href="url"><img src= "https://raw.githubusercontent.com/VinceLYO/Geocodage/master/Files/OSM.JPG" align="left" height="48" width="100" ></a>
<a href="url"><img src= "https://raw.githubusercontent.com/VinceLYO/Geocodage/master/Files/logo-de-la-republique-francaise.png" align="left" height="48" width="80" ></a>  
    :+1:    ```Aucune limite journalière, le nombre de requêtes est illimité```
    

![alt tag](https://raw.githubusercontent.com/VinceLYO/Geocodage/master/Files/Animation.gif)![alt tag](https://raw.githubusercontent.com/VinceLYO/Geocodage/master/Files/Animation_2.gif)


### Fonctionnement (Pour les curieux , pour les autres, c'est par [ici](#installation))

Récupération des résultats rendus par l'url : http://api-adresse.data.gouv.fr/search/?q=<b>Mon Adresse</b>  
    - Avant traitement : <b>Mon Adresse</b> = 17 rue de la Mairie 11300 Limoux  
    - Après traitement : <b>Mon Adresse</b> = 17%20rue%20de%20la%20Mairie%2011300%20Limoux  

###### Étape 1 : Transformation les adresses en requêtes url :

```R
    url <- function(address,return.call = "json") {
    library(RCurl)
    root <- "http://api-adresse.data.gouv.fr/search/"
    u <- paste(root, "?q=", address, sep = "")
    return(gsub(' ','%20',u))
    }
```

###### Étape 2 : Récupération des [résultats](http://api-adresse.data.gouv.fr/search/?q=17%20rue%20de%20la%20Mairie%2011300%20Limoux) sous format .json , puis mise en forme.

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

###### Étape 3 : Application de la fonction et restitution des résultats dans Modeler

```R
add <- modelerData$%%adresse%% #Chargement des données de l'indentificateur

results<-data.frame(matrix(NA,ncol = 8,nrow=length(add)))
for (i in 1:length(add)) {
  results[i,] <-  geoCode(add[i])
  print(i)
}

names(results) <- c("lat","long","INSEE","Adresse","CP","Ville","Type","Score")

modelerData<-cbind(modelerData,results$lat)
var1<-c(fieldName="Latitude_result",fieldLabel="",fieldStorage="string",fieldFormat="",fieldMeasure="",  fieldRole="")
modelerDataModel<-data.frame(modelerDataModel,var1)

modelerData<-cbind(modelerData,results$long)
var2<-c(fieldName="Longitude_result",fieldLabel="",fieldStorage="string",fieldFormat="",fieldMeasure="",  fieldRole="")
modelerDataModel<-data.frame(modelerDataModel,var2)
```
###Interface
Lecture du champ "Adresses" qui contient :
- Le numéro de voie
- La voie
- le Code Postal
- La ville  

Exemple : 17 rue de la Mairie 11300 Limoux

![alt tag](https://raw.githubusercontent.com/VinceLYO/TEST/master/Files/Capture_1.JPG)

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

![alt tag](https://raw.githubusercontent.com/VinceLYO/TEST/master/Files/Capture_2.JPG)

###Installation

- SPSS Modeler 17 ou plus
- IBM SPSS Modeler 'R Essentials' Plugin
- R 3.1 / R 3.2

#####R Packages :
######1 - Installer les packages suivant dans l'environnement 3.1 ou 3.2 de R
- [Jsonlite](https://cran.r-project.org/web/packages/jsonlite/index.html)  
- [Bitops](https://cran.r-project.org/web/packages/bitops/index.html)  
- [RCurl](https://cran.r-project.org/web/packages/RCurl/index.html)  

######2- Installer le noeud directement dans modeler
Si vous êtes en version 17/17.1 installez le <b>.cfd</b> disponible en téléchargement [ici](https://github.com/VinceLYO/TEST/blob/master/GeocodageDataGouv.cfd?raw=true)   
Si vous êtes en version 18 , installez le <b>.mpe</b> disponible en téléchargement [ici](https://github.com/VinceLYO/TEST/blob/master/Geocodage_DataGouv.mpe?raw=true)  
Code R brut disponible [ici](https://raw.githubusercontent.com/VinceLYO/Geocodage/master/R%20DataGouv%20MODELER.r)
