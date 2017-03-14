# library(rvest)
# #scraping_wiki <- read_html("https://en.wikipedia.org/wiki/Web_scraping")
# scraping_wiki %>%
#         html_nodes("h2") %>%
#         html_text()
# 
# p_nodes <- scraping_wiki %>%
#   html_nodes("p")
# length(p_nodes)
# p_nodes[1:6]
# 
# p_text <- scraping_wiki %>%
#   html_nodes("p") %>%
#   html_text()
# p_text[1]
# 
# ul_text <- scraping_wiki %>%
#         html_nodes("ul") %>%
#         html_text()
# length(ul_text)
# ul_text[1]
# substr(ul_text[2], start = 1, stop = 200)
# 
# 
# li_text <- scraping_wiki %>%
#         html_nodes("li") %>%
#         html_text()
# length(li_text)
# li_text[1:8]

library(rvest)
library(stringr)
library(htmltidy)
library(XML)
library(xml2)
library(httr)
library(purrr)


file <- "/files/proj/rodney/vc/index.html"
scraping_wiki <- read_html(file)
file_text <- readLines(file)
tidy_text <- tidy_html(file_text, list(TidyDocType="html5", TidyWrapLen=200))


# scraping_wiki %>%
#   html_nodes("*") %>%
#   html_attr("class") %>%
#   unique()

post_text <- scraping_wiki %>%
  html_nodes(".post-entry") %>%
  html_nodes("h2") %>%
  html_text()

length(post_text)
post_text[1:10]

grep("New", post_text, perl=TRUE, value=TRUE)
# str_match_all("New", post_text)
# post_text

