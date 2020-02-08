# retrieval functions -----------------------------------------------------

get_pmid <- function(list_in){
  pmid <- list_in[["PMID"]][[1]]
  return(pmid)
  
}

# sometimes the date lists do not have the structure Year, Month, Day
# but something like one list with name "MedlineDate"
# --> what to do about it?

get_date <- function(list_in){
  year_chr <- list_in[["Year"]][[1]]
  month_chr <- list_in[["Month"]][[1]]
  day_chr <- list_in[["Day"]][[1]]
  # if there is no day or months the above returns null.
  # then the merge string should not contain an empty string.
  if(is.null(day_chr) & !is.null(month_chr)){
    merge <- paste(year_chr, month_chr, sep = "-")
  } else if(is.null(day_chr) & is.null(month_chr)){
    merge <- merge <- year_chr
  } else{
    merge <- paste(year_chr, month_chr, day_chr, sep = "-")
  }
  # if merge is null try to get data from MedlineDate list
  if(is.null(merge)){
    merge <- list_in[[1]][[1]]
  }
  # if still no entry return NA
  if(is.null(merge)){
    merge <- NA
  }
  return(merge)
}

get_journal <- function(list_in){
  journal_data <- data.frame()
  title <- ifelse(is.null(list_in[["Title"]][[1]]), NA, 
                  list_in[["Title"]][[1]])
  isoabb <- ifelse(is.null(list_in[["ISOAbbreviation"]][[1]]),
                   NA,
                   list_in[["ISOAbbreviation"]][[1]])
  
  volume = ifelse(is.null(list_in[["JournalIssue"]][["Volume"]][[1]]),
                  NA,
                  list_in[["JournalIssue"]][["Volume"]][[1]])
  issue = ifelse(is.null(list_in[["JournalIssue"]][["Issue"]][[1]]),
                 NA,
                 list_in[["JournalIssue"]][["Issue"]][[1]])
  
  pubdate = get_date(list_in[["JournalIssue"]][["PubDate"]])
  journal_data <- data.frame(title = title,
                             isoabb = isoabb,
                             volume = volume,
                             issue = issue,
                             pubdate = pubdate)
  return(journal_data)
}

# get one author
get_author <- function(list_in){
  lastname <- list_in[["LastName"]][[1]]
  initials <- list_in[["Initials"]][[1]]
  author <- paste0(paste(lastname, initials, sep = ", "),".")
  if(is.null(author)){author <- NA}
  return(author)
}

get_authors <- function(list_in){
  authors <- paste(map_chr(list_in, 
                get_author), collapse = ", ")
  return(ifelse(is.null(authors), NA, authors))
}

get_abstract <- function(list_in){
  attribute <- attr(list_in, "NlmCategory")
  data <- list_in[[1]]
  merge <- paste0(attribute, if(!is.null(attribute)){"\n"}, data)
  return(merge)
}

get_abstracts <- function(list_in){
  abstract_data <- map_chr(list_in, get_abstract)
  abstracts <- paste(abstract_data, collapse = "\n")
  return(abstracts)
}

get_pubtype<- function(list_in){
  #list_in[["PublicationType"]][[1]]
  pubtypes_chr <- map_chr(list_in, function(x){x[[1]]})
  
  pubtypes <- paste(pubtypes_chr, collapse ="; ")
  return(pubtypes)
}



get_article <- function(list_in){
  article_data <- list_in[["Article"]]
  journal_data <- get_journal(article_data[["Journal"]])
  article_dataframe <- data.frame(
    authors = get_authors(article_data[["AuthorList"]]),
    title = article_data[["ArticleTitle"]][[1]],
    pmid = get_pmid(list_in),
    journal = journal_data[["title"]],
    iso_name = journal_data[["isoabb"]],
    volume = journal_data["volume"],
    issue = journal_data["issue"],
    pages = ifelse(is.null(article_data[["Pagination"]][[1]][[1]]),NA, article_data[["Pagination"]][[1]][[1]]),
    pub_date = journal_data[["pubdate"]],
    abstract = get_abstracts(article_data[["Abstract"]]),
    pubtype = get_pubtype(article_data[["PublicationTypeList"]]),
    language = article_data[["Language"]][[1]],
    stringsAsFactors = FALSE
  )
  return(article_dataframe)
}
