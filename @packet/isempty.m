function b = isempty(p)
% PACKET empty test for Packet class. 

if (p.size == -1)
    b=1;
else
    b=0;
end