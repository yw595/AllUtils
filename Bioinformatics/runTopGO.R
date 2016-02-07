runTopGO <- function(background,backgroundPVals,interestingGenes,interestingGenesPVals,category,outputDir)
{
    library(topGO)
    library(gridExtra)

    names(backgroundPVals) = background
    names(interestingGenesPVals) = interestingGenes

    topDiffGenes <- function(pVals)
    {
        return (pVals < max(interestingGenesPVals))
    }

    testGOData = new("topGOdata", description = "test", ontology = category, allGenes = backgroundPVals, geneSel = topDiffGenes, nodeSize = 10, annot = annFUN.org, mapping = "org.Mm.eg.db",ID = "entrez")     
    testGOResult.classic = runTest(testGOData, algorithm = "classic", statistic = "fisher")
    testGOResult.elim = runTest(testGOData, algorithm = "elim", statistic = "fisher")
    testGOResult.weight = runTest(testGOData, algorithm = "weight", statistic = "fisher")
    testGOResult.weight01 = runTest(testGOData, algorithm = "weight01", statistic = "fisher")
    testGOResult.lea = runTest(testGOData, algorithm = "lea", statistic = "fisher")      
    testGOResult.parentchild = runTest(testGOData, algorithm = "parentchild", statistic = "fisher")

    png(paste0(outputDir,"/","histogram.png"))
    hist(score(testGOResult.weight01), 50, xlab = "pval")
    dev.off()

    minNumNodes = min(length(score(testGOResult.classic)), length(score(testGOResult.elim)), length(score(testGOResult.weight)), length(score(testGOResult.weight01)), length(score(testGOResult.lea)), length(score(testGOResult.parentchild)),50)
    allRes = GenTable(testGOData, classic = testGOResult.classic, elim = testGOResult.elim, weight = testGOResult.weight, weight01 = testGOResult.weight01, lea = testGOResult.lea, parentchild = testGOResult.parentchild, orderBy = "weight01", ranksOf = "weight01", topNodes = minNumNodes, numChar = 200)

    for (l in 1:minNumNodes)
    {
	topID = allRes[l, "GO.ID"]
	png(paste0(outputDir,"/","density", as.character(l), ".png"))
	print(showGroupDensity(testGOData, topID, ranks = TRUE, rm.one = FALSE))
	dev.off()
    }

    png(paste0(outputDir,"/","table.png"),height = 1200,width = 1500)
    grid.table(allRes)
    dev.off()
}
    