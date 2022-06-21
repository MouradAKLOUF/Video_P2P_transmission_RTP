function action = get_optimal_action_Baseline(time,imgType)

% get target rate to encode the image

%% call global Vars

global vidLevels;
global current_R;
global R;
global Num_Encoded_Imgs_;
global initial_playBack_delay;
global emission;

global encoding_time_I;
global encoding_time_P; 
global decoding_time_I;
global decoding_time_P;

Beta=1;
Alpha=1;

avrgIsizes=[2646   7789  12074  15752  18650   21572   24374];       %avrg I size for each ecoding vidRate
P_intraRefresh=[371  1330  2472 3558   4636  5703  6753];
P_normal=[189	 829  1723  2632  3559  4497  5448];

%%       

if Num_Encoded_Imgs_~=1
current_R(time)= R(time);                                 %this used when plotting results, not important in decision.
end

% calculating nbr of bytes in emission_buff 
pckts=getAllPackets(emission);
bytesTosend= get_buffer(emission, 'bits_to_send');
for i=1:length(pckts)-1
   bytesTosend=bytesTosend+get(pckts(i) , 'size') ;
end
   
%%

    i=0;  
    totalTime=0;
    while bytesTosend>0 
        bytesTosend=bytesTosend-R(time+i)/8;
        i=i+1;
    end
    totalTime=totalTime+i-1;
    
    if strcmp(imgType,'I') 
        codecTime=encoding_time_I+decoding_time_I;
        encoding_time=encoding_time_I;
        sizes=avrgIsizes;
    else
        codecTime=encoding_time_P+decoding_time_P;
        encoding_time=encoding_time_P;
        if  strcmp(imgType,'P_intraRefresh')
            sizes=P_intraRefresh;
        else
            sizes=P_normal;
        end
    end
    timeLeft=(initial_playBack_delay-codecTime-totalTime)*(Beta);
    
    if timeLeft<=0
        action=1;
        return
    end

    outBytes =  sum ( R(time+totalTime+1:time+totalTime+ceil(timeLeft)) ) *(Alpha/8);
    cross= sizes-outBytes;
    temp= find (cross <= 0 );  %
    
    if length (temp) == 0
        temp=1;
    end
    action=temp(end);
    return
    


end