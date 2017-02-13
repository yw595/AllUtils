function writeOutModel(model,outputFile,fluxes,frequentMetsFile)

KEGGmets = model.mets;
KEGGmets = cellfun(@(x) strrep(x,'cpd','C'),KEGGmets,'UniformOutput',0);
for i=1:length(KEGGmets)
    braceIdx = regexp(KEGGmets{i},'[');
    currKEGGmet = KEGGmets{i};
    if ~isempty(braceIdx)
        KEGGmets{i} = currKEGGmet(1:braceIdx-1);
    end
end
metField = {}; stoichField = []; rxnField = {}; subSystemField = {}; KEGGField = {}; longMetField = {}; longRxnField = {}; fluxField = [];
for i=1:length(model.rxns)
    metIdxs = find(model.S(:,i));
    for j=1:length(metIdxs)
        rxnField{end+1} = model.rxns{i};
        stoichField(end+1) = full(model.S(metIdxs(j),i));
        metField{end+1} = model.mets{metIdxs(j)};
        subSystemField{end+1} = model.subSystems{i};
        KEGGField{end+1} = KEGGmets{metIdxs(j)};
        if exist('fluxes','var')
            fluxField(end+1) = fluxes(i);
        end
    end
end
writeoutData = {rxnField,stoichField,metField,subSystemField,KEGGField};
if exist('fluxes','var')
    writeoutData{end+1} = fluxField;
end
writeData(writeoutData,outputFile,'\t');

if exist('frequentMetsFile','var')
[~, topMetIdxs] = sort(sum(abs(model.S)~=0,2),'descend');
topMetIdxs = topMetIdxs(1:floor(length(topMetIdxs)*.001));
topMetIdxs
writeData({model.mets(topMetIdxs)},frequentMetsFile,'\t');
end
end