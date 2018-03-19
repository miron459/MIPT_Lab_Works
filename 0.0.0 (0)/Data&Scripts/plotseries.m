function [fitObj, fitCoeffs, fitConfInts]= plotseries(dataCont, ix, iy, iData )
    %% process input parameters
    if nargin <= 0
        error('data is a required input')
    end
    [nData, ~]=size(dataCont.data);
    if(nData==0) 
        return
    end
    if nargin == 4
        if(isa(iData, 'char') || isa(iData, 'string'))
            matches=regexp(dataCont.names, iData, 'once');
            k=1;
            for i=1:size(matches, 1)
                if(max(size(matches{i}))>0)
                    dataNums(k)=i; %#ok
                    k=k+1;
                end
            end
        else
            dataNums=iData;
        end
        nPlots=max(size(dataNums));
    end
    if nargin <= 3
        nPlots=nData;
        dataNums=1:nPlots;
        if nargin <= 2
            iy=zeros(max(dataNums),1)+2;
            if nargin <= 1
                ix=zeros(max(dataNums),1)+1;
            end
        end
    end
    if nargin >= 2
        if(isa(ix, 'char') || isa(ix, 'string'))
            colName=char(ix);
            ix=zeros(max(dataNums), 1);
            for i=1:nPlots
                ix(dataNums(i))=dataCont.colIndexByColName{dataNums(i)}(colName);
            end
        end
        if nargin >=3
            if(isa(iy, 'char') || isa(iy, 'string'))
                colName=char(iy);
                iy=zeros(max(dataNums), 1);
                for i=1:nPlots
                    iy(dataNums(i))=dataCont.colIndexByColName{dataNums(i)}(colName);
                end
            end
        end
    end
    
    %% setup fit
    leglines=4;
    leg=strings(nPlots*leglines, 1);
    fitObj=cell(nPlots, 1);
    fitType='poly1';
    fitNCoeffs=2;
    fitCoeffs=zeros(max(dataNums),fitNCoeffs);
    fitConfInts=zeros(max(dataNums),fitNCoeffs, 2);

    %% make new space
    figure;
    hold on;
    grid on;

    %% setup styles
    lineStyles={'none', 'none', 'none', 'none'};
    lineWidths={2, 2, 2, 2};
    colors={'k', 'r', 'b', 'g', 'c', 'm', 'y', 'w'};
    markers={'.', '+', 'x', '^', 'v', 'x', 'd', '^', 'v', '>', '<', 'p', 'h', 's'};
    markerSizes={25, 10, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8};
    markerEdgeColors={'k', 'r', 'b', 'g', 'c', 'm', 'y', 'w'};
    markerFaceColors={'k', 'r', 'b', 'g', 'c', 'm', 'y', 'w'};
    fitLineStyles={'--', ':', '-.', '-'};
    fitLineWidths={2, 2, 2, 2};
    fitLineJoins={'round', 'round', 'round'};
    format='%+5.3f';
    formaterr='%5.3f';

    %%
    for iPlot=1:nPlots
        iDatum=dataNums(iPlot);

        X=dataCont.data{iDatum}(:,ix(iDatum));
        Y=dataCont.data{iDatum}(:,iy(iDatum));

        % sort
        s = [X Y];
        s = sortrows(s,1);
        X = s(:, 1);
        Y = s(:, 2);

        % plot1
        plot1 = plot(X, Y);
        set(plot1, 'LineStyle', getcircled(lineStyles, iPlot));
        set(plot1, 'LineWidth', getcircled(lineWidths, iPlot));
        set(plot1, 'Color', getcircled(colors, iPlot));
        set(plot1, 'Marker', getcircled(markers, iPlot));
        set(plot1, 'MarkerSize', getcircled(markerSizes, iPlot));
        set(plot1, 'MarkerEdgeColor', getcircled(markerEdgeColors, iPlot));
        set(plot1, 'MarkerFaceColor', getcircled(markerFaceColors, iPlot));

        % fit1
        fitObj{iDatum}=fit(X, Y, fitType);
        fit1Plot=plot(fitObj{iDatum});
        fitCoeffs(iDatum, :)=coeffvalues(fitObj{iDatum}); %#ok<*SAGROW>
        fitConfInts(iDatum, :, :)=confint(fitObj{iDatum})';
        set(fit1Plot, 'LineStyle', getcircled(fitLineStyles, iPlot));
        set(fit1Plot, 'LineWidth', getcircled(fitLineWidths, iPlot));
        set(fit1Plot, 'LineJoin', getcircled(fitLineJoins, iPlot));
        set(fit1Plot, 'Color', getcircled(colors, iPlot));

        leg(leglines*(iPlot-1)+1)=dataCont.names{iDatum};
        leg(leglines*(iPlot-1)+2)='linear fit a*x+b:';
        leg(leglines*(iPlot-1)+3)=['a = ' num2str(fitCoeffs(iDatum, 1), format)...
            '±' num2str(abs(fitConfInts(iDatum,1,1)-fitConfInts(iDatum,1,2))/2, formaterr)];
        leg(leglines*(iPlot-1)+4)=['b = ' num2str(fitCoeffs(iDatum, 2), format)...
            '±' num2str(abs(fitConfInts(iDatum,2,1)-fitConfInts(iDatum,2,2))/2, formaterr)];
        for iter=1:leglines-2
            plotx=plot(X(1), Y(1));
            plotx.Marker='none';
            plotx.LineStyle='none';
        end
    end

    %% legend
    l=legend(leg);
    l.TextColor='k';
    l.Color = 'w';
    l.Box = 'on';
    l.EdgeColor = [0.15 0.15 0.15];
    l.LineWidth = 0.5;
    l.Location ='northwest';

    %% final
    iDatum=dataNums(1);
    title(['Dependence of ' dataCont.colNames{iDatum}{iy(iDatum)} ' on ' dataCont.colNames{iDatum}{ix(iDatum)}]);
    xlabel([dataCont.colNames{iDatum}{ix(iDatum)} ' [' dataCont.colUnits{iDatum}{ix(iDatum)} ']']);
    ylabel([dataCont.colNames{iDatum}{iy(iDatum)} ' [' dataCont.colUnits{iDatum}{iy(iDatum)} ']']);
    hold off;
end 