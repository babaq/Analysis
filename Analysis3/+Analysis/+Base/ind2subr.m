function [ sub ] = ind2subr( siz,ind )
%IND2SUBR Summary of this function goes here
%   Detailed explanation goes here

ind = Analysis.Base.cvector(ind);
dn = length(siz);
outs = 'i1';
for i=2:dn
    outs = [outs,',i',num2str(i)];
end

eval(['[',outs,'] = ind2sub(siz,ind);']);
sub = zeros(length(ind),dn);
for i=1:dn
    eval(['sub(:,i) = i',num2str(i),';']);
end

end

