function [geneIDs, pVals1, pVals2, expressionData] = mapGeneIDs(mapFile, geneIDs, reverse, varargin)

p = inputParser;
p.addParamValue('pVals1',[]);
p.addParamValue('pVals2',[]);
p.addParamValue('expressionData',[]);
p.parse(varargin{:});
pVals1 = p.Results.pVals1; pVals2 = p.Results.pVals2; expressionData = p.Results.expressionData;

FI = fopen(mapFile);
dataFields = textscan(FI,'%s%s','Delimiter',',','HeaderLines',1);
fclose(FI); 

mapIdxs = ~strcmp(dataFields{2},'');
dataFields{1} = dataFields{1}(mapIdxs); 
dataFields{2} = dataFields{2}(mapIdxs);
if reverse
    temp = dataFields{2};
    dataFields{2} = dataFields{1};
    dataFields{1} = temp;
end
[~,intersectIdxs1,intersectIdxs2] = intersect(geneIDs, dataFields{1});
geneIDs = dataFields{2}(intersectIdxs2); 

if ~isempty(pVals2)
    pVals2 = pVals2(intersectIdxs1);
end
if ~isempty(pVals1)
    pVals1 = pVals1(intersectIdxs1);
end
if ~isempty(expressionData)
    expressionData = expressionData(intersectIdxs1,:);
end

end