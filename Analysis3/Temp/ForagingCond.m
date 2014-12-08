function [ fp,dots,dotrfidx,dotfigtype ] = ForagingCond( rfpos,or,isdprand,dprepn,...
    dotfigtypep,origin,rewardfigtype,rewardfigtypep,rewardfigtypen,dpn,filepath )
%FORAGINGCOND Summary of this function goes here
%   Detailed explanation goes here

import Analysis.Base.*

pushscale = 0;
fpor = 0.2;
figtypen = length(dotfigtypep);
rewardfigtypen = 1;
% [ dots,dotrfidx ] = RFPattern1_1( rfpos,isdprand,dprepn );
% [ dots,dotrfidx ] = RFPattern1_2( rfpos,isdprand );
dn = 10;
origin = arraypending(origin,figtypen,1);
israndrewardfigtype = length(rewardfigtype)>1;
randrewardfigtypeidx = drv(rewardfigtypep,dpn,true);

    function dps = getdp(dpnum,ori)
        for di=1:dpnum
            %     dotfigtype = Analysis.Base.drv(dotfigtypep,dn);
            dotfigtype = Analysis.Base.drv(dotfigtypep,dn,true);
            [ dots,dotrfidx ] = RFPattern1_3( rfpos,ori,origin,dotfigtype );
            [ fp,dots ] = randtransDP( dots,fpor,30, pushscale );
            %     plotDP(dots);
            
            if israndrewardfigtype
                crewardfigtype = rewardfigtype(randrewardfigtypeidx(di));
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
            dps{di,1} = ss{1};
            for i=2:length(ss)
                dps{di,1} = [dps{di,1},', ',ss{i}];
            end
        end
    end

% orientation( figure side flip )
cor0 = getdp(dpn,or);
cor1 = getdp(dpn,or+180);
o0 = arraypending({[', FT0OR',' ',num2str(or),', ','FT1OR',' ',num2str(or)]},dpn,1);
o1 = arraypending({[', FT0OR',' ',num2str(or+180),', ','FT1OR',' ',num2str(or+180)]},dpn,1);
co0 = cellfun(@(x,y)cat(2,x,y),cor0,o0,'uniformoutput',false);
co1 = cellfun(@(x,y)cat(2,x,y),cor1,o1,'uniformoutput',false);
c = [co0;co1];
% revert figure/background color
condn = size(c,1);
rev0 = arraypending({', REVCOL 0'},condn,1);
rev1 = arraypending({', REVCOL 1'},condn,1);
cr0 = cellfun(@(x,y)cat(2,x,y),c,rev0,'uniformoutput',false);
cr1 = cellfun(@(x,y)cat(2,x,y),c,rev1,'uniformoutput',false);
c = [cr0;cr1];

% write condition file
rf = ['_rf=(',num2str(rfpos(1)),',',num2str(rfpos(2)),')'];
if isdprand
    rf = [rf,'dpr'];
end
ori = ['_or=',num2str(or)];
if nnz(origin)>0
    os = '_origin=edge';
else
    os = '_origin=center';
end
ftp = ['_ftp=(',regexprep(num2str(dotfigtypep),'\s*',','),')'];
rft = ['_rft=(',regexprep(num2str(rewardfigtype),'\s*',','),')'];
rftp = ['_rftp=(',regexprep(num2str(rewardfigtypep),'\s*',','),')'];

condn = size(c,1);
ns = ['_',num2str(dpn),'-',num2str(condn)];
cfile = ['Foraging_',num2str(dn),rf,ori,os,ftp,rft,rftp,ns,'.vlc'];
fid = fopen(fullfile(filepath,cfile),'w');
for ci=1:condn
    fprintf(fid,'%s\r\n',c{ci,1});
end
fclose(fid);

end