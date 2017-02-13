function words = strsplitYiping(line,delimiter)

beginIdxs = regexp(line,sprintf(delimiter));
if isempty(beginIdxs)
    words = {line};
else
words{1} = line(1:beginIdxs(1)-1);
words(2:length(beginIdxs)) = ...
    arrayfun(@(x) line(beginIdxs(x)+length(delimiter):beginIdxs(x+1)-1), 1:length(beginIdxs)-1,'UniformOutput',0);
words{end+1} = line(beginIdxs(end)+length(delimiter):end);
end

end