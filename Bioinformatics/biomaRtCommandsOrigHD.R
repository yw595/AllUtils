library('affy')
library('gplots')
library('lattice')
library('biomaRt')

convertEnsemblToEntrez1 = function (ensemblListFile, ensemblToEntrezFile)
{
mitocarta = read.table(ensemblListFile)
ensemblHuman = useMart('ensembl', dataset='hsapiens_gene_ensembl')
ensemblMouse = useMart('ensembl', dataset='mmusculus_gene_ensembl')

mapmitocarta1 = getBM(attributes = c('ensembl_gene_id','hsapiens_homolog_ensembl_gene'), filters = c('ensembl_gene_id','with_homolog_hsap'), values = list( as.vector(mitocarta[,1]),TRUE ), mart = ensemblMouse)
mapmitocarta2 = getBM(attributes = c('ensembl_gene_id','entrezgene'), filters = c('ensembl_gene_id','with_entrezgene'), values = list( as.vector(mapmitocarta1[,2]),TRUE ), mart = ensemblHuman)

matchIdxs1 = match(intersect( as.vector(mapmitocarta1[,2]),as.vector(mapmitocarta2[,1]) ),mapmitocarta1[,2])
matchIdxs2 = match(intersect( as.vector(mapmitocarta1[,2]),as.vector(mapmitocarta2[,1]) ),mapmitocarta2[,1])

mapmitocarta3 = cbind(mapmitocarta1[matchIdxs1,1], mapmitocarta2[matchIdxs2,2])
write.table(mapmitocarta3, file=ensemblToEntrezFile, quote=FALSE, sep=",", row.names=FALSE)
}

convertEnsemblToEntrez2 = function (ensemblListFile, ensemblToEntrezFile, entrezFile)
{
mitocarta = read.table(ensemblListFile)
ensemblMouse = useMart('ensembl', dataset='mmusculus_gene_ensembl')

mapmitocarta = getBM(attributes = c('ensembl_gene_id','entrezgene'), filters = c('ensembl_gene_id','with_entrezgene'), values = list( as.vector(mitocarta[,1]),TRUE ), mart = ensemblMouse)

write.table(mapmitocarta, file=ensemblToEntrezFile, quote=FALSE, sep=",", row.names=FALSE)
write.table(mapmitocarta[,2], file=entrezFile, quote=FALSE, sep=",", row.names=FALSE, col.names=FALSE)
}

convertEnsemblToEntrez1("input/MitoCarta Mouse Ensembl List.txt","input/MitoCarta Mouse Ensembl To Human Entrez.csv")
convertEnsemblToEntrez1("input/MitoMiner Mouse Ensembl List.txt","input/MitoMiner Mouse Ensembl To Human Entrez.csv")
convertEnsemblToEntrez1("input/All Mouse Ensembl List.txt","input/All Mouse Ensembl To Human Entrez.csv")

convertEnsemblToEntrez2("input/MitoCarta Mouse Ensembl List.txt","input/MitoCarta Mouse Ensembl To Mouse Entrez.csv","input/MitoCarta Mouse Entrez List.txt")
convertEnsemblToEntrez2("input/All Mouse Ensembl List.txt","input/All Mouse Ensembl To Mouse Entrez.csv","input/All Mouse Entrez List.txt")