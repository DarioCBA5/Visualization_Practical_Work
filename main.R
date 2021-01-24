
if (!file.exists(".//data//globalterrorismdb_0718dist.csv")){
  unzip(".//data//globalterrorismdb_0718dist.zip", exdir=".//data")
}


url <- "https://www.nationsonline.org/oneworld/country_code_list.htm"
iso_codes <- url %>%
  read_html() %>%
  html_nodes(xpath = '//*[@id="CountryCode"]') %>%
  html_table()
iso_codes <- iso_codes[[1]][, -1]
iso_codes <- iso_codes[!apply(iso_codes, 1, function(x){all(x == x[1])}), ]
names(iso_codes) <- c("Country", "ISO2", "ISO3", "UN")

world_data <- ggplot2::map_data('world')
world_data <- fortify(world_data)



crimes <- read.csv(file = 'data/globalterrorismdb_0718dist.csv',header=TRUE, sep=",", dec=".")

crimes <- crimes %>%
  select("eventid","iyear","imonth","iday","extended","resolution","country","country_txt","region_txt","latitude","longitude","weaptype1_txt","nkill","success")

mapping_countries <- read_excel('./utils/mapping_countries.xlsx')


old_names <- c("French Southern and Antarctic Lands", "Antigua", "Barbuda", "Saint Barthelemy", "Brunei", "Ivory Coast",
               "Democratic Republic of the Congo", "Republic of Congo", "Falkland Islands", "Micronesia", "UK", 
               "Heard Island", "Cocos Islands", "Iran", "Nevis", "Saint Kitts", "South Korea", "Laos", "Saint Martin",
               "Macedonia", "Pitcairn Islands", "North Korea", "Palestine", "Russia", "South Sandwich Islands",
               "South Georgia", "Syria", "Trinidad", "Tobago", "Taiwan", "Tanzania", "USA", "Vatican", "Grenadines",
               "Saint Vincent", "Venezuela", "Vietnam", "Wallis and Fortuna")
new_names <- c("French Southern Territories", rep("Antigua and Barbuda", 2), "Saint-Barthélemy",
               "Brunei Darussalam", "Côte d'Ivoire", "Congo, (Kinshasa)", "Congo (Brazzaville)", 
               "Falkland Islands (Malvinas)", "Micronesia, Federated States of", "United Kingdom",
               "Heard and Mcdonald Islands", "Cocos (Keeling) Islands", "Iran, Islamic Republic of",
               rep("Saint Kitts and Nevis", 2), "Korea (South)", "Lao PDR", "Saint-Martin (French part)",
               "Macedonia, Republic of", "Pitcairn", "Korea (North)", "Palestinian Territory", "Russian Federation",
               rep("South Georgia and the South Sandwich Islands", 2), 
               "Syrian Arab Republic (Syria)", rep("Trinidad and Tobago", 2), "Taiwan, Republic of China",
               "Tanzania, United Republic of", "United States of America", "Holy See (Vatican City State)",
               rep("Saint Vincent and Grenadines", 2), "Venezuela (Bolivarian Republic)", "Viet Nam", "Wallis and Futuna Islands")

for (i in 1:length(old_names)){
  world_data$region[world_data$region == old_names[i]] <- new_names[i]
}



crimes <- merge(crimes, mapping_countries[, c("country", "ISO3")], by="country", all.x=TRUE)
world_data["ISO3"] <- iso_codes$ISO3[match(world_data$region, iso_codes$Country)]

crimes["date"] <- as.Date(ISOdate(crimes[,"iyear"], crimes[,"imonth"], crimes[,"iday"]))
crimes["weekday"] <- weekdays(as.Date(crimes$date))
crimes["Weapon_Type"] <- crimes$weaptype1_txt
crimes$Weapon_Type[crimes$weaptype1_txt %in% c("Biological","Chemical","Fake Weapons","Melee","Other","Radiological","Sabotage Equipment","Unknown","Vehicle (not to include vehicle-borne explosives, i.e., car or truck bombs)")] <- "Other"
crimes$nkill[is.na(crimes$nkill)] <- 0