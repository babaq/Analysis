function [ cc ] = CombineC( c1,c2 )
%COMBINEC Combine two cells
import Analysis.Core.*

if isempty(c1)
    cc = c2;
elseif isempty(c2)
    cc = c1;
else
    cc = Cell();
    cc.channel = unique([c1.channel; c2.channel]);
    cc.sort = unique([c1.sort; c2.sort]);
    cc.aptimes = unique([c1.aptimes; c2.aptimes]);
end

end

