% very simple model using a random adjacency matrix and some random rates
% and initial populations at each node.
clear all

adj=[0 1 1 0 0 0 1 0; 1 0 0 0 1 0 0 1; 1 0 0 1 1 0 1 0; 0 0 1 0 0 1 1 1;...
    0 1 1 0 0 1 0 0; 0 0 0 1 1 0 0 1; 1 0 1 1 0 0 0 0; 0 1 0 1 0 1 0 0];

Adj2=adj*adj;

Radj=[0 0.3 0.2 0 0 0 0.5 0;...
    0.4 0 0 0 0.2 0 0 0.4;...
    0.1 0 0 0.2 0.4 0 0.3 0;...
    0 0 0.3 0 0 0.3 0.3 0.1;...
    0 0.4 0.3 0 0 0.3 0 0;...
    0 0 0 0.2 0.2 0 0 0.6;...
    0.2 0 0.1 0.7 0 0 0 0;...
    0 0.4 0 0.3 0 0.3 0 0];

In=[30, 25, 35, 40, 10, 44, 50, 22];
Out=[59, 5, 13, 87, 49, 85, 21, 56];

randompop=1;
maxpop=200;
cap=40;

if randompop==1
    initialpop=randi(maxpop,1,size(adj,2));
    initpop=initialpop;
else
    initialpop=[20, 33, 10, 40, 19, 9, 28, 37];
    initpop=initialpop;
end

for count=1:10
    totalpop(count)=sum(initpop);
    nolinks=sum(adj,2);
    %     rates=[0.4,0.48,0.63,0.72,0.20,0.37,0.5,0.18]; % predefined rates
    
    %     critval=70; % critical number of people at which congestion occurs
    %     B=[0.3,0.15]; % constants for types of rate with/without congestion
    %         for ii=1:length(initpop)
    %             if initpop(ii)<=critval
    %                 rates(ii)=nolinks(ii)*B(1);
    %             else
    %                 rates(ii)=nolinks(ii)*B(2);
    %             end
    %         end
    
    % process the number of people entering and leaving a station
    for kk=1:length(initpop)
        in(count,kk)=randi(In(kk),1,1);
        out(count,kk)=round((randi(Out(kk),1,1)/100)*initpop(kk));
        initpop(kk)=initpop(kk)+in(count,kk)-out(count,kk);
    end
    
    for k=1:length(initpop)
        
        % change in population: assuming that the change in population is
        % proportional to the number of people at the other end of the links
        % in, multiplied by the travel rate and evenly spread across the total number
        % of links that the node has. Then number of people leaving that node
        % at the same time is just the population multiplied by the rate.
        x{count}(k,:)=adj(k,:).*initpop.*Radj(:,k)';
        % cap number of people able to fit on the train
        for ii=1:length(x{count}(k,:))
            if x{count}(k,ii)>cap
                x{count}(k,ii)=cap;
            end
        end
        dPop(count,k)=sum(x{count}(k,:))-initpop(k);
%         clear x
    end
    
    newpop(1,:)=initialpop;
    newpop(count+1,:)=round(initpop+dPop(count,:));
    initpop=newpop(count,:);
    
    
end
