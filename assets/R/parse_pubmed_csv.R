### Parse pubmed CSV into Markdown files suitable for publication section
library(data.table)
library(stringr)
library(plyr)

### Read in CSV downloaded from Pubmed query ("Send to" --> "File" --> "CSV")
website.home <- "~/projects/website/"
infile <- suppressWarnings(fread(input=list.files(path=paste0(website.home, "_data"), pattern="pubmed_result", full.names = TRUE)))
colnames(infile) <- as.character(.(Title,URL,Description,Details,ShortDetails,Resource,Type,Identifiers,Db,EntrezUID,Properties,cn))

## function to parse each record and spit out the appropriate data
parse.record <- function(rec){
  x <- list()
  x[["title"]] <- str_replace_all(rec$Title, pattern='[\\.|\\"]', replacement="")
  x[['url']] <- paste0("https://www.ncbi.nlm.nih.gov/", rec$URL)
  x[['authors']] <- dd$Description
  x[['citation']] <- dd$Details
  
  x[['journal']] <- str_trim(str_extract(string=rec$ShortDetail, 
                                         pattern='[A-Za-z|\\s\\.]*'))
  
  # this is ugly
  x[['pub.date']] <- paste0(unlist(
                     str_extract_all(dd$Properties, pattern='[[0-9]]+')
                     ),sep="", collapse="-")
  
  x[['authors.bold']] <- str_replace(x[['authors']], 
                                     pattern="Johnson KW", 
                                     replacement="<b>Johnson KW</b>")

  x[['title.bold']] <- paste0('<i>', x[['title']], '</i>')

  x[['pmid']] <- rec$EntrezUID
  
  return(x)
}

qs <- function(x){ # quote string function
 xx <- paste0('"', x, '"')
 return(xx)
}

make.markdown <- function(x){
  writeLines("---")
  writeLines(paste0("title: ", qs(x$title.bold)))
  writeLines("collection: publications")
  writeLines(paste0('permalink: /publications/', x$pmid))
  writeLines('excerpt: "" ' )
  writeLines(paste0("date: ", x$pub.date))
  writeLines(paste0("venue: ", qs(x$journal)))
  writeLines(paste0("paperurl: 'https://www.ncbi.nlm.nih.gov/pubmed/", x$pmid, "'"))
  writeLines(paste0("citation: ",
                    '"',
                    x$authors.bold,
                    " ",
                    x$citation,
                    " PubMed ID: ",
                    x$pmid,
                    '"'))
  writeLines("---")
  writeLines("")
  writeLines(paste0("[PubMed Link]", "(","https://www.ncbi.nlm.nih.gov/pubmed/",x$pmid,")"))
  writeLines("")
  writeLines(paste0("[Download PDF here]", "(https://kippjohnson.com/files/", x$pmid, ".pdf",")"))
  writeLines("")
}

print_markdown <- function(rec){
  x <- parse.record(rec)
  sink(paste0(website.home, "_publications/", x$pmid, ".md"))
  make.markdown(x)
  sink()
}

for(i in 1:nrow(infile)){ 
  dd <- infile[i,]
  print_markdown(dd)                                               
}





