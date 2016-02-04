function writeRMA (outputDir1, suffix, sigEntrezIDs, sortPValsCol)  
    writeData({sigEntrezIDs, sortPValsCol}, [outputDir1 'PVals' suffix '.txt']);
    
    fid = fopen([outputDir1 'Interaction' suffix '.txt'],'w');
    for j=1:length(origRecon2.mets)
        interactingRxns = origRecon2.rxns(origRecon2.S(j,:)~=0);
        for k=1:length(interactingRxns)
            fprintf(fid,'%s\t%s\t%s\n',origRecon2.mets{j},'mr',interactingRxns{k});
        end
    end
    fclose(fid);
    
    fid = fopen([outputDir1 'Association' suffix '.txt'],'w');
    for j=1:length(origRecon2.rxns)
        interactingGenes = origRecon2.genes( origRecon2.rxnGeneMat(j,:)~=0 );
        if length(interactingGenes) > 0
            fprintf(fid,'%s\t',origRecon2.rxns{j});
        else
            fprintf(fid,'%s\n',origRecon2.rxns{j});
        end
        for k=1:length(interactingGenes)-1
            fprintf(fid,'%s\t',interactingGenes{k});
        end
        if length(interactingGenes) > 0
            fprintf(fid,'%s\n',interactingGenes{end});
        end
    end
    fclose(fid);
end