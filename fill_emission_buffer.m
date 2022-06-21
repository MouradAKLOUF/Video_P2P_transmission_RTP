function fill_emission_buffer(time,List_RTP_Pkts)

% put RTP_Pkts in emission_buffer at the end of the encoding

%% call global Vars
global scheduler;
global emission;
global TS;
global dt;
global decided_Rate_Levels;

%% update  scheduler

%%

%% 
propaTime=0;                                                      %propagation time for each RTP pkt. here const but could be random.

%building RTP pkts, put them in emission buffer
Seq_Num=1;                                                % Seq Numb for RTP packts
for k=1:1:length(List_RTP_Pkts)
    s=packet(List_RTP_Pkts(k));
    s = set(s,'time_idx',TS);
    s = set(s,'seq_num',Seq_Num);
    Seq_Num=Seq_Num+1;
    s = set(s,'propag_time',time+propaTime);  %add propagation_time for each RTp pkt, should be diffrent   
    if (k==length(List_RTP_Pkts))
        s = set(s,'marker',1);
    else
        s = set(s,'marker',0);
    end
    emission = insert(emission,s);
end



end


    
    