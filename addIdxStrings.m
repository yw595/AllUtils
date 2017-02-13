function newStrings = addIdxStrings(oldStrings)

numDigits = floor(log10(length(oldStrings)))+1;
newStrings = oldStrings;
for i=1:length(oldStrings)
    ithIdx = num2str(i);
    while length(ithIdx) < numDigits
        ithIdx = ['0' ithIdx];
    end
    newStrings{i} = [ithIdx '_' oldStrings{i}];
end