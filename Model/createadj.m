function [Adj,zone]=createadj(plotgraph)
% plotgraph=0;
load('underground_data.mat')
% importfile('underground.txt')
load('linecolours.mat')
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
if plotgraph==1
% linecolourvect=Lines(size(lines,1));
linecolourvect=linecolvect;
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
end