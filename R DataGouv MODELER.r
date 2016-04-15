t1 <- Sys.time()

add <- modelerData$%%adresse%%

#Transformation de l'url
url <- function(address,return.call = "json") {
  library(RCurl)
  root <- "http://api-adresse.data.gouv.fr/search/"
  u <- paste(root, "?q=", address, sep = "")
  return(gsub(' ','%20',u))
}
#Fonction de geocodage
geoCode <- function(address,verbose=FALSE) {
  library(jsonlite)
  if(verbose) cat(address,"\n")
  u <- url(address) #Transformation en url grace à la fonction url
  doc <- getURL(u) #Recuperation de l'url
  if (doc != "Missing query") {
    x <- fromJSON(doc)
    if(is.null(dim(x$features)) == FALSE) {
      coord <- x$features[1,]$geometry$coordinates
      if ("citycode" %in% colnames(x$features$properties) == TRUE) {
        INSEE <- x$features[1,]$properties["citycode"]
      } else {INSEE <- "NA"}
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
#Application de la fonction de geocodage à toute la base
results<-data.frame(matrix(NA,ncol= 8,nrow=length(add)))
for (i in 1:length(add)) {
  results[i,] <-  geoCode(add[i])
  print(i)
}

names(results) <- c("lat","long","INSEE","Adresse","CP","Ville","Type","Score")

#Creation des colonnes dans modeler
modelerData<-cbind(modelerData,results$lat)
var1<-c(fieldName="Latitude_result",fieldLabel="",fieldStorage="string",fieldFormat="",fieldMeasure="",  fieldRole="")
modelerDataModel<-data.frame(modelerDataModel,var1)

modelerData<-cbind(modelerData,results$long)
var2<-c(fieldName="Longitude_result",fieldLabel="",fieldStorage="string",fieldFormat="",fieldMeasure="",  fieldRole="")
modelerDataModel<-data.frame(modelerDataModel,var2)

modelerData<-cbind(modelerData,results$Adresse)
var3<-c(fieldName="Adresse_result",fieldLabel="",fieldStorage="string",fieldFormat="",fieldMeasure="",  fieldRole="")
modelerDataModel<-data.frame(modelerDataModel,var3)

modelerData<-cbind(modelerData,results$INSEE)
var4<-c(fieldName="INSEE_result",fieldLabel="",fieldStorage="string",fieldFormat="",fieldMeasure="",  fieldRole="")
modelerDataModel<-data.frame(modelerDataModel,var4)

modelerData<-cbind(modelerData,results$CP)
var5<-c(fieldName="CP_result",fieldLabel="",fieldStorage="string",fieldFormat="",fieldMeasure="",  fieldRole="")
modelerDataModel<-data.frame(modelerDataModel,var5)

modelerData<-cbind(modelerData,results$Ville)
var6<-c(fieldName="Ville_result",fieldLabel="",fieldStorage="string",fieldFormat="",fieldMeasure="",  fieldRole="")
modelerDataModel<-data.frame(modelerDataModel,var6)

modelerData<-cbind(modelerData,results$Type)
var7<-c(fieldName="Type_result",fieldLabel="",fieldStorage="string",fieldFormat="",fieldMeasure="",  fieldRole="")
modelerDataModel<-data.frame(modelerDataModel,var7)

modelerData<-cbind(modelerData,results$Score)
var8<-c(fieldName="Score_result",fieldLabel="",fieldStorage="real",fieldFormat="",fieldMeasure="",  fieldRole="")
modelerDataModel<-data.frame(modelerDataModel,var8)

t2 <- Sys.time()
print(difftime(t2,t1))
