function display_buffer(a)
% DISPLAY(a) Display an packet_buffer object
stg = sprintf(...
   'Size: %d, size max: %d, bit size : %d, bits to send : %g\n',...
   a.size,a.size_max,a.bit_size,a.bits_to_send);
disp(stg)

if (a.size>0)
    for i=1:a.size
        display(a.buff(i))
    end
end