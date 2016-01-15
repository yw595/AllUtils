function rawMatrix = readVaryFile(inputFile, delimiter)

FI = fopen(inputFile);
line = fgetl(FI);
rawMatrix = {};
% count = 0;
% use ischar because for empty line, '' ~= -1 gives [], which is false
while ischar(line)
%     if line == -1
%         line = '';
%         count = count+1;
%         size(rawCAndHMatrix)
%     end
    if strcmp(line,'')
        for i=1:size(words,2)
            if i==1
                rawMatrix{end+1,i}='';
            else
                rawMatrix{end,i}='';
            end
        end
    else
        words = strsplit(line,delimiter);
        rawMatrix(end+1,1:length(words)) = words;
    end
    line = fgetl(FI);
end
fclose(FI);

end