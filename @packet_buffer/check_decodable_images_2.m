function [reception, isDecodable,numLostPkts,numPktsAvailable]= check_decodable_images_2(reception,TS_r,dt)

list_rec_pckts=getAllPackets(reception);
reception = clear_buffer(reception) ;                      %get_buffer(reception, 'bit_size')


if TS_r~=0
    temp_list=[];
    for k=1:1:length(list_rec_pckts)
        r=list_rec_pckts(k);
        if get(r, 'time_idx')>= TS_r
           temp_list=[temp_list r]; 
        end
    end
    list_rec_pckts=temp_list;
end


if length(list_rec_pckts)==0
    isDecodable=false;
    numLostPkts=-1;
    numPktsAvailable=-1;
    return;
end
  
curr_img=[];
others=[];
    
for k=1:1:length(list_rec_pckts)
    r=list_rec_pckts(k);
    if get(r, 'time_idx')== TS_r
       curr_img=[curr_img r];
    else
       others=[others r]; 
    end
end

numPktsAvailable=length(curr_img);

last_rtp=false;
last_SeqNum=-1;

for k=1:1:length(curr_img)
    if get(curr_img(k), 'marker') == 1
       last_rtp=true;
       last_SeqNum=get(curr_img(k), 'seq_num') ;
    end
end

if last_rtp==true
    numLostPkts=last_SeqNum-length(curr_img);
    
    if numLostPkts==0
        isDecodable=true;
    else
        isDecodable=false;
    end
else
    numLostPkts=-1;
    isDecodable=false;
end

   p=[curr_img others]; 
   for k=1:1:length(p)
       reception = insert(reception, p(k) );
   end
         
end