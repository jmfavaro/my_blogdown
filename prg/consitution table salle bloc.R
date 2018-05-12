library(googleway)

##============================================================================================
## parametres
##============================================================================================

APIkey <- "AIzaSyCImmKPiGDg7Wq-VjEV9IUKp620YnzqeDg"
#con <- dbConnect(PostgreSQL(), user= "postgres", password="postgres", dbname="am",  port=5436)
con <- dbConnect(PostgreSQL(), user= "postgres", password="postgres", dbname="am",  port=5434)

#------ BEGIN(les fonctions)
# appel 1ere fois
search_cc <- function(index) {
  temp <- google_places(location = c(mbc[index,]$y_centre_mbc,mbc[index,]$x_centre_mbc),
                        place_type = "shopping_mall",
                        #keyword = "centre%20commercial",
                        radius = c(mbc[index,"r_google"]),
                        key = APIkey)
  return(temp)
}

temp <- google_places(key = APIkey,
                      location = c(-2.349014, 48.864716),
                      place_type = "shopping_mall",
                      radius = 2000,
                      keyword = "carrefour"
 )

temp <- google_places(key = APIkey,search_string = "rock climbing bordeaux"
)
  temp$results$formatted_address
  temp$results$place_id

temp2 <- google_place_details(place_id = temp$results$place_id,simplify = TRUE, key = APIkey)

temp <- google_places(location = c(mbc[index,]$y_centre_mbc,mbc[index,]$x_centre_mbc),
                      place_type = "shopping_mall",
                      #keyword = "centre%20commercial",
                      radius = c(mbc[index,"r_google"]),
                      key = APIkey)

