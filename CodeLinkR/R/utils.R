add_skos_inScheme <- function(ontStore, subject, object){
  add.triple(ontStore,
             subject = subject,
             predicate = "http://www.w3.org/2004/02/skos/core#inScheme",
             object = object)
}

add_skos_narrower <- function(ontStore, subject, object){
  add.triple(ontStore,
             subject=subject,
             predicate = "http://www.w3.org/2004/02/skos/core#narrower",
             object = object)
}

add_skos_broader <- function(ontStore, subject, object){
  add.triple(ontStore,
             subject=subject,
             predicate = "http://www.w3.org/2004/02/skos/core#broader",
             object = object)
}

add_skos_example <- function(ontStore, subject, exampleText){
  add.data.triple(ontStore,
             subject=subject,
             predicate = "http://www.w3.org/2004/02/skos/core#example",
             data = exampleText)
}


add_skos_concept_scheme <- function(ontStore, schemeID){
  add.triple(ontStore,
             subject = schemeID,
             predicate = "http://www.w3.org/1999/02/22-rdf-syntax-ns#type",
             object = "http://www.w3.org/2004/02/skos/core#ConceptScheme")
}

# this takes care of writing to both RDF and to neo4j
add_skos_concept_node <- function(ontStore, conceptId,
                                  notation="", description="", prefLabel="", altLabel="", example="", scopeNote=""){
  add.triple(ontStore,
             subject=conceptId,
             predicate = "http://www.w3.org/1999/02/22-rdf-syntax-ns#type",
             object = "http://www.w3.org/2004/02/skos/core#Concept")

  if (notation != ""){
    add.data.triple(ontStore,
                    subject=conceptId,
                    predicate = "http://www.w3.org/2004/02/skos/core#notation",
                    data = notation)
  }

  if (prefLabel != ""){
    add.data.triple(ontStore,
                    subject=conceptId,
                    predicate = "http://www.w3.org/2004/02/skos/core#prefLabel",
                    data = prefLabel)
  }

  if (description != ""){
    add.data.triple(ontStore,
                    subject=conceptId,
                    predicate = "http://www.w3.org/2004/02/skos/core#description",
                    data = description)
  }

  if (altLabel != ""){
    add.data.triple(ontStore,
                    subject=conceptId,
                    predicate = "http://www.w3.org/2004/02/skos/core#altLabel",
                    data = altLabel)
  }

  if (example != "" & example != " "){
    add.data.triple(ontStore,
                    subject=conceptId,
                    predicate = "http://www.w3.org/2004/02/skos/core#example",
                    data = example)
  }

  if (scopeNote != ""){
    add.data.triple(ontStore,
                    subject=conceptId,
                    predicate = "http://www.w3.org/2004/02/skos/core#scopeNote",
                    data = scopeNote)
  }
}

trim <- function(text){
  nonBreakingWhiteSpace <- '\xc2\xa0'
  text = gsub("[ |\n]*$", "", text)
  text = gsub("^ +| +$", "", text)
  text = gsub(nonBreakingWhiteSpace, '_', text)
  return(text)
}

determine_skos_linking_predicate <- function(codes1, codes2, index){
  numCode1 = length(which(codes1 == codes1[index]))
  numCode2 = length(which(codes2 == codes2[index]))

  # default predicate for when we don't know what we're looking at
  linkingPredicate_code1_code2 = "http://www.w3.org/2004/02/skos/core#relatedMatch"
  linkingPredicate_code2_code1 = "http://www.w3.org/2004/02/skos/core#relatedMatch"

  if (numCode1 == numCode2){ # 1:1 mapping
    linkingPredicate_code1_code2 = "http://www.w3.org/2004/02/skos/core#exactMatch"
    linkingPredicate_code2_code1 = "http://www.w3.org/2004/02/skos/core#exactMatch"
  } else if (numCode1 == 1 & numCode2 > 1){ # 2nd code must point to multiple codes in codes1
    linkingPredicate_code1_code2 = "http://www.w3.org/2004/02/skos/core#broadMatch"
    linkingPredicate_code2_code1 = "http://www.w3.org/2004/02/skos/core#narrowMatch"
  } else if (numCode1 > 1 & numCode2 == 1){ # 1st code must point to multiple codes in codes2
    linkingPredicate_code1_code2 = "http://www.w3.org/2004/02/skos/core#narrowMatch"
    linkingPredicate_code2_code1 = "http://www.w3.org/2004/02/skos/core#broadMatch"
  } # otherwise there's some sort of overlap between the codes - many to many mapping

  return(c(linkingPredicate_code1_code2, linkingPredicate_code2_code1))
}

write_Code1_to_Code2_to_RDF <- function(ws, versionsAbbrev, classification1, classification2, turtlePath){
  baseURL1 = paste0("http://isdata.org/Classifications/",classification1, "/")
  baseURL2 = paste0("http://isdata.org/Classifications/",classification2, "/")

  ontStore = initialize_New_OntStore()

  for (i in c(1:nrow(ws))){
    if (ws$Code1[i] != 0){
      url1 = trim(paste0(baseURL1, ws$Code1[i]))
      url2 = trim(paste0(baseURL2, ws$Code2[i]))

      linkingPredicates = determine_skos_linking_predicate(ws$Code1, ws$Code2, i)

      add.triple(ontStore,
                 subject=url1,
                 predicate = linkingPredicates[1],
                 object = url2)

      add.triple(ontStore,
                 subject=url2,
                 predicate = linkingPredicates[2],
                 object = url1)
    }
  }
  save.rdf(ontStore, paste0(turtlePath, "/", versionsAbbrev, ".turtle"), format="TURTLE")
}
