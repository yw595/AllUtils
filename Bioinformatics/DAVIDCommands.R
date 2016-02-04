library("RDAVIDWebService")

#data(demoList1)
#result = addList(david, demoList1, idType = "AFFYMETRIX_3PRIME_#IVT_ID", listName = "demoList1", listType = "Gene")

subDirs = c("analyzeAllMitoCartaT")
prefixes = c("lookSigEnsemblIDs","sigEnsemblIDs")

for (i in 1:length(subDirs))
{
    for (j in 1:3)
    {
	for (k in 1:2)
	{
	    count=1
	    david = DAVIDWebService$new("yw595@cornell.edu")
	    setEmail(david,"yw595@cornell.edu")
	    connect(david)
	    if (k==1)
	    {
	        backgroundFile = paste0(c("input/", subDirs[i], "/", prefixes[2], j, ".txt"), collapse="")
	    }
	    else
	    {
		backgroundFile = "input/All Mouse Entrez List.txt"
	    }
	    genesFile = paste0(c("input/", subDirs[i], "/", prefixes[k], j, ".txt"), collapse="")
	    outFile = paste0(c("input/", subDirs[i], "/", prefixes[k], j, "DAVIDout.csv"), collapse="")
	    if (file.exists(genesFile) && file.info(genesFile)[1,1]!=0)
	    {
	        background = read.table(backgroundFile)
		genes = read.table(genesFile)
		    #getIdTypes(david)
		    print("HERE")
		    result = addList(david, as.vector(background[,1]), idType = "ENSEMBL_GENE_ID", listName = paste0(c("background",count),collapse=""), listType = "Background")
		    print("THERE")
		    result = addList(david, as.vector(genes[,1]), idType = "ENSEMBL_GENE_ID", listName = paste0(c("genes",count), collapse=""), listType = "Gene")
		    print("WHERE")
		    if (length(getGeneListNames(david)) >= count && length(getBackgroundListNames(david)) >= (count+1))
		    {
		    setCurrentGeneListPosition(david,count)
		    print("SHERE")
		    setCurrentBackgroundPosition(david,count+1)

		    print(david)
		    print(getListName(david,listType="Background"))
		    print(getListName(david,listType="Gene"))
		    termCluster = getClusterReport(david, type="Term")
		    print(getListName(david,listType="Background"))
		    print(getListName(david,listType="Gene"))
		    annotationSummary = getAnnotationSummary(david)
		    print(getListName(david,listType="Background"))
		    print(getListName(david,listType="Gene"))
		    geneList = getGeneListReport(david)
		    print(getListName(david,listType="Background"))
		    print(getListName(david,listType="Gene"))
		    functionAnnotationChart = getFunctionalAnnotationChart(david)
		    print(getListName(david,listType="Background"))
		    print(getListName(david,listType="Gene"))
		    functionAnnotationTable = getFunctionalAnnotationTable(david)

		    write.table(stringr::str_replace_all(as.matrix(functionAnnotationChart),", ",";"), file=outFile, quote=FALSE, sep=",", row.names=FALSE)
		    count=count+1
		    }
	    }
	}
    }
}