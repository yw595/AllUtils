library(topGO)
library(ALL)
data(ALL)
library(gridExtra)

timePoints = c(1,2,3)
tissueIdxs = c(1,2,3)
categories = c("BP","MF","CC")

inputDir = "variablesCorrAll"

for (i in 1:length(categories))
{
  for (k in 1:length(tissueIdxs))
  {
    for (j in 1:length(timePoints))
    {
      dir.create(paste0(
        inputDir,"/", as.character(k), "Time", as.character(j), categories[i]
      ))
      
      interestingGenes = read.table(
        paste0(
          inputDir,"/sigEntrezIDs", as.character(k), "Time", as.character(j), ".txt"
        )
      )
      background = read.table(
        paste0(
          inputDir,"/allEntrezIDs", as.character(k), "Time", as.character(j), ".txt"
        )
      )
      backgroundPVals = background[,2]
      names(backgroundPVals) = background[,1]
      interestingGenesPVals = interestingGenes[,2]
      names(interestingGenesPVals) = interestingGenes[,1]
      
      topDiffGenes <- function(pVals)
      {
        return (pVals < max(interestingGenesPVals))
      }
      
      testGOData = new(
        "topGOdata", description = "test", ontology = categories[i], allGenes = backgroundPVals, geneSel = topDiffGenes, nodeSize = 10, annot = annFUN.org, mapping =
          "org.Mm.eg.db",ID = "entrez"
      )
      print("HERE")
      
      testGOResult.classic = runTest(testGOData, algorithm = "classic", statistic =
                                       "fisher")
      testGOResult.elim = runTest(testGOData, algorithm = "elim", statistic =
                                    "fisher")
      testGOResult.weight = runTest(testGOData, algorithm = "weight", statistic =
                                      "fisher")
      testGOResult.weight01 = runTest(testGOData, algorithm = "weight01", statistic =
                                        "fisher")
      testGOResult.lea = runTest(testGOData, algorithm = "lea", statistic = "fisher")
      
      testGOResult.parentchild = runTest(testGOData, algorithm = "parentchild", statistic =
                                           "fisher")
      
      print("WHERE")
      
      png(
        paste0(
          inputDir,"/", as.character(k), "Time", as.character(j), categories[i], "/histogram.png"
        )
      )
      hist(score(testGOResult.weight01), 50, xlab = "pval")
      dev.off()
      
      minNumNodes = min(
        length(score(testGOResult.classic)), length(score(testGOResult.elim)), length(score(testGOResult.weight)), length(score(testGOResult.weight01)), length(score(testGOResult.lea)), length(score(testGOResult.parentchild)),50
      )
      allRes = GenTable(
        testGOData, classic = testGOResult.classic, elim = testGOResult.elim, weight = testGOResult.weight, weight01 = testGOResult.weight01, lea = testGOResult.lea, parentchild = testGOResult.parentchild, orderBy = "weight01", ranksOf = "weight01", topNodes = minNumNodes, numChar =
          200
      )
      
      if (j==1)
      {
        cumRes = allRes
      }
      else
      {
        matchIdxs1 = match(intersect( as.vector(cumRes[,"GO.ID"]),as.vector(allRes[,"GO.ID"]) ),cumRes[,"GO.ID"])
        matchIdxs2 = match(intersect( as.vector(cumRes[,"GO.ID"]),as.vector(allRes[,"GO.ID"]) ),allRes[,"GO.ID"])
        cumRes = cumRes[matchIdxs1,]
        cumRes[,(9*(j-1)+3):(9*(j-1)+11)] = allRes[matchIdxs2,3:11]
      }
      
      for (l in 1:minNumNodes)
      {
        topID = allRes[l, "GO.ID"]
        if (!(topID == "GO:0008150" ||
              topID == "GO:0003674" || topID == "GO:0005575"))
        {
          png(
            paste0(
              inputDir,"/", as.character(k), "Time", as.character(j), categories[i], "/density", as.character(l), ".png"
            )
          )
          print(showGroupDensity(
            testGOData, topID, ranks = TRUE, rm.one = FALSE
          ))
          dev.off()
        }
      }
      
      png(
        paste0(
          inputDir,"/", as.character(k), "Time", as.character(j), categories[i], "/table.png"
        ),height = 1200,width = 1500
      )
      grid.table(allRes)
      dev.off()
      if (j==3)
      {
        if (dim(cumRes)[2] != 0)
        {
          png(
            paste0(
              inputDir,"/", as.character(k), "Time", as.character(j), categories[i], "/tableCumRes.png"
            ),height = 1200,width = 4500
          )
          grid.table(cumRes)
          dev.off()
        }
      }
    }
  }
}