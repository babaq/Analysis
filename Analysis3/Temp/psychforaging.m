function [  ] = psychforaging( block )
%PSYCHFORAGING Summary of this function goes here
%   Detailed explanation goes here

import Analysis.Base.*

cond = block.param.Condition;
cn = height(cond);
cts = block.data.condtests;
ctsn = height(cts);
dn = block.param.FigNum;
iv = block.param.IndieVar;
civ = categorical(iv);
iv2c = block.param.IV2C;

ivt = iv2ct(block.data.figontime,iv2c);

ff = cellfun(@(x)cell2mat(cellfun(@cell2mat,x,'uniformoutput',false)),...
    dimreduc(ivt,find(civ=='FIXFIGIDX')),'uniformoutput',false);
ffdist = cellfun(@(x)length(x)/ctsn,ff);
figure;
bar(ffdist);
sum(ffdist);

fft0 = cellfun(@(x)cell2mat(cellfun(@cell2mat,x,'uniformoutput',false)),...
    dimreduc(ivt,find(civ=='FIXFIGIDX'),[find(civ=='FIXFIGTYPE'),1]),'uniformoutput',false);
fft0dist = cellfun(@(x)length(x)/ctsn,fft0);
fft1 = cellfun(@(x)cell2mat(cellfun(@cell2mat,x,'uniformoutput',false)),...
    dimreduc(ivt,find(civ=='FIXFIGIDX'),[find(civ=='FIXFIGTYPE'),2]),'uniformoutput',false);
fft1dist = cellfun(@(x)length(x)/ctsn,fft1);
figure;
bar([fft0dist fft1dist],'stacked');
sum(sum([fft0dist fft1dist]))

fft0r = cellfun(@(x)cell2mat(cellfun(@cell2mat,x,'uniformoutput',false)),...
    dimreduc(ivt,find(civ=='FIXFIGIDX'),[find(civ=='FIXFIGTYPE'),1;find(civ=='REWARDTYPE'),1]),'uniformoutput',false);
fft0rdist = cellfun(@(x)length(x)/ctsn,fft0r);
fft0nr = cellfun(@(x)cell2mat(cellfun(@cell2mat,x,'uniformoutput',false)),...
    dimreduc(ivt,find(civ=='FIXFIGIDX'),[find(civ=='FIXFIGTYPE'),1;find(civ=='REWARDTYPE'),2]),'uniformoutput',false);
fft0nrdist = cellfun(@(x)length(x)/ctsn,fft0nr);
fft1r = cellfun(@(x)cell2mat(cellfun(@cell2mat,x,'uniformoutput',false)),...
    dimreduc(ivt,find(civ=='FIXFIGIDX'),[find(civ=='FIXFIGTYPE'),2;find(civ=='REWARDTYPE'),2]),'uniformoutput',false);
fft1rdist = cellfun(@(x)length(x)/ctsn,fft1r);
fft1nr = cellfun(@(x)cell2mat(cellfun(@cell2mat,x,'uniformoutput',false)),...
    dimreduc(ivt,find(civ=='FIXFIGIDX'),[find(civ=='FIXFIGTYPE'),2;find(civ=='REWARDTYPE'),1]),'uniformoutput',false);
fft1nrdist = cellfun(@(x)length(x)/ctsn,fft1nr);
figure;
bar([fft0rdist fft0nrdist fft1rdist fft1nrdist],'stacked');
sum(sum([fft0rdist fft0nrdist fft1rdist fft1nrdist]))
