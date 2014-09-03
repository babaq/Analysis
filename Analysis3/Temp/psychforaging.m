function [ result ] = psychforaging( block, varargin )
%PSYCHFORAGING Summary of this function goes here
%   Detailed explanation goes here

import Analysis.* Analysis.Base.* Analysis.Visualization.* Analysis.IO.VLabIO.*

if isa(block,'cell')
    result = batch(block,{'psychforaging'},{varargin});
    return;
end

p = inputParser;
addRequired(p,'block');
addParameter(p,'display','on');

parse(p,block,varargin{:});
block = p.Results.block;
display = p.Results.display;

%% Processing %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
cond = block.param.Condition;
cn = height(cond);
font = block.data.figontime;
fofft = block.data.figofftime;
cts = block.data.condtests;
cts0 = block.data.condtests0;
dn = block.param.FigNum;
iv = block.param.IndieVar;
civ = categorical(iv);
iv2c = block.param.IV2C;
datafile = block.param.DataFile;
vp = visprofile();
aci = find(block.param.ActiveChannel);
anyaci = aci(1);

data = cell(2,1);
if isempty(block.param.AnalysisParam.BadStatus{1})
    data{1}.valididx = block.data.valididx;
    data{1}.goodstatusidx = block.param.AnalysisParam.GoodStatusIndex;
    data{1}.badstatus = block.param.AnalysisParam.BadStatus;
    Organize(block,{'Early'});
    data{2}.valididx = block.data.valididx;
    data{2}.goodstatusidx = block.param.AnalysisParam.GoodStatusIndex;
    data{2}.badstatus = block.param.AnalysisParam.BadStatus;
else
    data{2}.valididx = block.data.valididx;
    data{2}.goodstatusidx = block.param.AnalysisParam.GoodStatusIndex;
    data{2}.badstatus = block.param.AnalysisParam.BadStatus;
    Organize(block,{''});
    data{1}.valididx = block.data.valididx;
    data{1}.goodstatusidx = block.param.AnalysisParam.GoodStatusIndex;
    data{1}.badstatus = block.param.AnalysisParam.BadStatus;
end

for i=1:2
    gctsn{i} = nnz(data{i}.goodstatusidx);
    vtidx = data{i}.valididx(:,:,anyaci);
    vt = font;
    vt(~vtidx)={[]};
    ivt{i} = iv2ct(vt,iv2c);
    
    ff{i} = cellfun(@(x)cell2mat(cellfun(@cell2mat,x,'uniformoutput',false)),...
        dimreduc(ivt{i},find(civ=='FIXFIGIDX')),'uniformoutput',false);
    ffdist{i} = cellfun(@(x)length(x)/gctsn{i},ff{i});
    
    fft0{i} = cellfun(@(x)cell2mat(cellfun(@cell2mat,x,'uniformoutput',false)),...
        dimreduc(ivt{i},find(civ=='FIXFIGIDX'),[find(civ=='FIXFIGTYPE'),1]),'uniformoutput',false);
    fft0dist{i} = cellfun(@(x)length(x)/gctsn{i},fft0{i});
    fft1{i} = cellfun(@(x)cell2mat(cellfun(@cell2mat,x,'uniformoutput',false)),...
        dimreduc(ivt{i},find(civ=='FIXFIGIDX'),[find(civ=='FIXFIGTYPE'),2]),'uniformoutput',false);
    fft1dist{i} = cellfun(@(x)length(x)/gctsn{i},fft1{i});
    fftdist{i} = [fft0dist{i} fft1dist{i}];
    
    fft0r{i} = cellfun(@(x)cell2mat(cellfun(@cell2mat,x,'uniformoutput',false)),...
        dimreduc(ivt{i},find(civ=='FIXFIGIDX'),[find(civ=='FIXFIGTYPE'),1;find(civ=='REWARDTYPE'),1]),'uniformoutput',false);
    fft0rdist{i} = cellfun(@(x)length(x)/gctsn{i},fft0r{i});
    fft0nr{i} = cellfun(@(x)cell2mat(cellfun(@cell2mat,x,'uniformoutput',false)),...
        dimreduc(ivt{i},find(civ=='FIXFIGIDX'),[find(civ=='FIXFIGTYPE'),1;find(civ=='REWARDTYPE'),2]),'uniformoutput',false);
    fft0nrdist{i} = cellfun(@(x)length(x)/gctsn{i},fft0nr{i});
    fft1r{i} = cellfun(@(x)cell2mat(cellfun(@cell2mat,x,'uniformoutput',false)),...
        dimreduc(ivt{i},find(civ=='FIXFIGIDX'),[find(civ=='FIXFIGTYPE'),2;find(civ=='REWARDTYPE'),2]),'uniformoutput',false);
    fft1rdist{i} = cellfun(@(x)length(x)/gctsn{i},fft1r{i});
    fft1nr{i} = cellfun(@(x)cell2mat(cellfun(@cell2mat,x,'uniformoutput',false)),...
        dimreduc(ivt{i},find(civ=='FIXFIGIDX'),[find(civ=='FIXFIGTYPE'),2;find(civ=='REWARDTYPE'),1]),'uniformoutput',false);
    fft1nrdist{i} = cellfun(@(x)length(x)/gctsn{i},fft1nr{i});
    fftrdist{i} = [fft0rdist{i} fft0nrdist{i} fft1rdist{i} fft1nrdist{i}];
    
    ffttrdist{i} = fft0rdist{i}+fft1rdist{i};
    ffttnrdist{i} = fft0nrdist{i}+fft1nrdist{i};
    ffrdist{i} = [ffttrdist{i} ffttnrdist{i}];
    
    if strcmp(display,'on')
        plotname = [datafile,'_BadStatus=',strjoin(data{i}.badstatus,','),'_FFDist'];
        newfig(plotname);
        
        subplot(2,2,1);
        bar(ffdist{i});
        t = sum(ffdist{i});
        if t~=1
            warning(['Distribution Sum: ',num2str(t),' ~= 1 in ffdist-',num2str(i)]);
        end
        
        subplot(2,2,2);
        bar(fftdist{i},'stacked');
        t = sum(sum(fftdist{i}));
        if t~=1
            warning(['Distribution Sum: ',num2str(t),' ~= 1 in fftdist-',num2str(i)]);
        end
        
        subplot(2,2,3);
        bar(fftrdist{i},'stacked');
        t = sum(sum(fftrdist{i}));
        if t~=1
            warning(['Distribution Sum: ',num2str(t),' ~= 1 in fftrdist-',num2str(i)]);
        end
        
        subplot(2,2,4);
        bar(ffrdist{i},'stacked');
        t = sum(sum(ffrdist{i}));
        if t~=1
            warning(['Distribution Sum: ',num2str(t),' ~= 1 in ffrdist-',num2str(i)]);
        end
        
    end
    
end

for i=1:size(cts0,1)
    ctsofcts0 = cts.condidx0 == cts0.condidx(i) & cts.trialidx0 == cts0.trialidx(i)...
        & cts.status ~= 'Early';
    fi = cond.FIXFIGIDX(cts.condidx(ctsofcts0));
    if ~isempty(fi) && length(fi)>1
        rep{i} = length(fi)-length(unique(fi));
    end
end
result.rep = cell2mat(rep);
vs = cts.status(cts.status ~= 'Early');
result.hitratio = nnz(vs == 'Hit')/length(vs);
result.hit0ratio = nnz(cts0.status == 'Hit')/size(cts0,1);
result.gctsn = gctsn;
result.gctsratio = gctsn{2}/gctsn{1};
result.ffdist = ffdist;
result.fftdist = fftdist;
result.fftrdist = fftrdist;
result.ffrdist = ffrdist;
result.param.DataFile = datafile;