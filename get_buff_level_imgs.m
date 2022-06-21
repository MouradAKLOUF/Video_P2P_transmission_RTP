

function b= get_buff_level_imgs(emission)

global dt;
global Dictionary;


list_pckts=getAllPackets(emission);
if length(list_pckts)==0
    b=0;
    return;
end

saves=[[-1;-1;-1]];

prec_img_indx=1;
prev_ts=-1;
count=-1;
for i=1:1:length(list_pckts)
    img_indx=int16(get(list_pckts(i), 'time_idx')/dt)+1; 
    ts=Dictionary(img_indx,1);        
    if  ts == prev_ts
       count=count+1;
    else
        saves=[saves [int16(prev_ts/dt)+1 ;count; Dictionary(prec_img_indx,2)]];
        prev_ts=ts;
        count=1;
        prec_img_indx=img_indx;
    end
end

saves=[saves [int16(prev_ts/dt)+1 ;count; Dictionary(img_indx,2)]];    
saves=saves(:,3:end);
% l=size(saves);
% 
% for i=1:1:l(2)
%     img_indx=saves(1,i); 
%     num_pkts=Dictionary(img_indx,2);       
%     saves(2,i)=saves(2,i)/num_pkts;
% end
b=saves;
 

end