function decode_image_2(time, TS_to_clear)

% decoding frames

%% call global Vars
global scheduler;
global reception;
global TS_r;
global TS_d;
global TS;
global dt;
global Num_Imgs_;
global Num_Decoded_Imgs_;
global sequence;
global Dictionary;
global decoded_new_img;

global decoding_time_I;
global decoding_time_P;

global tracing_imgs;

global num_received_pkts;
%% update  scheduler

list_rec_pckts=getAllPackets(reception);
reception = clear_buffer(reception) ;                      %get_buffer(reception, 'bit_size')

for k=1:1:length(list_rec_pckts)
     img_ts=get(list_rec_pckts(k), 'time_idx');
     num_received_pkts (int16(img_ts/dt)+1 ,1)=num_received_pkts (int16(img_ts/dt)+1 ,1)+1; 
end

%if TS_to_clear ~= -999
    
Num_Decoded_Imgs_ =int16(TS_to_clear/dt)+1;                                  %Num_Decoded_Imgs_+1;  

if  strcmp(get_image(sequence(int16(TS_to_clear/dt)+1), 'type'), 'I')   %if I frame
    decoTime=time+decoding_time_I;
elseif strcmp(get_image(sequence(int16(TS_to_clear/dt)+1), 'type'), 'P_intraRefresh')  || strcmp(get_image(sequence(int16(TS_to_clear/dt)+1), 'type'), 'P_normal')  %if P frame
    decoTime=time+decoding_time_P;
end

sequence(int16(TS_to_clear/dt)+1) = set_image(sequence(int16(TS_to_clear/dt)+1),'end_trans',time, 'end_decod',decoTime, ...
                                            'decodable',1,'lost',0); 

   
%get_image(img, 'start_encod');  
global TxRx_delay_imgs;
TxRx_delay_imgs(int16(TS_to_clear/dt)+1 ,1)= decoTime - get_image(sequence(int16(TS_to_clear/dt)+1), 'end_encod');
                                        
                                        
sequence(int16(TS_to_clear/dt)+1)=set_image(sequence(int16(TS_to_clear/dt)+1),'lost',0);   
tracing_imgs(int16(TS_to_clear/dt)+1 ,3)=0;
tracing_imgs(int16(TS_to_clear/dt)+1 ,4)=num_received_pkts (int16(TS_to_clear/dt)+1 ,1);

%end


end


    
    