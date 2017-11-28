clear all
% decide commute choice, 1 is where you have random numbers of people
% getting on and off, and 2 is for having people commuting according to
% zones. 3 is for when i was debugging, and so is easy if you want to set
% people entering and leaving to zero
commutechoice=1;

% adjacency matrix created, and output station zones as well.
[adj,Zone]=createadj(0);

% locate the null station with no links
excludeindex=find(sum(adj)==0);
% adj(excludeindex,:)=[];
% adj(:,excludeindex)=[];

Adj2=adj*adj; % this is how you find adjacency matrix for connections of length 2

% Weighted adj matrix: proportions of people that travel to station j from
% station i. 1 gives random weightings 2 does it according to the degree of
% the neighbouring nodes.
Radj=insertweightings(adj,2, Zone);


if commutechoice==1
    In=randi([100 1800],1,size(adj,1));
    
    % Cap on the percentage of people who may leave station i, hopefully get
    % data to give real world values
    % Out=[59, 5, 13, 87, 49, 85, 21, 56];
    Out=randi([5 90], 1,size(adj,1));
elseif commutechoice==2
    % set the maximum proportion of people who can leave a station
    % according to the zone the stations in. Lower zone number is closer to
    % centre
    for adjcount=1:size(adj,1)
        Const=(11-Zone(adjcount))*10;
        Out(1,adjcount)=round(randi([Const-9 Const], 1,1));
        variance=5;
    end
elseif commutechoice==3
    Out=zeros(1,size(adj,1));
end

%decide if using random intital populations, max possible size of initial
%populations and the cap on how many people can use the train
randompop=1;
maxpop=1800;
cap=300;

% either random initial populations or pre set ones
if randompop==1
    initialpop=randi(maxpop,1,size(adj,1));
    initialpop(excludeindex)=0;
    initpop=initialpop;
else
    initialpop=[20, 33, 10, 40, 19, 9, 28, 37];
    initpop=initialpop;
end

newpop(1,:)=initialpop;
newpopalt(1,:)=initialpop;
expectedtotal(1)=sum(initpop);
% count will decide number of iterations
for count=1:50
    % check the actual total population in the network and how many lines
    % run from each station
    totalpop(count)=sum(initpop);
    totalpopalt(count)=sum(newpopalt(count,:));
    nolinks=sum(adj,2);
    
    % process the number of people entering and leaving a station (first
    % step when count=1, dont want any initial change)
    if commutechoice==1
        for kk=1:length(initpop)
            if count>1
                % in is a random NUMBER of people between 0 and the max In
                % defined by the array 'In'
                TOTin(count,kk)=randi(In(kk),1,1);
                %out is a random PERCENTAGE of the population at the station
                %that is between 0 and the max Out defined by array 'Out'
                TOTout(count,kk)=round((randi(Out(kk),1,1)/100)*initpop(kk));
                TOTin(count,excludeindex)=0;
                TOTout(count,excludeindex)=0;
                initpop(kk)=initpop(kk)+TOTin(count,kk)-TOTout(count,kk);
                
                out{count}(kk,:)=zeros(1,size(adj,2));
                OutInd=find(adj(kk,:)==1);
                out{count}(kk,OutInd)=TOTout(count,kk)/nolinks(kk);
            else
                TOTin(count,kk)=0;
                TOTout(count,kk)=0;
                initpop(kk)=initpop(kk)+TOTin(count,kk)-TOTout(count,kk);
            end
        end
        %% commute choice 2
    elseif commutechoice==2 % alternative in and out function in which 
                            % people are commuting to the centre
        for kk=1:length(initpop)
            correctcount=1;
            if count>1 && kk~=excludeindex
                % Prop is the proportion of people leaving station kk,
                % according to cap Out decided previously
                Prop=(randi(Out(kk),1,1)/100);
                % TOTout is the total people leaving
                TOTout(count,kk)=(Prop*initpop(kk));
                % TOTin is total in, and was worked out according to how
                % many in depending on what zone their in... THIS COULD
                % PROBABLY BE DONE BETTER
                % **************************************
                TOTin(count,kk)=(round(TOTout(count,kk)*(Zone(kk)/mean(Zone))));
%                 +round(min(variance,sqrt(TOTout(count,kk)))*randn(1,1));

                % Make sure negative people arent entering
                if TOTin(count,kk)<0
                    TOTin(count,kk)=0;
                end
                % set people entering at null station to zero
                TOTin(count,excludeindex)=0;
                TOTout(count,excludeindex)=0;
                
                % evenly send out proportion Prop of every link from the
                % station
                out{count}(kk,:)=zeros(1,size(adj,2));
                OutInd=find(adj(kk,:)==1);
                for kkkk=1:length(OutInd)
                    out{count}(kk,OutInd(kkkk))=Prop*x{count-1}(kk,OutInd(kkkk));
                end
                
                % debug checks...
                if sum(out{count}(kk,:))~=TOTout(count,kk)
                end
                if min(x{count-1}(kk,:)-out{count}(kk,:))<0
                end
                
                % update the inital population according to whose entered
                % and left
                clear Prop                            
                initpop(kk)=initpop(kk)+TOTin(count,kk)-TOTout(count,kk);
                
            else
                TOTout(count,kk)=0;
                TOTin(count,kk)=0;
                initpop(kk)=initpop(kk)+TOTin(count,kk)-TOTout(count,kk);
                I=find(adj(kk,:)==1);
                out{count}(kk,I)=TOTout(count,kk)/nolinks(kk);
                clear I
            end
        end

        %% commute choice 3
    elseif commutechoice==3 % irrelevant alternative commuter choice used 
                            % for debugging
                TOTout(count,:)=zeros(1,size(adj,2));
%         for cp=1:size(adj,2)
%             TOTout(count,cp)=(randi(90)/100)*initpop(cp);
%             I=find(adj(cp,:)==1);
%             out{count}(cp,I)=TOTout(count,cp)/nolinks(cp);
%             clear I
%         end
                TOTin(count,:)=zeros(1,size(adj,2));
%         TOTin(count,:)=randi(40,1,size(adj,2));
                out{count}=zeros(size(adj,1));
        
        initpop=initpop+TOTin(count,:)-TOTout(count,:);
    end

    
    %% carry out calculations
    for i=1:length(initpop)
        if count==1
            % for the first iteration dont need to worry about where people
            % have come from just distribute the initial population
            % according to the rates
            x{count}(i,:)=initpop.*Radj(:,i)';
        else
            
            % make sure people dont go back the way the came. This bit may
            % be a bit confusing as it took some time to get my head around
            % the indexing etc. But im pretty sure its right
            
            % find stations going into i
            index=find(adj(i,:)==1);
            x{count}(i,:)=zeros(1,size(adj,2));
            
            % for each station j connecting to station i we need to find
            % the population that entered j previously and assign where
            % they are likely to go
            for j=1:length(index)
                
                % stations entering j, then delete station i, unless its
                % the only station entering j, in which case only
                % population coming in to i from j will be those who
                % entered station j from outside
                index2=find(adj(index(j),:)==1);
                if length(index2)>1
                    index2(index2==i)=[];
                    for k=1:length(index2)
                        
                        %work out the number of people who go into the station
                        %as a proportion of who is there considering that
                        %people wont be going back the way they came.
                        add(k)=(Radj(index(j),i)/(sum(Radj(index(j),:))-...
                            Radj(index(j),index2(k))))*(x{count-1}(index(j),index2(k))...
                            -out{count}(index(j),index2(k)));
                    end
                else
                    add=0;
                end
                % find the total number of people heading in to station i
                % from j. This assumes that the people that have just
                % entered the station from outside go down each line based
                % on their weighting in 'Radj'
                x{count}(i,index(j))=(TOTin(count,index(j))*Radj(index(j),i)+sum(add));
               
                clear index2
                clear add
            end
            clear index
        end
        
        % cap number of people able to fit on the train
        for ii=1:length(x{count}(i,:))
            if x{count}(i,ii)>cap
                x{count}(i,ii)=cap;
            end
        end
        
    end
    %% update populations
    for i=1:length(initpop)
        % change in pop of station i is the number of people entering minus
        % the number of people leaving
        dPop(count,i)=sum(x{count}(i,:))-sum(x{count}(:,i));
        if dPop(count,i)+initpop(i)<0
        end
        
    end
    
    %update the station populations, and check that the total people in the
    %network is as expected
    newpop(count+1,:)=initpop+dPop(count,:);
    if sum(isnan(newpop(count+1,:)))>=1
    end
    clear initpop
    initpop=newpop(count+1,:);
    expectedtotal(count+1)=expectedtotal(count)+sum(TOTin(count,:))-sum(TOTout(count,:));
    
    % run a check, was used for debugging, dont worry about it
    if count>1
        for poo=1:length(initpop)
            
            checkit{count-1}(poo,2)=sum(x{count}(:,poo));
            checkit{count-1}(poo,3)=0;
            checkit{count-1}(poo,4)=sum(x{count}(poo,:));
            checkit{count-1}(poo,5)=newpop(count+1,poo);
        end
    end
end
% find the final total population in the network and checkpop makes sure it
% is consistent with how many people we expect to find in the network
totalpop(count+1)=sum(initpop);
totalpopalt(count+1)=sum(newpopalt(count+1,:));
checkpop(1,:)=totalpop;
checkpop(2,:)=expectedtotal;

% a debug check to see if there were any negative populations
min(min(newpop))
find(min(newpop)<0)

% total/mean station usage
Totalactivity=sum(newpop,1);
meanactivity=mean(newpop,1);

% to find total link usage
totx=zeros(size(adj,1));
for hi=2:length(x)
    totx=totx+x{hi};
end
for eye=1:size(adj,1)
    for jay=1:size(adj,2)
        linktot(eye,jay)=totx(eye,jay)+totx(jay,eye);
    end
end
        
% plot for starting populations
plottubemaps(2, Radj, initialpop, x)
% plot for activity at stations, either use meanactivity or Totalactivity
plottubemaps(2, Radj, Totalactivity, x)
% plot for activity on links, shows combined directional use
plottubemaps(3,Radj, initialpop,linktot)
% plot for weightings of each link for entering towards the centre
plottubemaps(4,Radj, initialpop,linktot,0,0,1)
% plot for weightings of each link leaving the centre
plottubemaps(4,Radj, initialpop,linktot,0,0,2)