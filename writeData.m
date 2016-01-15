function writeData(dataFields,outputFile,delimiter)

dataCell = cell(length(dataFields{1}),0);
formatString = '';
for i=1:length(dataFields)
    dataField = dataFields{i};
    if size(dataField,1) < size(dataField,2)
        dataField = dataField';
    end
    if iscell(dataField)
        formatString = [formatString '%s'];
    else
        if all(mod(dataField,1)==0)
            formatString = [formatString '%d'];
        else
            formatString = [formatString '%f'];
        end
        dataField = mat2cell(dataField,ones(length(dataField),1));
    end
    dataCell = [dataCell dataField];
    
    if i==length(dataFields)
        formatString = [formatString '\n'];
    else
        formatString = [formatString delimiter];
    end
end

FI = fopen(outputFile,'w');
for i=1:size(dataCell,1)
    fprintf(FI,formatString,dataCell{i,:});
end
fclose(FI);

end