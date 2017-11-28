%%
%                 if length(find(x{count-1}(kk,:)<TOTout(count,kk)/nolinks(kk)))>(size(adj,2)-nolinks(kk))
%                     I=find(adj(kk,:)==1);
%                     Ilength=length(I);
%                     for t=1:Ilength
%                         changeno=0;
%                         if x{count-1}(kk,I(t))<TOTout(count,kk)/nolinks(kk)
%                             out{count}(kk,I(t))=x{count-1}(kk,I(t));
%                             changeno=changeno+1;
%                             changeind(changeno)=t;
%                             extra(changeno)=x{count-1}(kk,I(t));
%                         end
%                     end
%                     I(changeind)=[];
%                     out{count}(kk,I)=(TOTout(count,kk)-sum(extra))/length(I);
%                     for t=1:length(I)
%                         changeno=0;
%                         if x{count-1}(I(t),kk)<(TOTout(count,kk)-sum(extra))/length(I)
%                             out{count}(kk,I(t))=x{count-1}(kk,I(t));
%                             changeno=changeno+1;
%                             changeind(changeno)=t;
%                             extra(changeno)=x{count-1}(kk,I(t));
%                         end
%                     end
%
%                 else
%                     I=find(adj(kk,:)==1);
%                     out{count}(kk,I)=TOTout(count,kk)/nolinks(kk);
%                 end




%%
%                         if(x{count-1}(index(j),index2(k))-(out(count,index(j))/nolinks(index(j))))<0
%                            leave=x{count-1}(index(j),index2(k));
%                            missing=(out(count,index(j))/nolinks(index(j)))-x{count-1}(index(j),index2(k));
%                            if i>index2(k)
%                            out(count,index(j))=out(count,index(j))+nolinks(index(j))*missing;
%                            else
%                                out(count,index(j))=out(count,index(j))+nolinks(index(j))*missing;
%                                i=index2(k);
%                            end
%                         else
%                             leave=(out(count,index(j))/nolinks(index(j)));
%                         end

%%
%                 OutInd=find(adj(kk,:)==1);
%                 out{count}(kk,OutInd)=TOTout(count,kk)/nolinks(kk);
%                 correctcount=0;
%                 if sum(x{count-1}(kk,:))<TOTout(count,kk)
%                 end
%                 
%                 while min(x{count-1}(kk,:)-out{count}(kk,:))<0
%                     correctcount=correctcount+1;
%                     % if there are two equal minimum values, need
%                     % special case where just taking one of them i.e the 1st
%                     if length(find((x{count-1}(kk,:)-out{count}(kk,:))==min(x{count-1}(kk,:)-out{count}(kk,:))))>1
%                         tempInd=find((x{count-1}(kk,:)-out{count}(kk,:))==min(x{count-1}(kk,:)-out{count}(kk,:)));
%                         I(correctcount)=tempInd(1);
%                         clear tempInd
%                     else
%                         % otherwise just take the min val, i.e. where there
%                         % was the smallest number of people travelling down
%                         % the line
%                         I(correctcount)=find((x{count-1}(kk,:)-out{count}(kk,:))==min(x{count-1}(kk,:)-out{count}(kk,:)));
%                     end
%                     % update the number of people out who travelled down
%                     % this line so they all got off.
%                     out{count}(kk,I(correctcount))=x{count-1}(kk,I(correctcount));
%                     update(correctcount)=x{count-1}(kk,I(correctcount));
%                     Ind=OutInd;
%                     % delete the index for the already updated out values
%                     % and now split whats left from the total number of people
%                     % out after this update between the remaining stations 
%                     if correctcount>50
%                         kk
%                     end
%                     for i=1:length(unique(I))
%                         Ind(Ind==I(correctcount))=[];
%                     end
%                     if length(unique(update))==length(unique(I))
%                     out{count}(kk,Ind)=(TOTout(count,kk)-sum(unique(update)))/length(Ind);
%                     else
%                     end
%                     
%                     % now the while loop checks if any of the number of
%                     % people are still negative and the process starts over
%                     if sum(out{count}(kk,:))~=TOTout(count,kk)
%                         
%                     end
%                 end
%                 clear I correctcount update Ind OutInd