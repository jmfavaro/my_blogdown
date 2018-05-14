library(googleway)
library(RPostgreSQL)

##============================================================================================
## parametres
##============================================================================================

APIkey <- "AIzaSyCImmKPiGDg7Wq-VjEV9IUKp620YnzqeDg"
#con <- dbConnect(PostgreSQL(), user= "postgres", password="postgres", dbname="am",  port=5436)
con <- dbConnect(PostgreSQL(), user= "postgres", password="postgres", dbname="am", host = "localhost",  port=5432)

lst_ville <- dbGetQuery(con,"select insee_com, nom_com from geo.geofla_commune_2015 where population > 5000;")

result <- data.frame(place_id = NULL, nom = NULL, adresse = NULL,
                     rating = NULL, lat = NULL, lng = NULL, tags = NULL, ville = NULL,
                     stringsAsFactors = F)
compteur <- 0
for (i in lst_ville$nom_com) {
  compteur <- compteur + 1
  tryCatch({
    gp <- google_places(key = APIkey,search_string = paste0("salle escalade bloc ", i, ", france"),language = "fr")
    temp <- data.frame(place_id = gp$results$place_id,
                       nom = gp$results$name,
                       adresse = gp$results$formatted_address,
                       lat = gp$results$geometry$location$lat,
                       lng = gp$results$geometry$location$lng,
                       types = sapply(gp$results$types,paste0,collapse = " "),
                       ville = i,
                       stringsAsFactors = F)
    result <- rbind(result, temp)
    }, error = function(e) {print(paste0(i," KO"))})
  print(paste(compteur,":",i))
}

result_dedup <- result[!duplicated(result$place_id),]

result_dedup <- readRDS("./static/data/result_dedup_2.RDS")

saveRDS(result_dedup_2,"./static/data/result_dedup_2.RDS")


