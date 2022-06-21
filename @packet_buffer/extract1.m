function [p,b] = extract1(b)
% [pack,buf] = extract(buf)
% Extracts a packet in the packet_buffer
% 
% [pack,buf] = extract(buf,bits)
% Extracts a given number of packets depending on the number of BITS extracted

if (nargin<1)
   error('Wrong number of input arguments')
end

% if (nargout<2)
%    error('Wrong number of output arguments')
% end

if (class(b)~='packet_buffer')
   error('First argument should be a buffer')
end

    % Extraction d'un paquet   
    if (b.size==0)
        warning('Packet buffer is empty');
        p=[];
    else
        p=b.buff(1);
        b.buff(1:end-1) = b.buff(2:end);
        b.buff(end) = packet();
        b.size = b.size-1;
        b.bit_size = b.bit_size - get(p,'size');
        
        if (b.size>0)
           b.bits_to_send = get(b.buff(1),'size');
        else
           b.bits_to_send = 0;
        end
                
        if (b.size>=1)
            b.has_one_pckt= true;
        else
            b.has_one_pckt= false;
        end
   
    end

    
    
    
    
    