function cutoff = FDRCutoff(sortPVals)
% cutoff = 1;
% for index1=1:length(sortPVals)
%     if(sortPVals(index1)<=index1*.05/length(sortPVals))
%         cutoff=cutoff+1;
%     else
%         break;
%     end
% end

cutoff = find(sortPVals(:) > (1:length(sortPVals))'*.05/length(sortPVals),1);
if isempty(cutoff)
    cutoff=length(sortPVals);
end

end