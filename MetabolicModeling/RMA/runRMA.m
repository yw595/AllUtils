function [sortNormScores sortedMets sortedMetNames] = runRMA(sigEntrezIDs, sortPValsCol, origRecon2)
    rxnList = {};
    pValList = [];
    for j=1:length(origRecon2.rxns)
        [relevantGenes,intersectIdxs,~] = intersect(sigEntrezIDs, ...
            origRecon2.genes( origRecon2.rxnGeneMat(j,:)~=0 ));
        if ~isempty(relevantGenes)
            rxnList{end+1} = origRecon2.rxns{j};
            pValList(end+1) = mean(sortPValsCol(intersectIdxs));
        end
    end
    normScores = [];
    if ~isempty(pValList)
        normScores = reporterMets(origRecon2,pValList',1000,1,1,'median',rxnList',0);
    end
    [sortNormScores, sortIdxs] = sort(normScores);
    sortedMets = origRecon2.mets(sortIdxs);
    sortedMetNames = origRecon2.metNames(sortIdxs);
end