function [filteredArr1 filteredArr2] = filterDoubleOutliers(origArr1,origArr2)

[~, sortIdxs1] = sort(origArr1);
[~, sortIdxs2] = sort(origArr2);

sortIdxs1 = sortIdxs1(floor(length(origArr1)/10):floor(9*length(origArr1)/10));
sortIdxs2 = sortIdxs2(floor(length(origArr1)/10):floor(9*length(origArr1)/10));

filteredArr1 = origArr1(intersect(sortIdxs1,sortIdxs2));
filteredArr2 = origArr2(intersect(sortIdxs1,sortIdxs2));

end