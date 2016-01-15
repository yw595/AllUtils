function string = strjoin(words,delimiter)

string = '';
for i=1:length(words)-1
    string = [string words{i} sprintf(delimiter)];
end
string = [string words{end}];

end