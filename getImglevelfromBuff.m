function recLevel= getImglevelfromBuff(reception,Dictionary,Num_Decod_Imgs_, Num_Encod_Imgs_)

if Num_Decod_Imgs_ > 0
    begin= Num_Decod_Imgs_ +1;
else
    begin= 1;
end
l=size(Dictionary);
if Num_Decod_Imgs_ >=  l(1)
        begin= l(1);
end

Dictio= Dictionary(begin : Num_Encod_Imgs_ ,:);
recLevel=zeros(Num_Encod_Imgs_-begin+1 ,1,'double');

list_rec_pckts=getAllPackets(reception);

if length(list_rec_pckts)==0
    return;
else
    
    l=size(Dictio);
    for k=1:1: l(1)
        
        
        ts=Dictio(k,1);
        num_pkts=Dictio(k,2);
        
        if (num_pkts ==0)
            break;
        else
            count=0;
            for i=1:1:length(list_rec_pckts)
                if get(list_rec_pckts(i), 'time_idx') == ts
                   count=count+1;
                end
            end
        end
        
        recLevel(k)=double(count)*100/double(num_pkts);
        
    end
  
end

end