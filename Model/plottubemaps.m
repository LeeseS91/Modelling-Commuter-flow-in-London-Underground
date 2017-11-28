function plottubemaps(plotgraph, Radj, initpopulations, x, totalmeanstat, totalmeanlink,direct)
% plotgraph=0;
load('underground_data.mat')
load('linecolours.mat')
importfile('underground.txt')
linedefinitions=importfile1('linedefinitions.txt');
lines=importfile2('lines.txt');

Adj=zeros(size(sorted_stations_numeric,1));
Lineadj=zeros(size(sorted_stations_numeric,1));
for i=1:size(linedefinitions,1)
    Adj(linedefinitions(i,1),linedefinitions(i,2))=1;
    Adj(linedefinitions(i,2),linedefinitions(i,1))=1;
    Lineadj(linedefinitions(i,1),linedefinitions(i,2))=linedefinitions(i,3);
    Lineadj(linedefinitions(i,2),linedefinitions(i,1))=linedefinitions(i,3);
end


V1 = sorted_stations_numeric(:,2);
V2 = sorted_stations_numeric(:,3);
zone=sorted_stations_numeric(:,4);
total_lines=sum(Adj,2);
colourvect=hsv(floor(max(zone)));
for ii=1:length(linecolours)
    linecolvect(ii,:)=rgbconv({linecolours{ii}(2:3),linecolours{ii}(4:5),linecolours{ii}(6:7)});
end
% linecolourvect=Lines(size(lines,1));
linecolourvect=linecolvect;

if plotgraph==1
    figure
    hold on
    for i = 1:length(Adj)
        if zone(i)>0
            if total_lines(i) >= 4
                plot(V2(i),V1(i), 'color', colourvect(floor(zone(i)),:),'marker','x','MarkerSize',5,'linewidth',5);
                plot(V2(i),V1(i),'kx','MarkerSize',3);
            end
            if total_lines(i) <=3
                plot(V2(i),V1(i),'color', colourvect(floor(zone(i)),:),'marker','.','MarkerSize',10);
                plot(V2(i),V1(i),'ko','MarkerSize',3);
            end
            
            for j = 1:length(Adj)
                if Adj(i,j) == 1
                    y = [V1(i) V1(j)];
                    x = [V2(i) V2(j)];
                    plot(x,y, 'color', linecolourvect(Lineadj(i,j),:));
                    hold on
                end
            end
        end
    end
elseif plotgraph==2
    normnum=max(initpopulations);
    normedpop=(initpopulations./normnum).*100;
    plotpop=ceil(normedpop./10);
    figure
    hold on
    for i = 1:length(Adj)
        if zone(i)>0
            plot(V2(i),V1(i),'color', colourvect(floor(zone(i)),:),'marker','.','MarkerSize',plotpop(i)*3);
            plot(V2(i),V1(i),'ko','MarkerSize',plotpop(i));
            
            
            for j = 1:length(Adj)
                if Adj(i,j) == 1
                    y = [V1(i) V1(j)];
                    x = [V2(i) V2(j)];
                    plot(x,y, 'color', linecolourvect(Lineadj(i,j),:));
                    hold on
                end
            end
        end
    end
elseif plotgraph==3
    normnum=max(max(x));
    normedpop=(x./normnum).*100;
    plotpop=ceil(normedpop./10);
    lineheat=autumn(max(max(plotpop)));
    figure
    hold on
    for i = 1:length(Adj)
        if zone(i)>0
            plot(V2(i),V1(i),'color', colourvect(floor(zone(i)),:),'marker','.','MarkerSize',6);
            plot(V2(i),V1(i),'ko','MarkerSize',2);
            
            
            for j = 1:length(Adj)
                if Adj(i,j) == 1
                    y = [V1(i) V1(j)];
                    x = [V2(i) V2(j)];
                    plot(x,y, 'color', lineheat(plotpop(i,j),:),'LineWidth',3);
                    hold on
                end
            end
        end
    end
elseif plotgraph==4
    
    weightedline=Radj.*100;
    weights=ceil(weightedline./5);
    lineheat=autumn(max(max(weights)));
    %     V2a=V2;
    %     V1a=V2;
    %     V1a(V1a==0)=[];
    %     V2a(V2a==0)=[];
    %     centre=[mean(V2a) mean(V1a)] ;
    figure
    centre=[-0.15 51.525];
    plot(centre(1),centre(2),'bx', 'MarkerSize', 10)
    hold on
    %     if direct==1
    %         A=triu(Adj);
    %     elseif direct==2
    %         A=triu(Adj)';
    %     end
    for i = 1:length(Adj)
        if zone(i)>0
            plot(V2(i),V1(i),'color', colourvect(floor(zone(i)),:),'marker','.','MarkerSize',6);
            plot(V2(i),V1(i),'ko','MarkerSize',2);
            
            
            for j = 1:length(Adj)
                if diag(Adj(i,j)) == 1
                    y = [V2(j) V1(j)];
                    x = [V2(i) V1(i)];
                    if direct==1
                        if  sqrt(sum((y - centre) .^ 2)) < sqrt(sum((x - centre) .^ 2))
                            
                            plot([x(1) y(1)],[x(2) y(2)], 'color', lineheat(weights(i,j),:),'LineWidth',3);
                            %                     quiver(V2(i),V1(i),(V2(j)-V2(i)),(V1(j)-V1(i)), 'color', lineheat(weights(i,j),:),'LineWidth',2);
                            hold on
                        end
                    elseif direct==2
                        if  sqrt(sum((y - centre) .^ 2)) > sqrt(sum((x - centre) .^ 2))
                            
                            plot([x(1) y(1)],[x(2) y(2)], 'color', lineheat(weights(i,j),:),'LineWidth',3);
                            %                     quiver(V2(i),V1(i),(V2(j)-V2(i)),(V1(j)-V1(i)), 'color', lineheat(weights(i,j),:),'LineWidth',2);
                            hold on
                        end
                    end
                end
            end
        end
    end
end
