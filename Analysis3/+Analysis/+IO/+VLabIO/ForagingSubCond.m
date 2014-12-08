function [  ] = ForagingSubCond( block )
%FORAGINGSUBCOND Summary of this function goes here
%   Detailed explanation goes here

import Analysis.Core.* Analysis.Base.* Analysis.IO.VLabIO.*

t = strfind(block.name,'_');
fn = str2double(block.name(t(end)+1:end));
block.param.FigNum = fn;
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
for i = 1:fn
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
block.param.Condition0 = cond;

% New Condition
ori = unique(cond.FT0OR,'stable');
fs = {'FIXFIGIDX','FIXFIGTYPE','RFFIGIDX','RFFIGTYPE','REWARDTYPE','ORFLIP','REVCOL'};
newcond = table();

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
condrepeat0 = [];
condidx0 = [];
condtestidx0 = [];
status = [];
for i=1:height(cts)
    cc0idx = cts.condidx(i);
    cc0rep = cts.condrepeat(i);
    cc0sts = cts.status(i);
    
    ffontime = cts.figfixontime{i};
    ffofftime = cts.figfixofftime{i};
    if isempty(ffontime)
        disp(['No FigFix, Skipping Condition Test ',num2str(i),' ...']);
        continue;
    end
    if length(ffontime)>length(ffofftime)
        if (cts.figofftime{i}(end)-ffontime(end)) >= figfixdur
            disp(['Adding figofftime as Last ffofftime in Condition Test ',num2str(i),' ...']);
            ffofftime(end+1,1) = cts.figofftime{i}(end);
        else
            ffontime(end) = [];
        end
    end
    if isempty(ffontime)
        disp(['No FigFix, Skipping Condition Test ',num2str(i),' ...']);
        continue;
    end
    % Get Valid and Invalid FigFix
    ffn = length(ffontime);
    ffdur = ffofftime-ffontime;
    vffidx = ffdur >= figfixdur;
    ivffidx = find(~vffidx);
    vffidx = find(vffidx);
    vffn = length(vffidx);
    ivffn = length(ivffidx);
    vffontime = ffontime(vffidx);
    vffofftime = ffofftime(vffidx);
    ivffontime = ffontime(ivffidx);
    ivffofftime = ffofftime(ivffidx);
    
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
        disp('________________________');
        disp(['Valid FigFixSequence(',num2str(length(vffseq)),') Do Not Match Valid FigFixDuration(',num2str(vffn),').']);
        disp(['ffn = ',num2str(ffn)]);
        disp(['vffidx = ',num2str(rvector(vffidx))]);
        disp(['vffdur = ',num2str(rvector(ffdur(vffidx)))]);
        disp(['vffseq = ',num2str(rvector(vffseq))]);
        disp('Fall Back to EyePoint to Determine vffseq ...');
        
        vffseq = -ones(vffn,1);
        [eptseg,idx] = cutst(block.data.eyepoint(:,1),vffontime,vffofftime);
        ep = cellfun(@(x)block.data.eyepoint(x,2:3),idx,'uniformoutput',false);
        for k=1:vffn
            epk = ep{k};
            if isempty(epk)
                vffseq(k,1) = 0;
                continue;
            end
            % Eliminate possible figfixlost out-of-range eyepoint tail
            if size(epk,1)>1
                epk = epk(1:floor(size(epk,1)/2),:);
            end
            for j=1:fn
                if inrange(epk,[cond.POSX(cc0idx,j) cond.POSY(cc0idx,j)],fixr)
                    vffseq(k,1) = j;
                    break;
                end
            end
        end
        disp(['newvffseq = ',num2str(rvector(vffseq))]);
    end
    % Exclude No EyePoint and Can't Find FixFig in vffseq
    ivvi = vffseq<1;
    if any(ivvi)
        disp('________________________');
        disp(['Some(0/-1) Fix on Fig ',num2str(vffseq'),' in CondTest ',num2str(i),'.']);
        disp(['Skipping Condition Test ',num2str(i),' ...']);
        continue;
    end
    
    % Get Invalid FigFix Sequence
    ivffseq = -ones(ivffn,1);
    [eptseg,idx] = cutst(block.data.eyepoint(:,1),ivffontime,ivffofftime);
    ep = cellfun(@(x)block.data.eyepoint(x,2:3),idx,'uniformoutput',false);
    for k=1:ivffn
        epk = ep{k};
        if isempty(epk)
            ivffseq(k,1) = 0;
            continue;
        end
        % Eliminate possible figfixlost out-of-range eyepoint tail
        if size(epk,1)>1
            epk = epk(1:floor(size(epk,1)/2),:);
        end
        for j=1:fn
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
    
    % Exclude No EyePoint and Can't Find FixFig in ivffseq
    ivivi = ffseq<1;
    if any(ivivi)
        disp(['Excluding(0/-1) Some "Early" Fix on Fig ',num2str(ffseq'),' in CondTest ',num2str(i),'.']);
        ffseq = ffseq(~ivivi);
        ffontime = ffontime(~ivivi);
        ffofftime = ffofftime(~ivivi);
        ffn = length(ffontime);
        vffidx = (ffofftime-ffontime) >= figfixdur;
        ivffidx = find(~vffidx);
    end
    
    % Get Fix FigType and RF Seq/FigType
    ffseqtype = cond.FIGTYPE(cc0idx,ffseq);
    ffrfseq = cond.RFIDX(cc0idx,ffseq);
    ffrfseqtype = -ones(ffn,1);
    ffrfseqtype(ffrfseq>0) = cond.FIGTYPE(cc0idx,ffrfseq(ffrfseq>0));
    
    % get new conditions
    for k=1:ffn
        cc = table(ffseq(k),ffseqtype(k),ffrfseq(k),ffrfseqtype(k),...
            cond.REWARDTYPE(cc0idx),double(cond.FT0OR(cc0idx)==ori(1)),cond.REVCOL(cc0idx),...
            'VariableNames',fs);
        newcond = [newcond;cc];
        
        if any(k==ivffidx)
            cs = {'Early'};
        else
            % fallback eyepoint vffseq may contain =figfixdur
            % but not checked in task, so there may be more hit in a
            % condtest0 trial, but only the last hit is the real hit that gives
            % reward and ends the condtest0 trial.
            if ffseq(k) == cond.REWARDIDX(cc0idx);
                cs = {'Hit'};
            else
                cs = {'Miss'};
            end
        end
        status = [status;categorical(cs)];
    end
    % Merge SubConditionTest into new condtests
    newfigontime = [newfigontime;ffontime];
    newfigofftime = [newfigofftime;ffofftime];
    status0 = [status0;arraypending(cc0sts,ffn,1)];
    condrepeat0 = [condrepeat0;arraypending(cc0rep,ffn,1)];
    condidx0 = [condidx0;arraypending(cc0idx,ffn,1)];
    condtestidx0 = [condtestidx0;arraypending(i,ffn,1)];
end

% Get new conditions, new condition index and repeat
[unewcond,ia,condidx] = unique(newcond,'rows','stable');
condrepeat = zeros(size(condidx));
mr=0;
for i=1:height(unewcond)
    ucidx = condidx==i;
    rn = nnz(ucidx);
    condrepeat(ucidx) = 1:rn;
    mr = max(mr,rn);
end
block.param.MaxCondRepeated0 = block.param.MaxCondRepeated;
block.param.MaxCondRepeated = mr;

newcts = table(condtestidx0,condidx0,condrepeat0,status0,condidx,...
    condrepeat,status,num2cell(newfigontime),num2cell(newfigofftime),...
    'VariableNames',{'condtestidx0','condidx0','condrepeat0','status0',...
    'condidx','condrepeat','status','figontime','figofftime'});
block.data.condtests = newcts;
block.param.Condition = unewcond;

end