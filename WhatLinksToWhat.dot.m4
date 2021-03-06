digraph G {
rankdir=LR
concentrate=true

/*
I'm bad at colors, someone should figure out a better scheme:
http://www.graphviz.org/doc/info/colors.html
http://colorbrewer2.org/ helps a lot
*/


// http://stackoverflow.com/questions/14662092/does-the-dot-language-support-variables-aliases
// You can fill in the colors for the nodes here.  The bash script will take care of the rest
define(`industrial_classifications_style',`fillcolor = "#d73027", style=filled')
define(`product_classificiations_style',`fillcolor = "#f46d43", style=filled')
define(`lca_data_style',`fillcolor = "#fdae61", style=filled')
define(`facility_level_data_style',`fillcolor = "#fee090", style=filled')
define(`is_case_studies_style',`fillcolor = "#e0f3f8", style=filled')
define(`geo_data_style',`fillcolor = "#abd9e9", style=filled')
define(`io_data_style',`fillcolor = "#74add1", style=filled')
define(`waste_classification_style',`fillcolor = "#4575b4", style=filled')

/****** Define all the Types of Nodes and their colors here ******/ 


/*** Industrial Classifications **/
node [industrial_classifications_style]
NACE
ISIC
NAICS
ANZSIC
"Categories.xml"
IPPC
SIC
SNAP97
"NACE/CLIO"
JSIC /* Japanese Standard Industrial Classification */


/*** Product or Flow Classifications **/
node [product_classificiations_style]
BEC
BTN
CAS
CCT
CN
COICOP
CPA
CPC
EBOPS
HS
LALL
NAPCS /** https://en.wikipedia.org/wiki/North_American_Product_Classification_System **/
NHM
NIMEXE
NIPRO
NST
"NST/R"
PRODCOM
SITC


node [waste_classification_style]
EWC
LOW


node [geo_data_style]
NUTS
WGS84


node [io_data_style]
"Domestic IO"
"International IO"


node [lca_data_style]
EcoInvent
USDA
CPM
NREL
ELCD
NEEDS


node [facility_level_data_style]
"E-PRTR"
LCPD
"National Business Registries"
TRI


node [is_case_studies_style]
"Global Synergy Database"
"ie.tudelft.nl"
"NISP Case Studies"
"ISDATA open material synergy DB"
"International Survey on Eco-Industrial Parks"


/** Default color for everything else **/
node [style=filled, fillcolor=white]

/****** Define all the types of edges (connections here) ******/ 
/** Concordances between classification systems **/
NACE -> ISIC [dir="both"]
NAICS -> ISIC [dir="both"]
NACE -> NAICS [dir="both"]
CPA -> NACE [dir="both"]  /** TODO where does this occur? **/
EWC -> LOW [dir="both"]
EWC -> NACE [dir="both"]
LOW -> NACE [dir="both"]  /** TODO where does this occur? **/
ANZSIC -> ISIC [dir="both"]
NAICS -> NAPCS [dir="both"]
/** LCA Data Sets **/
ISIC -> EcoInvent 
CAS -> EcoInvent 
USDA -> ISIC
"Categories.xml" -> NREL 
"Categories.xml" -> NEEDS 
/** Other Data Sets **/
SIC -> TRI 
NAICS -> TRI 
/*
TRI -> "Pollution Prevention Activity Codes"
*/
TRI -> WGS84
"E-PRTR" -> WGS84
NACE -> "E-PRTR" 
NUTS -> "E-PRTR" 
IPPC -> "E-PRTR" 
"NUTS" -> WGS84
"ISDATA open material synergy DB" -> NACE
"ISDATA open material synergy DB" -> EWC	
/* 
CPA -> "SE IO" 
NACE -> "SE IO" 
*/
NACE -> "Domestic IO" 
NACE -> "International IO" 
NACE -> "National Business Registries" 
"National Business Registries" -> WGS84
/*
"National Business Registries" -> "Economic Data"
*/
/*
NACE -> "Eurostat" 
"Eurostat" -> "Economic Data"
"Eurostat" -> "Social Data"
*/
/*
LCPD -> "Heat Output"
*/
"Domestic IO" -> "International IO"
/*
"Domestic IO" -> "SE IO"
*/
"International Survey on Eco-Industrial Parks" -> WGS84
"ie.tudelft.nl" -> WGS84

BEC -> CN
BEC -> SITC
BEC -> HS
BTN -> SITC
CCT -> NIMEXE
NIMEXE -> SITC
CCT -> SITC
CN -> CPA
CN -> "NST/R"
CN -> PRODCOM
CN -> SITC
CN -> HS
CN -> NIMEXE
CN -> NST
COICOP -> CPC
COICOP -> CPA
CPA -> CPC
CPA -> NST
CPA -> EBOPS
CPA -> HS
CPC -> HS
CPC -> ISIC
CPC -> PRODCOM
EBOPS -> CPA
EBOPS -> CPC
EWC -> LOW
HS -> SIC
HS -> SITC
HS -> PRODCOM
ISIC -> NACE
ISIC -> CPC
ISIC -> SITC
ISIC -> NAICS
JSIC -> NACE /* Japanese Standard Industrial Classification */
LALL -> SITC
NACE -> "NACE/CLIO"
NACE -> NAICS
NHM -> NST
NIMEXE -> "NACE/CLIO"
NIMEXE -> NIPRO
NIMEXE -> CN
SNAP97 -> NACE
SIC -> ISIC
SIC -> NACE

/* HS -> "Product Complexity Index - Observatory of Economic Complexity" */

// CD: Don't know how to move this to the top right corner

subgraph cluster_legend { 
    label = "Legend";
	"Industrial Classifications" [industrial_classifications_style]
	"Product/Flow Classifications" [product_classificiations_style]
	"LCA Databases" [lca_data_style] 
	"Facility-level Data" [facility_level_data_style]
	"IS Case Studies" [is_case_studies_style]
	"Geo Data" [geo_data_style]
	"Waste Classification" [waste_classification_style]
  }


/*
Don't know where to put this yet:

Very detailed overview of concordances
http://ec.europa.eu/eurostat/ramon/relations/index.cfm?TargetUrl=LST_REL

classification = detailed categorization/structure to a group of things/artiacts
correlation = linking synonyms between classification data
multi-attribute = linking seperate data types (groups of artifacts??) to other seperate data types
I guess we could classify the data types
economic/MFA/industrial geography

http://scb.se/en_/Finding-statistics/Statistics-by-subject-area/Business-activities/

*/
}


