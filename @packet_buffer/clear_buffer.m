function b_ = clear_buffer(b)
% read all pckts
p=[];
if (b.size==0)
    b_=b;
    return; %empty buff
else  
    for i=1:1:b.size
         p=[p, b.buff(i)];
    end
    
    for k=1:1:length(p)
        %[temp,b]=extract(b,  get( p(k), 'size') );
        [temp,b]=extract1(b );
    end
    b_=b;
    return; 
end