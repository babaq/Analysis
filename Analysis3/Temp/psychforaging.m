function [  ] = psychforaging( block )
%PSYCHFORAGING Summary of this function goes here
%   Detailed explanation goes here

import Analysis.Base.* Analysis.Visualization.*

cond = block.param.Condition;
cn = height(cond);
cts = block.data.condtests;
ctsn = height(cts);
cctsn = nnz(block.param.AnalysisParam.GoodStatusIndex);
badstatus = block.param.AnalysisParam.BadStatus;
block.data.vctsratio = cctsn/ctsn;
dn = block.param.FigNum;
iv = block.param.IndieVar;
civ = categorical(iv);
iv2c = block.param.IV2C;
datafile = block.param.DataFile;
vp = visprofile();

ivt = iv2ct(block.data.figontime,iv2c);
plotname = [datafile,'_BadStatus=',strjoin(badstatus,','),'_FFDist'];
newfig(plotname);

ff = cellfun(@(x)cell2mat(cellfun(@cell2mat,x,'uniformoutput',false)),...
    dimreduc(ivt,find(civ=='FIXFIGIDX')),'uniformoutput',false);
ffdist = cellfun(@(x)length(x)/cctsn,ff);
subplot(2,2,1);
bar(ffdist);
t = sum(ffdist);
if t~=1
    warning(['Distribution Sum: ',num2str(t),' ~= 1.']);
end

fft0 = cellfun(@(x)cell2mat(cellfun(@cell2mat,x,'uniformoutput',false)),...
    dimreduc(ivt,find(civ=='FIXFIGIDX'),[find(civ=='FIXFIGTYPE'),1]),'uniformoutput',false);
fft0dist = cellfun(@(x)length(x)/cctsn,fft0);
fft1 = cellfun(@(x)cell2mat(cellfun(@cell2mat,x,'uniformoutput',false)),...
    dimreduc(ivt,find(civ=='FIXFIGIDX'),[find(civ=='FIXFIGTYPE'),2]),'uniformoutput',false);
fft1dist = cellfun(@(x)length(x)/cctsn,fft1);
subplot(2,2,2);
dist = [fft0dist fft1dist];
bar(dist,'stacked');
t = sum(sum(dist));
if t~=1
    warning(['Distribution Sum: ',num2str(t),' ~= 1.']);
end

fft0r = cellfun(@(x)cell2mat(cellfun(@cell2mat,x,'uniformoutput',false)),...
    dimreduc(ivt,find(civ=='FIXFIGIDX'),[find(civ=='FIXFIGTYPE'),1;find(civ=='REWARDTYPE'),1]),'uniformoutput',false);
fft0rdist = cellfun(@(x)length(x)/cctsn,fft0r);
fft0nr = cellfun(@(x)cell2mat(cellfun(@cell2mat,x,'uniformoutput',false)),...
    dimreduc(ivt,find(civ=='FIXFIGIDX'),[find(civ=='FIXFIGTYPE'),1;find(civ=='REWARDTYPE'),2]),'uniformoutput',false);
fft0nrdist = cellfun(@(x)length(x)/cctsn,fft0nr);
fft1r = cellfun(@(x)cell2mat(cellfun(@cell2mat,x,'uniformoutput',false)),...
    dimreduc(ivt,find(civ=='FIXFIGIDX'),[find(civ=='FIXFIGTYPE'),2;find(civ=='REWARDTYPE'),2]),'uniformoutput',false);
fft1rdist = cellfun(@(x)length(x)/cctsn,fft1r);
fft1nr = cellfun(@(x)cell2mat(cellfun(@cell2mat,x,'uniformoutput',false)),...
    dimreduc(ivt,find(civ=='FIXFIGIDX'),[find(civ=='FIXFIGTYPE'),2;find(civ=='REWARDTYPE'),1]),'uniformoutput',false);
fft1nrdist = cellfun(@(x)length(x)/cctsn,fft1nr);
subplot(2,2,3);
dist = [fft0rdist fft0nrdist fft1rdist fft1nrdist];
bar(dist,'stacked');
t = sum(sum(dist));
if t~=1
    warning(['Distribution Sum: ',num2str(t),' ~= 1.']);
end
if block.data.vctsratio<1
    target = 'vffdist';
elseif ~isempty(badstatus{1})
    target = 'vffdist';
else
    target = 'ffdist';
end
block.data.(target) = dist;

fftrdist = fft0rdist+fft1rdist;
fftnrdist = fft0nrdist+fft1nrdist;
subplot(2,2,4);
dist = [fftrdist fftnrdist];
bar(dist,'stacked');
t = sum(sum(dist));
if t~=1
    warning(['Distribution Sum: ',num2str(t),' ~= 1.']);
end
