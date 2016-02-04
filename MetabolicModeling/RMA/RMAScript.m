function writeData(dataFields,filename)

dataCell = {};
for i=1:length(dataFields)
    if size(dataFields{i},2) > size(dataFields{i},1)
        dataFields{i} = dataFields{i}';
    end
    if iscell(dataFields{i})
        dataCell = 

end