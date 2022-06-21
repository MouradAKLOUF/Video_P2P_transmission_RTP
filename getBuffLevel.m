function [recLevel, emiLevel]= getBuffLevel()

%%

global emission;
global reception;
global Dictionary;
global Num_Decoded_Imgs_; 
global Num_Encoded_Imgs_;
global Num_Imgs_;


%%

 if Num_Encoded_Imgs_> 0
         
     emiLevel_= getImglevelfromBuff(emission,Dictionary,Num_Decoded_Imgs_, Num_Encoded_Imgs_);
     recLevel_= getImglevelfromBuff(reception,Dictionary,Num_Decoded_Imgs_, Num_Encoded_Imgs_);

     %disp('********************')
     if Num_Decoded_Imgs_ > 0
        begin= Num_Decoded_Imgs_ +1;
     else
        begin= 1;
     end
    if Num_Decoded_Imgs_ >= Num_Imgs_
        begin= Num_Imgs_;
    end
     %fprintf('from img %d\n', begin);
     %fprintf('   to img %d\n', Num_Encod_Imgs_);
     emiLevel=sum(double(emiLevel_));
     recLevel=sum(double(recLevel_));
     %disp('********************')
     
 end
 
 
end