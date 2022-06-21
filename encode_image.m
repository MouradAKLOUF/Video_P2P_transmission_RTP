function RTP_packets=encode_image(time,frame)

% encod the frames, update their properties and the Dictionary 
% put RTP pkts in emission buff

%% call global Vars
global scheduler;
global emission;
global TS;
global dt;
global Num_Imgs_;
global Num_Encoded_Imgs_;
global sequence;
global Dictionary;
global IntraRefresh_frameSizes;
global IntraRefresh_avrgPSNR;
global R;
global vidLevels;
global maxRTPsize;
global actions_vector;
global decided_Rate_Levels;

global encoding_time_I;
global encoding_time_P; 

%% update  scheduler

if (Num_Encoded_Imgs_>= Num_Imgs_)
    RTP_packets=[];
    return;
end
 
%%

TS=TS+dt;
Num_Encoded_Imgs_=int16(TS/dt)+1;

if Num_Encoded_Imgs_==1
        imgType='I';
        encodTime=encoding_time_I;
else
    if  (Num_Encoded_Imgs_ /32) > 1 &&  (rem(Num_Encoded_Imgs_,32)>=1   && rem(Num_Encoded_Imgs_,32)<=10 )
        imgType='P_intraRefresh';
    else
        imgType='P_normal';
    end
    encodTime=encoding_time_P;
end
                                        

fill={[time+encodTime],'fill_emission_buffer'};              %fill_emission_buffer
scheduler = [scheduler; fill];

%%



% if Num_Encoded_Imgs_==1
%     action=1;
% else
%     %action = MDP_agent_qlearning_delayed (time);
%     action = get_optimal_action_Baseline(time,imgType);
% end

action = get_optimal_action_Baseline(time,imgType);

action = 4;

actions_vector(Num_Encoded_Imgs_ ,:)= action ;
decided_Rate_Levels(Num_Encoded_Imgs_ ,:)= vidLevels ( action );
        
[List_RTP_Pkts, numRTPpkts] = splitImg2RTPpkts(IntraRefresh_frameSizes{action}(Num_Encoded_Imgs_),maxRTPsize);  
        
frame=set_image(frame,'size',sum(List_RTP_Pkts),'type',imgType, 'psnr',IntraRefresh_avrgPSNR{action}(Num_Encoded_Imgs_));
                                 
frame=set_image(frame,'time_idx',TS,'start_encod',time, 'end_encod',time+encodTime, ...
                                     'end_trans',-1, 'end_decod',-1,'decodable',0,'lost',length(List_RTP_Pkts));

% save frame, update Dictionary to use it in decoding, 
sequence=[sequence, frame]; 
Dictionary(Num_Encoded_Imgs_ ,:)= [TS, length(List_RTP_Pkts)];

RTP_packets=List_RTP_Pkts;

%% these stats need to be colected 1 time each 40mses
global recBuffLevel,
global emiBuffLevel,

if Num_Encoded_Imgs_> 0
[recLevel, emiLevel]= getBuffLevel();
recBuffLevel(Num_Encoded_Imgs_ ,1)=double(recLevel)/100;
emiBuffLevel(Num_Encoded_Imgs_ ,1)=double(emiLevel)/100;
end

global recBuffLevelInPkts;
global emiBuffLevelInPkts;
global reception;

recBuffLevelInPkts(Num_Encoded_Imgs_ ,1)= get_buffer(emission, 'size');
emiBuffLevelInPkts(Num_Encoded_Imgs_ ,1)= get_buffer(reception, 'size');



