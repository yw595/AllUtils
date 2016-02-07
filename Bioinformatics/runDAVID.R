runDAVID <- function(backgroundFile, genesFile, outFile)
{
    library("RDAVIDWebService")

    david = DAVIDWebService$new("yw595@cornell.edu")
    setEmail(david,"yw595@cornell.edu")
    connect(david)

    background = read.table(backgroundFile)
    genes = read.table(genesFile)
    result = addList(david, as.vector(background[,1]), idType = "ENSEMBL_GENE_ID", listName = "background", listType = "Background")
    result = addList(david, as.vector(genes[,1]), idType = "ENSEMBL_GENE_ID", listName = "genes", listType = "Gene")

    termCluster = getClusterReport(david, type="Term")
    annotationSummary = getAnnotationSummary(david)
    geneList = getGeneListReport(david)
    functionAnnotationChart = getFunctionalAnnotationChart(david)
    functionAnnotationTable = getFunctionalAnnotationTable(david)

    write.table(stringr::str_replace_all(as.matrix(functionAnnotationChart),", ",";"), file=outFile, quote=FALSE, sep=",", row.names=FALSE)
}