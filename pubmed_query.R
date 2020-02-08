library(httr)
library(tidyverse)
library(jsonlite)

source("pubmed_query_functions.R")

db <- 'pubmed';
#query <- 'asthma[mesh]+AND+leukotrienes[mesh]+AND+2009[pdat]';
query <- 'pfo+AND+("2019/01/01"[pdat]:"2020/01/01"[pdat])'
#assemble the esearch URL
base <- 'https://eutils.ncbi.nlm.nih.gov/entrez/eutils/';
url <- paste0(base,"esearch.fcgi?db=",db,"&term=",query, "&retmax=250")

test <- httr::GET(url = url)

#names(test)
cont <- content(test)
#test$content

# df <- fromJSON(cont) %>% 
#   data.frame()
cont_list <- xml2::as_list(cont)

ids <- cont_list$eSearchResult$IdList

ids <- unname(unlist(ids))

# url2 <- paste0(base,"epost.fcgi?db=",db, "&id=",paste(ids, collapse = ","))
# 
# summary <- httr::GET(url = url2)
# summary_cont <- content(summary)
# summary_cont_list <- xml2::as_list(summary_cont)


#url3 <- paste0(base,"esummary.fcgi?db=",db, "&query_key=",summary_cont_list$ePostResult$QueryKey,"&WebEnv=",
#summary_cont_list$ePostResult$WebEnv, "&version=2.0")

# url3 <- paste0(base,"esummary.fcgi?db=",db, "&id=",paste(ids, collapse = ","), "&version=2.0")
# 
# summary <- httr::GET(url = url3)
# 
# summary_cont <- content(summary)
# summary_cont_list <- xml2::as_list(summary_cont)
# summary_cont$doc
# tst <- xml2::as_xml_document(summary_cont)
# tst_result <- summary_cont_list$eSummaryResult
# tst_result$DocSum
# 
# tmp <- tst_result[[1]]




#=<database>&id=<uid_list>&rettype=<retrieval_type>
 # &retmode=<retrieval_mode>

  
  url3 <- paste0(base,"efetch.fcgi?db=",db, "&id=",paste(ids, collapse = ","), "&retmode=xml&retmax=250")

summary <- httr::GET(url = url3)

summary_cont <- content(summary)
summary_cont_list <- xml2::as_list(summary_cont)
# summary_cont$doc
# tst <- xml2::as_xml_document(summary_cont)
# tst_result <- summary_cont_list$eSummaryResult
# tmp <- tst$doc
# 
# tmp <- tst_result[[1]]
# 
# names(summary_cont_list[[1]])
# 
 names(summary_cont_list[[1]]) <- paste0(names(summary_cont_list[[1]]), 
                                               seq_along(summary_cont_list[[1]]))
# 
# summary_cont_list[[1]][[1]][[1]][[4]][[5]]
# 
# names(summary_cont_list[[1]][[1]][[1]][[4]])


article_list <- summary_cont_list[[1]]

article_list_tmp <- map(article_list, function(x){
  # tmp <- article_list[[x]]["MedlineCitation"]
  # names(tmp) <- names(article_list)[[x]] 
  # return(tmp)
  return(x[["MedlineCitation"]])
})



# tmp <- map(article_list_tmp[[1:2]], function(x){
#   get_date(x[["Article"]][["Journal"]][["JournalIssue"]][["PubDate"]])}
#   )
# get_journal(article_list$PubmedArticle1$MedlineCitation$Article$Journal)


tmp <- map_dfr(article_list_tmp[1:175], get_article)

# Article number 176 is a book. When only chosing MedlineCitation,
# all information is lost. This must be corrected!



# Reading -----------------------------------------------------------------


# https://www.ncbi.nlm.nih.gov/books/NBK25500/#chapter1.Searching_a_Database
# https://www.ncbi.nlm.nih.gov/books/NBK25499/#chapter4.EFetch


