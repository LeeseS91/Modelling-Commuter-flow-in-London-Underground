function [Radj,weighting]=insertweightings(A,weightingtype,zone)

Radj=zeros(size(A,2));
if weightingtype==1
    for p=1:size(A,1)
        k(p)=sum(A(p,:));
        if k(p)~=0
            % method to make sure the random weightings add up to 100
            randsumseq=randi(100,1,k(p));
%             randsumseq=randi(100,1,k(p)-1);
%             randsumseq(k(p))=0;
%             randsumseq(k(p)+1)=100;
%             randsumseq=sort(randsumseq);
            
%             if k(p)>2
%                 for kk=2:length(randsumseq)
%                     seq{p}(kk-1)=randsumseq(kk)-randsumseq(kk-1);
%                 end
%             elseif k(p)==2
%                 seq{p}(1,2)=randi(100,1,1);
%                 seq{p}(1,1)=100-seq{p}(2);
%             elseif k(p)==1
%                 seq{p}=100;
%                 
%             end
%             
%             if sum(seq{p})~=100
%                 error('Inconsistent')
%                 break;
%                 clear randssumseq
%             end
            oneindex=find(A(p,:)==1);
            Radj(p,oneindex)=(randsumseq/sum(randsumseq));
%             Radj(p,oneindex)=(seq{p}/100);
clear randsumseq

        end
    end
elseif weightingtype==2
    k=sum(A,2);
    for p=1:size(A,1)
        if k(p)>1
            if p==306
            end
            connectind{p}=find(A(p,:)==1);
            % Ive used normal degree rather that excess degree as for the
            % stations with degree 1, they always get weighted 0, which
            % should not be the case as people still travel there.
            excessdeg=0;
            for ppp=1:length(connectind{p})
                excessdeg=excessdeg+k(connectind{p}(ppp));
            end
            for pp=1:length(connectind{p})
                weighting{p}(pp)=(zone(p)/zone(connectind{p}(pp)))*...
                    ((k(connectind{p}(pp)))/excessdeg);
                if isnan(weighting{p}(pp))==1
                end
                
            end
            
            clear excessdeg          
            weighting{p}=weighting{p}/sum(weighting{p});
            Radj(p,connectind{p})=weighting{p};
        elseif k(p)==1
            connectind{p}=find(A(p,:)==1);
            weighting{p}=1;
            Radj(p,connectind{p})=weighting{p};
        elseif k(p)==0
            connectind{p}=0;
            weighting{p}=0;
            
        end
        
        
    end
end
end

