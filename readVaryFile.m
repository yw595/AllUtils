function rawMatrix = readVaryFile(inputFile, delimiter)

FI = fopen(inputFile);
line = fgetl(FI);
rawMatrix = {};
% count = 0;
% use ischar because for empty line, '' ~= -1 gives [], which is false
while ischar(line)
    if strcmp(line,'')
        for i=1:size(words,2)
            if i==1
                rawMatrix{end+1,i}='';
            else
                rawMatrix{end,i}='';
            end
        end
    else
        if exist('delimiter','var')
            words = strsplitYiping(line,delimiter);
        else
            words = {line};
        end
        rawMatrix(end+1,1:length(words)) = words;
    end
    line = fgetl(FI);
end
fclose(FI);

end