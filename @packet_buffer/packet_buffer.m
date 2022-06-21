function b = packet_buffer(varargin)
% PACKET_BUFFER Constructor for packet_buffer class. 
% p = packet_buffer(size_max)
switch nargin
case 0 
   % if no input arguments, create a default object
   b.size = 0;
   b.size_max = 10;
   b.bit_size = 0; % Sum of the bits of the packets
   b.bits_to_send = 0; % bits required to send the next packet  
   b.has_one_pckt= false;
   for i=1:b.size_max
     b.buff(i) = packet();
   end
   b = class(b,'packet_buffer');
case 1
   % if single argument of class buffer, return it
   if (isa(varargin{1},'packet_buffer'))
      b = varargin{1}; 
   else
      b.size = 0;
      b.size_max = varargin{1};
      b.bit_size = 0;
      b.bits_to_send = 0;
      b.has_one_pckt= false;
      for i=1:b.size_max
         b.buff(i) = packet();
      end
      b = class(b,'packet_buffer');
   end
otherwise
   error('Wrong number of input arguments')
end