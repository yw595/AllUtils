library('affy')
library('gplots')
library('lattice')
library('biomaRt')

mapMouseEnsemblToHumanEntrez <- function (ensemblFile, mapFile,ensemblHuman,ensemblMouse)
{
    ensemblList = read.table(ensemblFile)

    map1 = getBM(attributes = c('ensembl_gene_id','hsapiens_homolog_ensembl_gene'), filters = c('ensembl_gene_id','with_homolog_hsap'), values = list( as.vector(ensemblList[,1]),TRUE ), mart = ensemblMouse)
    map2 = getBM(attributes = c('ensembl_gene_id','entrezgene'), filters = c('ensembl_gene_id','with_entrezgene'), values = list( as.vector(map1[,2]),TRUE ), mart = ensemblHuman)

    matchIdxs1 = match(intersect( as.vector(map1[,2]),as.vector(map2[,1]) ),map1[,2])
    matchIdxs2 = match(intersect( as.vector(map1[,2]),as.vector(map2[,1]) ),map2[,1])

    map3 = cbind(map1[matchIdxs1,1], map2[matchIdxs2,2])
    write.table(map3, file=mapFile, quote=FALSE, sep=",", row.names=FALSE)
}

mapMouseEnsemblToMouseEntrez <- function (ensemblFile, mapFile, martObj)
{
    ensemblList = read.table(ensemblFile)

    map = getBM(attributes = c('ensembl_gene_id','entrezgene'), filters = c('ensembl_gene_id','with_entrezgene'), values = list( as.vector(ensemblList[,1]),TRUE ), mart = martObj)

    write.table(map, file=mapFile, quote=FALSE, sep=",", row.names=FALSE)
}

ensemblHuman = useMart('ensembl', dataset='hsapiens_gene_ensembl')
ensemblMouse = useMart('ensembl', dataset='mmusculus_gene_ensembl')
mapMouseEnsemblToHumanEntrez("input/MitoCarta Mouse Ensembl List.txt","input/MitoCarta Mouse Ensembl To Human Entrez.csv",ensemblHuman,ensemblMouse)
mapMouseEnsemblToHumanEntrez("input/MitoMiner Mouse Ensembl List.txt","input/MitoMiner Mouse Ensembl To Human Entrez.csv",ensemblHuman,ensemblMouse)
mapMouseEnsemblToHumanEntrez("input/All Mouse Ensembl List.txt","input/All Mouse Ensembl To Human Entrez.csv",ensemblHuman,ensemblMouse)

ensemblMouse = useMart('ensembl', dataset='mmusculus_gene_ensembl')
mapMouseEnsemblToMouseEntrez("input/MitoCarta Mouse Ensembl List.txt","input/MitoCarta Mouse Ensembl To Mouse Entrez.csv",ensemblMouse)
mapMouseEnsemblToMouseEntrez("input/All Mouse Ensembl List.txt","input/All Mouse Ensembl To Mouse Entrez.csv",ensemblMouse)