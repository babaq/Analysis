function w = rmspike(w,st,pret,post)
% rmspike.m
% 2011-10-12 by Zhang Li
% Remove wave spike leakage

for i = 1:length(st)
    tws = st(i)-pret:st(i)+post;
    tws(tws<1 | tws>length(w))=[];
    stws = w(tws(1));
    etws = w(tws(end));
    w(tws) = interp1([1 length(tws)],[stws etws],1:length(tws),'linear');
end
