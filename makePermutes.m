function nextPermute = makePermutes(arrayLengths, currentPermute)
    nextPermute = currentPermute;
    for i=length(nextPermute):-1:1
        if nextPermute(i)==arrayLengths(i)
            if length(arrayLengths)==1
                nextPermute = -1; 
                return;
            else
                nextPermute(i) = 1;
                nextPermute(1:i-1) = makePermutes(arrayLengths(1:i-1), nextPermute(1:i-1));
                if nextPermute(1)==-1
                    nextPermute = -1;
                    return;
                end
            end
        else
            nextPermute(i) = nextPermute(i)+1;
            return;
        end
    end
end