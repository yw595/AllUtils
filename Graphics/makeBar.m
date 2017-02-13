function makeBar(xvals,yvals,titleString,outputDir,varargin)
    
    p = inputParser;
    p.addParamValue('ylabelString',[]);
    p.addParamValue('xlabelString',[]);
    p.addParamValue('isBoxPlot',0);
    p.addParamValue('isScatter',0);
    p.addParamValue('isStackBar',0);
    p.addParamValue('legendLabels',{});
    p.addParamValue('errorBars',[])
    p.addParamValue('xlabels',{});
    p.addParamValue('labels',{});
    p.addParamValue('specialVals',{});
    p.addParamValue('indLines',[]);
    p.addParamValue('addlsline',0);
    p.addParamValue('xlabelsFontSize',10);
    p.addParamValue('specialValsFontSize',10);
    p.addParamValue('labelsFontSize',20);
    p.addParamValue('ylabelFontSize',20);
    p.addParamValue('xlabelFontSize',20)
    p.addParamValue('titleFontSize',20);
    p.parse(varargin{:});
    ylabelString=p.Results.ylabelString;xlabelString=p.Results.xlabelString;isBoxPlot=p.Results.isBoxPlot;isScatter=p.Results.isScatter;isStackBar=p.Results.isStackBar;legendLabels=p.Results.legendLabels;errorBars=p.Results.errorBars;xlabels=p.Results.xlabels;labels=p.Results.labels;specialVals=p.Results.specialVals;indLines=p.Results.indLines;addlsline=p.Results.addlsline;xlabelsFontSize=p.Results.xlabelsFontSize;specialValsFontSize=p.Results.specialValsFontSize;labelsFontSize=p.Results.labelsFontSize;ylabelFontSize=p.Results.ylabelFontSize;xlabelFontSize=p.Results.xlabelFontSize;titleFontSize=p.Results.titleFontSize;

    origTitleString = titleString;
    stringVars = {'titleString','ylabelString','xlabelString','xlabels','labels','specialVals'};

    for i=1:length(stringVars)
        tempVar = eval(stringVars{i});
        if ~isempty(tempVar)
            if iscell(tempVar)
                tempVar = cellfun(@(x) strrep(x,'_','\_'), tempVar,'UniformOutput',0);
            elseif isa(tempVar,'containers.Map')
                tempKeys = keys(tempVar);
                for j=1:length(tempKeys)
                    tempVar(tempKeys{j}) = strrep(tempVar(tempKeys{j}),'_','\_');
                end    
            else
                tempVar = strrep(tempVar,'_','\_')
            end
        end
        clear eval;
        eval([stringVars{i} ' = tempVar;']);
    end
        
    figure('Visible','off');
    % multiply by three to give some space between labels
    %INSIDIOUS BUG, here and below, default xlim generates some
    %sort of overhang, appears constant wrt paper size, so could
    %really squeeze data columns, also appears bigger at right, add
    %one to length(xvals) here to compensate for tight xlim below
    width=(length(xvals)+1)*xlabelsFontSize/72*3;
    if strcmp(titleString,'Complex_Diff_Coverage')
        width=(length(xvals)+1)*xlabelFontSize/72*30;
    end
    % CURIOUS BUG: width greater than 42 will make a totally blank figure
    if width>42
        width=41;
    end
    height = 8.5;
    maxSpecialValLen = 0; maxXLabelLen = 0;
    if ~isempty(xlabels) || ~isempty(specialVals)
        if ~isempty(specialVals)
            maxSpecialValLen = max(cellfun(@(x) length(x),values(specialVals)));
            height = height+max(maxSpecialValLen*specialValsFontSize/72*19/26-8.5,0);
        end
        if ~isempty(xlabels)
            set(gca,'XTickLabel',{});
            maxXLabelLen = max(cellfun(@(x) length(x),xlabels));
            height = height+maxXLabelLen*xlabelFontSize/72*19/26;
        end
    end
    if ~isempty(labels)
        uniqLabels = {};
        for j=1:length(labels)
            if ~any(strcmp(labels{j},uniqLabels))
                uniqLabels{end+1}=labels{j};
            end
        end
        
        for j=1:length(uniqLabels)
            maxOffset = 0;
            dispLabel = uniqLabels{j};
            temp = find(strcmp(labels,dispLabel));
            labelBegin = temp(1);
            labelEnd = temp(end);
            maxCharLength = floor((labelEnd-labelBegin+1)*3/2);
            while length(dispLabel)/maxCharLength > 1;
                maxOffset =maxOffset+1;
                dispLabel = dispLabel(maxCharLength+1:end);
            end
        end
        height = height+labelsFontSize/72*maxOffset;
    end
    set(gcf,'PaperUnits','inches');
    papersize = get(gcf,'PaperSize');
    left = (papersize(1)-width)/2;
    bottom = (papersize(2)-height)/2;
    myfiguresize = [left,bottom,width,height];
    set(gcf,'PaperPosition',myfiguresize);
    
    if ~isempty(specialVals)
        origyvals = yvals;
        specialValsKeys = keys(specialVals);
        if isnumeric(specialValsKeys{1})
            specialValsKeys = cell2mat(specialValsKeys);
        end
        yvals(ismember(yvals,specialValsKeys))=0;
    end

    if isScatter
        scatter(xvals,yvals,[],'b','MarkerFaceColor','b','SizeData',40);
    elseif isBoxPlot
        boxplot(yvals, xlabels);
    else
        if isStackBar
            barH=bar(xvals,yvals,'stacked');
            if strcmp(titleString,'subSystemsAdded')
                legend(legendLabels,'location','northwest', 'FontSize',30);
            elseif strcmp(titleString,'Coverage of Previous Models')
                legend(legendLabels,'location','northwest','FontSize',5);
            else
                legend(legendLabels,'location','northwest');
            end
        else
            barH=bar(xvals,yvals,'b','FaceColor','b');
        end
        if size(yvals,2)==2 && ~isStackBar
            set(barH(2),'FaceColor','r');
        end
        if ~isempty(errorBars)
            errorbar(xvals,yvals,errorBars(:,1),errorBars(:,2));
        end
    end
    if exist('ylabelString','var')
        ylabel(ylabelString,'FontSize',ylabelFontSize,'FontName','FixedWidth');
    end
    if exist('xlabelString','var')
        xlabel(xlabelString,'FontSize',xlabelFontSize,'FontName','FixedWidth');
    end
    % related to width setting above, set really tight bounds to
    % avoid large overhang distortion for few xvals
    if isScatter
        xlim([0 max(xvals(:))]);
        if addlsline
            h=lsline;
            set(h,'LineWidth',20);
            set(h,'Color','r');
        end
    elseif ~isBoxPlot
        xlim([0.5 length(xvals)+0.5]);
    end
    if all(yvals==yvals(1))
        titleString = ['WARNING_UNIFOM_VALS_' titleString];
        yLimData = [yvals(1) yvals(1)+.01];
    else
        if isStackBar
            yLimData = [min(sum(yvals,2)) max(sum(yvals,2))];
        else
            yLimData = [min(yvals(:)) max(yvals(:))];
        end
    end
    %disp(width)
    if isScatter
        ylim([0 yLimData(2)]);
    elseif ~isBoxPlot
        if yLimData(1)<0
            ylim([yLimData(1) yLimData(2)]);
        else
            ylim([0 yLimData(2)]);
        end
    end
    temp = ylim();
    yLimDataTop = temp(2)/(temp(2)-temp(1))*8.5;
    if temp(1)~=0
        yLimMax = max(temp(2),maxSpecialValLen*(specialValsFontSize/72)*(19/26)/yLimDataTop*temp(2));
    else
        yLimMax = max(temp(2),maxSpecialValLen*specialValsFontSize/72/yLimDataTop*temp(2));
    end
    if ~isempty(labels)
        yLimMax = yLimMax+maxOffset*labelsFontSize/72/yLimDataTop*temp(2);
    end
    yLimDataBottom = temp(1)/(temp(2)-temp(1))*8.5;
    temp
    -maxXLabelLen*(xlabelsFontSize/72)*(19/26)/yLimDataBottom*temp(1)
    yLimDataBottom
    if temp(1)~=0
        if isempty(regexp(titleString,'Normal'))
            yLimMin = min(temp(1),-maxXLabelLen*(xlabelsFontSize/72)*(19/26)/yLimDataBottom*temp(1)+yLimDataBottom);
        else
            yLimMin = min(temp(1),-maxXLabelLen*(xlabelsFontSize/72)*(19/26)/yLimDataBottom*temp(1)+temp(1));
        end
    else
        yLimMin = min(temp(1),-maxXLabelLen*xlabelsFontSize/72/yLimDataTop*temp(2)+yLimDataBottom);
    end
    if temp(1)~=0
        height = height-yLimDataBottom;
        set(gcf,'PaperUnits','inches');
        papersize = get(gcf,'PaperSize');
        left = (papersize(1)-width)/2;
        bottom = (papersize(2)-height)/2;
        myfiguresize = [left,bottom,width,height];
        set(gcf,'PaperPosition',myfiguresize);
    end

    ylim([yLimMin yLimMax]);
    tempxlabelMin = yLimMin;
    if strcmp(titleString,'EC Coverage Among HMP Species')
        ylim([-.15 1]);
        tempxlabelMin = -.15;
    elseif strcmp(titleString,'Gene Coverage Among HMP Species')
        ylim([-.05 1]);
        tempxlabelMin = -.05;
    elseif strcmp(titleString,'Coverage of Previous Models')
        temp = ylim();
        ylim([temp(1) 600]);
        tempxlabelMin = temp(1);
    end
    title(strrep(titleString,'_','\_'),'FontSize',titleFontSize,'FontName','FixedWidth');
    if ~isempty(xlabels)
        for j=1:length(xlabels)
            text(j,tempxlabelMin,xlabels{j},'Rotation',90,'FontSize',xlabelsFontSize,'FontName','FixedWidth');
        end
    end

    if ~isempty(labels)
        prevLabel = labels{1};
        for j=1:length(labels)
            if ~strcmp(labels{j},prevLabel)
                prevLabel = labels{j};
                line([j-.5 j-.5], [yLimMin yLimMax], 'LineWidth', 2, 'Color', 'r'); 
            end
        end

        for j=1:length(uniqLabels)
            dispLabel = uniqLabels{j};
            temp = find(strcmp(labels,dispLabel));
            labelBegin = temp(1);
            labelEnd = temp(end);
            maxCharLength = floor((labelEnd-labelBegin+1)*(xlabelsFontSize/72)*3/(labelsFontSize/72));
            labelOffset = 0;
            while length(dispLabel) > maxCharLength
                dispLabelPiece = dispLabel(1:maxCharLength);
                text(labelBegin-.5,yLimMax-(labelsFontSize/72)/(height*yLimMax/(yLimMax-yLimMin))*yLimMax*labelOffset, dispLabelPiece,'FontSize',labelsFontSize,'FontName','FixedWidth');
                dispLabel = dispLabel(maxCharLength+1:end);
                labelOffset = labelOffset+1;
            end
            dispLabelPiece = dispLabel;
            text(labelBegin-.5,yLimMax-(labelsFontSize/72)/(height*yLimMax/(yLimMax-yLimMin))*yLimMax*labelOffset, dispLabelPiece,'FontSize',labelsFontSize,'FontName','FixedWidth');
        end
    end
    if ~isempty(specialVals)
        for j=1:length(origyvals)
            if isKey(specialVals,origyvals(j))
                text(j,0,specialVals(origyvals(j)),'Rotation',90,'FontSize',specialValsFontSize,'FontName','Courier');
            end
        end
    end
    
    if ~isempty(indLines)
        for j=1:length(indLines)
            line([indLines(j) indLines(j)], [yLimMin yLimMax], 'LineWidth', 2, 'Color', 'g');
        end
    end
    
    line([0 length(xvals)], [0 0]);
    
    saveas(gcf,[outputDir filesep origTitleString '.png']);
    close(gcf);
end