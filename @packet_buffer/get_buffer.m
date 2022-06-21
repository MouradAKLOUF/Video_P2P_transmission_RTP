function val = get_buffer(a, propName)
% GET Get packet properties from the specified object
% and return the value
switch propName
case 'size'
   val = a.size;
case 'size_max'
   val = a.size_max;
case 'bit_size'
   val = a.bit_size;
case 'bits_to_send'
   val = a.bits_to_send;
    case 'buff'
         val = a.buff;
otherwise
   error([propName,' Is not a valid packet property'])
end