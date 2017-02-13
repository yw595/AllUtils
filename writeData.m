function writeData(dataFields,outputFile,delimiter,headers)

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
if exist('headers','var')
    %formatStringHeader = repmat('%f\t',1,length(headers));
    %formatStringHeader(end) = 'n';
    %formatStringHeader
    for i=1:length(headers)-1
        fprintf(FI,'%s\t',headers{i});
    end
    fprintf(FI,'%s\n',headers{end});
end
for i=1:size(dataCell,1)
    fprintf(FI,formatString,dataCell{i,:});
end
fclose(FI);

end