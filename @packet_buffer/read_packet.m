function p = read_packet(b,idx)
% Reads a packet (without extracting it) from a packet_buffer class. 
% p = read_packet(b,idx)

if (nargin<2)
   error('Wrong number of input arguments')
end

if (class(b)~='packet_buffer')
   error('First argument should be a packet_buffer')
end

if (idx>b.size)
    warning('Index too large');
    p=packet();
else
    p = b.buff(idx);
end