function [ score ] = EM( x, y, Ot, Oi )

score = sum(sum(abs(cos(Ot-Oi(y:y+size(Ot,1)-1,x:x+size(Ot,2)-1)))))/sum(sum(Ot~=0));

end

