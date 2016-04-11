# Géocodage d'adresses en France avec R et SPSS MODELER

###Desciption :
Ce nœud vous permettra de géocoder des adresses en France, en utilisant l'API de la Base Adresse Nationale, fruit de la collaboration de l'IGN / La Poste / Open street Map et les services de l'état : http://adresse.data.gouv.fr/api/

Aucune limite journalière, le nombre de requêtes est illimité.
### Esprit :
Aller récupérer les résultats rendus par l'url : http://api-adresse.data.gouv.fr/search/?q=MonAdresse
Étape 1 : 



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
    - housenumber : numéro "à la plaque"
    - street : position "à la voie", placé approximativement au centre de celle-ci
    - place : lieu-dit
    - village : numéro "à la commune" dans un village
    - city : numéro "à la commune" dans une grande ville
    - town : numéro "à la commune" dans une ville moyenne
    - town : numéro "à la commune" dans une ville moyenne
- Score_result : valeur de 0 à 1 indiquant la pertinence du résultat

![alt tag](https://raw.githubusercontent.com/VinceLYO/TEST/master/Capture_2.JPG)

###R Packages :
[Jsonlite](https://cran.r-project.org/web/packages/jsonlite/index.html)  
[Bitops](https://cran.r-project.org/web/packages/bitops/index.html)  
[RCurl](https://cran.r-project.org/web/packages/RCurl/index.html)  

#
