function [  ] = ForagingSubCond( block )
%FORAGINGSUBCOND Summary of this function goes here
%   Detailed explanation goes here

import Analysis.Core.* Analysis.Base.* Analysis.IO.VLabIO.*

dn = 10;
block.param.FigNum = dn;
bitn = 5;
bitarrayn = 6;
cts = block.data.condtests;
subparam = block.param.SubjectParam;
cond = block.param.Condition;
upd = subparam.UnitsPerDeg;
fixr = subparam.FPWinRad/upd;

% Organize Condition
cond.FPOS = [cond.FPOSH cond.FPOSV]/upd;
cond(:,{'FPOSH','FPOSV'}) = [];
rfidx = [];
figtype = [];
posx = [];
posy = [];
rmvar = [];
for i = 1:dn
    is = num2str(i);
    eval(['posx=[posx cond.POSX_',is,'];']);
    eval(['posy=[posy cond.POSY_',is,'];']);
    eval(['rfidx=[rfidx cond.PRFIDX_',is,'];']);
    eval(['figtype=[figtype cond.PFIGTYPE_',is,'];']);
    rmvar = [rmvar {['POSX_',is],['POSY_',is],['PRFIDX_',is],['PFIGTYPE_',is]}];
end
cond(:,rmvar) = [];
cond.RFIDX = rfidx;
cond.FIGTYPE = figtype;
cond.POSX = posx/upd;
cond.POSY = posy/upd;
ori = unique(cond.FT0OR,'stable');
block.param.Condition0 = cond;

% Get New Condition
iv = {'FIXFIGIDX','FIXFIGTYPE','RFFIGIDX','RFFIGTYPE','REWARDTYPE','ORFLIP','REVCOL'};
ivv = {(1:dn)',[0;1],(0:dn)',[-1;0;1],[0;1],[0;1],[0;1]};
newcond = orthocond(iv,ivv);

% Get SubCondition and Condtest Markers
block.data.condtests0 = block.data.condtests;
if subparam.MinFigFixDur ~= subparam.MaxFigFixDur
    error('Random FigFixDur Can Not Be Recovered!');
else
    figfixdur = subparam.MinFigFixDur;
end

newfigontime = [];
newfigofftime = [];
status0 = [];
trialidx0 = [];
condidx0 = [];
condidx = [];
status = [];
for i=1:height(cts)
    cc0idx = cts.condidx(i);
    ct0idx = cts.trialidx(i);
    cs0idx = cts.status(i);
    
    ffontime = cts.figfixontime{i};
    ffofftime = cts.figfixofftime{i};
    if isempty(ffontime)
        continue;
    end
    if length(ffontime)>length(ffofftime)
        if (cts.figofftime{i}(end)-ffontime(end)) >= figfixdur
            ffofftime(end+1,1) = ffontime(end)+figfixdur;
        else
            ffontime = ffontime(1:end-1);
        end
    end
    if isempty(ffontime)
        continue;
    end
    % Get Valid and Invalid FigFix
    ffn = length(ffontime);
    vffidx = (ffofftime-ffontime) >= figfixdur;
    ivffidx = find(~vffidx);
    vffidx = find(vffidx);
    vffontime = ffontime(vffidx);
    vffofftime = ffofftime(vffidx);
    vffn = length(vffontime);
    ivffontime = ffontime(ivffidx);
    ivffofftime = ffofftime(ivffidx);
    ivffn = length(ivffontime);
    
    % Get Valid FigFix Sequence
    vffseq = [];
    for j=1:3
        cv = cts.v(i,j);
        if cv==0
            break;
        else
            vffseq = [vffseq num2bitnnumarray(bitn,cv,bitarrayn)];
        end
    end
    vffseq = vffseq(vffseq>0);
    if length(vffseq) ~= vffn
        warning('Valid FigFixSequence Do Not Match Valid FigFixDuration.');
        disp(['Skipping Condition Test ',num2str(i),' ...']);
        continue;
    end
    
    % Get Invalid FigFix Sequence
    ivffseq = dn*ones(ivffn,1);
    [eptseg,idx] = cutst(block.data.eyepoint(:,1),ivffontime,ivffofftime);
    ep = cellfun(@(x)block.data.eyepoint(x,2:3),idx,'uniformoutput',false);
    for k=1:ivffn
        epk = ep{k};
        % Eliminate potentail slight figfixlost eyepoint tails
        if size(epk,1)>1
            epk = epk(1:floor(size(epk,1)/2),:);
        end
        for j=1:dn
            if inrange(epk,[cond.POSX(cc0idx,j) cond.POSY(cc0idx,j)],fixr)
                ivffseq(k,1) = j;
                break;
            end
        end
    end
    
    % Merge Valid and Invalid FigFix Sequence
    ffseq = zeros(ffn,1);
    ffseq(vffidx) = vffseq;
    ffseq(ivffidx) = ivffseq;
    if any(ivffseq==0)
        disp(i)
        disp(ivffseq')
        disp('_______________________')
    end
    
    % Get RF Figured/Blank Fix
    ffseqtype = cond.FIGTYPE(cc0idx,ffseq);
    ffrfseq = cond.RFIDX(cc0idx,ffseq);
    ffrfseqtype = -ones(ffn,1);
    ffrfseqtype(ffrfseq>0) = cond.FIGTYPE(cc0idx,ffrfseq(ffrfseq>0));
    
    % Map old to new conditions
    newcondidx = [];
    newstatus = [];
    for k=1:ffn
        cc = table(ffseq(k),ffseqtype(k),ffrfseq(k),ffrfseqtype(k),...
            cond.REWARDTYPE(cc0idx),double(cond.FT0OR(cc0idx)==ori(1)),cond.REVCOL(cc0idx),...
            'VariableNames',iv);
        [ccc,ccidx] = intersect(newcond,cc,'rows','stable');
        newcondidx = [newcondidx;ccidx];
        
        if any(k==ivffidx)
            cs = {'Early'};
        else
            if ffseq(k) == cond.REWARDIDX(cc0idx);
                cs = {'Hit'};
            else
                cs = {'Miss'};
            end
        end
        newstatus = [newstatus;categorical(cs)];
    end
    % Split SubConditionTest into new condtests
    newfigontime = [newfigontime;ffontime];
    newfigofftime = [newfigofftime;ffofftime];
    status0 = [status0;arraypending(cs0idx,ffn,1)];
    trialidx0 = [trialidx0;arraypending(ct0idx,ffn,1)];
    condidx0 = [condidx0;arraypending(cc0idx,ffn,1)];
    condidx = [condidx;newcondidx];
    status = [status;newstatus];
    
end

% Get existing conditions, new condition index and trial index
[uc,ia,ic] = unique(condidx,'rows','stable');
newcond = newcond(uc,:);
trialidx = zeros(size(condidx));
ucondidx = zeros(size(condidx));
ctn=[];
for i=1:length(uc)
    ucondidx(uc(i)==condidx)=i;
    
    ucidx = ic==i;
    tn = nnz(ucidx);
    trialidx(ucidx) = 1:tn;
    ctn = [ctn tn];
end
block.param.TrialN0 = block.param.TrialN;
block.param.TrialN = max(ctn);


newcts = table(condidx0,trialidx0,status0,ucondidx,trialidx,status,...
    num2cell(newfigontime),num2cell(newfigofftime),...
    'VariableNames',{'condidx0','trialidx0','status0','condidx','trialidx','status','figontime','figofftime'});
block.data.condtests = newcts;
block.param.Condition = newcond;

end