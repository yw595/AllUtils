function cutoff = FDRCutoff(sortPVals)

cutoff = find(sortPVals(:) > (1:length(sortPVals))'*.05/length(sortPVals),1);
if isempty(cutoff)
    cutoff=length(sortPVals);
end

end