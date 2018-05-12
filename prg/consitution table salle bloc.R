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

for (i in lst_ville$nom_com) {
  tryCatch({
    gp <- google_places(key = APIkey,search_string = paste0("rock climbing ", i))
    temp <- data.frame(place_id = gp$results$place_id,
                       nom = gp$results$name,
                       adresse = gp$results$formatted_address,
                       lat = gp$results$geometry$location$lat,
                       lng = gp$results$geometry$location$lng,
                       types = sapply(gp$results$types,paste0,collapse = " "),
                       ville = i,
                       stringsAsFactors = F)
    result <- rbind(result, temp)
    }, error = function(e) {print(paste0(i," KO"))}, finally = print(i))
}

result.dedup <- result[!duplicated(result$place_id),]

head(result.dedup)

saveRDS(result.dedup,"./static/data/result_dedup.RDS")


