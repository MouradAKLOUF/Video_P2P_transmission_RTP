function  transmit_packet_2(time,drop_pkts,PER)

% take pkts from emission buff and put theme in reception buff according to
% available output rate

%% call global Vars
global scheduler;
global emission;
global reception;
global R;
global fisrt_call_off_transmit_packet;
global pkts_waiting_;
global last_send_time;

global received_flag;
global dt;

%% update  scheduler

%TS_to_clear= -999;

tra={[time+1],'transmit_packet'};              %transmit_packet
scheduler = [scheduler; tra];

%%
if fisrt_call_off_transmit_packet== true
    last_send_time=time;
    fisrt_call_off_transmit_packet=false;
    
    
    return;
end

if isempty(emission) 
    
    temp_p=[];                                                          
    %dont send but receive                                                                          
    for k=1:1:length(pkts_waiting_)                              %inserting RTP pkts  in reception buffer only after propagation time
        if get(pkts_waiting_(k), 'propag_time')<=time
            
            reception = insert(reception,pkts_waiting_(k));
            
            img_ts=get(pkts_waiting_(k), 'time_idx');
            end_marker=get(pkts_waiting_(k), 'marker');
        
        if end_marker == 1
            received_flag(int16(img_ts/dt)+1 ,1)= 1;
            decode_image_2(time, img_ts);
        end

        else
            temp_p=[temp_p pkts_waiting_(k)];
        end
    end
    pkts_waiting_=temp_p;                                          %try uinserting the rest of pkts next time you call transmit_packet

    last_send_time=time;
    
    return;
end

%%
%extract

time_int= time - last_send_time;
last_send_time=time;

% get_buffer(emission, 'bit_size')
% get_buffer(reception, 'bit_size')
% get_buffer(emission, 'size')
% get_buffer(reception, 'size')
% get_buffer(emission, 'bits_to_send')
% get_buffer(reception, 'bits_to_send')

if last_send_time==0
    extractedData= 0;
else
    extractedData= (time_int) * R(time)/8 ;           % extract N Bytes
end
[p,emission]=extract(emission, extractedData);       


%drop 
if drop_pkts==true
  notDroped_p=[];
  for k=1:1:length(p)
      if PER<=rand(1,1)                                           %take only (1-PER)% of the pckts
          notDroped_r=[notDroped_p, p(k)];
      end
  end
  pkts_waiting_=[pkts_waiting_, notDroped_p];        %take only (1-PER)% of the pckts
else                                                                     % remeber that losing 1 RTP pkt means your img in not
pkts_waiting_=[pkts_waiting_, p];                          %take all pckts when not drop_pkts
end    
                                                                           
temp_p=[];                                                          
                                                                           
%receive                                                                          
for k=1:1:length(pkts_waiting_)                              %inserting RTP pkts  in reception buffer only after propagation time
    if get(pkts_waiting_(k), 'propag_time')<=time
        
        reception = insert(reception,pkts_waiting_(k));
        
        img_ts=get(pkts_waiting_(k), 'time_idx');
        end_marker=get(pkts_waiting_(k), 'marker');
        
        if end_marker == 1
            received_flag(int16(img_ts/dt)+1 ,1)= 1;
%             dec={[time],'decode_image'};              %decode_image
%             scheduler = [scheduler; dec];
            decode_image_2(time, img_ts);
        end
%             TS_to_clear= img_ts;
        
    else
        temp_p=[temp_p pkts_waiting_(k)];
    end
end
pkts_waiting_=temp_p;                                          %try uinserting the rest of pkts next time you call transmit_packet




