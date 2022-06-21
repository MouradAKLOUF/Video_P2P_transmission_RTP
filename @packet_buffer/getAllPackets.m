function p = getAllPackets(b)
% read all pckts
p=[];
if (b.size==0)
    %warning('Empty buff');
    p=[];
else  
    for i=1:1:b.size
         p=[p, b.buff(i)];
    end
end