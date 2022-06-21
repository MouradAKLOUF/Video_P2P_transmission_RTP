function b = insert(b,p)
% Inserts a packet in the packet_buffer. 

if (nargin<2)
   error('Wrong number of input arguments')
end

if (class(b)~='packet_buffer')
   error('First argument should be a buffer')
end

if (class(p)~='packet')
   error('Second argument should be a packet')
end

if (b.size<b.size_max)
   b.size = b.size+1;
   b.buff(b.size) = p;
   
   if (b.has_one_pckt == false)
       b.bits_to_send = get(p,'size');
       b.has_one_pckt = true;
   end
       
   b.bit_size = b.bit_size + get(p,'size');
   
else
   warning('Packet_buffer full, oldest packet has been dropped');
   [tmp,b] = extract1(b);
   b.size = b.size+1;
   b.buff(b.size) = p;
   if (b.has_one_pckt == false)
       b.bits_to_send = get(p,'size');
       b.has_one_pckt = true;
   end
   b.bit_size = b.bit_size + get(p,'size');
   
end   
