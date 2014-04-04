function [ fp,dots,dotrfidx,dotfigtype,rfigidx ] = ForagingCond( rfpos,isdprand,dprepn,...
    dotfigtypep,rewardfigtype,rewardfigtypep,rewardfigtypen,condn,filepath )
%FORAGINGCOND Summary of this function goes here
%   Detailed explanation goes here

rewardfigtypen = 1;
% [ dots,dotrfidx ] = RFPattern1_1( rfpos,isdprand,dprepn );
[ dots,dotrfidx ] = RFPattern1_2( rfpos,isdprand );
dn = length(dots);
israndrewardfigtype = length(rewardfigtype)>1;
randrewardfigtypeidx = Analysis.Base.drv(rewardfigtypep,condn,true);
for cidx=1:condn
    [ fp,dots ] = randtransDP( dots,0.5,0.1 );
    %     plotDP(dots);
    %     dotfigtype = Analysis.Base.drv(dotfigtypep,dn);
    dotfigtype = Analysis.Base.drv(dotfigtypep,dn,true);
    if israndrewardfigtype
        crewardfigtype = rewardfigtype(randrewardfigtypeidx(cidx));
    else
        crewardfigtype = rewardfigtype;
    end
    rfigidx = rewardfig(dotfigtype,crewardfigtype,rewardfigtypen);
    for i=1:dn
        s{i,1} = ['POSX_',num2str(i),' ',num2str(dots(i,1))];
        s{i,2} = ['POSY_',num2str(i),' ',num2str(dots(i,2))];
        s{i,3} = ['PRFIDX_',num2str(i),' ',num2str(dotrfidx(i))];
        s{i,4} = ['PFIGTYPE_',num2str(i),' ',num2str(dotfigtype(i)-1)];
    end
    
    ss = reshape(s,1,[]);
    ss = [{['FPOSH',' ',num2str(fp(1)),', ','FPOSV',' ',num2str(fp(2))]} ss];
    ss{1,end+1} = ['REWARDTYPE',' ',num2str(crewardfigtype-1)];
    ss{1,end+1} = ['REWARDIDX',' ',num2str(find(rfigidx == 1))];
    c{cidx,1} = ss{1};
    for i=2:length(ss)
        c{cidx,1} = [c{cidx,1},', ',ss{i}];
    end
    
end

rf = ['_rf=(',num2str(rfpos(1)),',',num2str(rfpos(2)),')'];
if isdprand
    rf = [rf,'dpr'];
end
ftp = ['_ftp=(',regexprep(num2str(dotfigtypep),'\s*',','),')'];
rft = ['_rft=(',regexprep(num2str(rewardfigtype),'\s*',','),')'];
rftp = ['_rftp=(',regexprep(num2str(rewardfigtypep),'\s*',','),')'];


cfile = ['Foraging_',num2str(dn),rf,ftp,rft,rftp,'_',num2str(condn),'.vlc'];
fid = fopen(fullfile(filepath,cfile),'w');
for cidx=1:condn
    fprintf(fid,'%s\r\n',c{cidx,1});
end
fclose(fid);

end