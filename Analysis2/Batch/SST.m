function si = SST(SBST,type,varargin)
% SST.m %
% 2011-04-09 by Zhang Li
% Statistics of Batched Size Tuning

if nargin<2
    type = 'si';
end
sn = size(SBST,1)-1;
stiend = 10;
vsn=1;
for i = 1:sn
    cur = SBST{i,1};
    sti = cur.sti;
    vsti = sti(sti<=stiend);
    vstin = length(vsti);
    isv = 0;
    
    switch type
        case 'fsi'
            sind = cur.sessionindex;
            chan = cur.ch;
            sort = cur.sortid;
            rsite = cur.site;
            cfr = SBST{i,2};
            sfit = cur.curvefit;
            sfitg = cur.goodness.adjrsquare;
            ffit = cfr.wtc.curvefit;
            ffitg = cfr.wtc.goodness.adjrsquare;
            if 1%sfitg>0.1 && ffitg>0.1
                
                sfitc = coeffvalues(sfit);
                sfitcb = confint(sfit,0.95);
                sre = sfitc(end-1);
                sri = sfitc(end);
                sfg = sfitg;
                ffitc = coeffvalues(ffit);
                ffitcb = confint(ffit,0.95);
                fre = ffitc(end-1);
                fri = ffitc(end);
                ffg = ffitg;
                [ssi smax smin shw]=FSI(sfit,sti,stiend);
                stc = cur.mtc(1:vstin);
                [fsi fmax fmin fhw]=FSI(ffit,sti,stiend);
                ftc = cfr.wtc.mtc(1:vstin);
                isv =1;
            else
                %                 [curvefit,goodness,fitinfo] = SizeTuningFit(sti,cur.mtc,'dog');
                %                 disp(['original: ',num2str(sfitg),' new: ',num2str(goodness.adjrsquare)]);
                %                 [curvefit,goodness,fitinfo] = SizeTuningFit(sti,cfr.wtc.mtc,'dog');
                %                 disp(['original: ',num2str(ffitg),' new: ',num2str(goodness.adjrsquare)]);
                %                 disp(['Session ',num2str(cur.sessionindex)])
            end
            if isfield(cur,'sctc')
                scfit = cur.sctc.curvefit;
                scfitg = cur.sctc.goodness.adjrsquare;
                
                scfitc = coeffvalues(scfit);
                scfitcb = confint(scfit,0.95);
                scre = scfitc(end-1);
                scri = scfitc(end);
                scfg = scfitg;
                [scsi scmax scmin schw]=FSI(scfit,sti,stiend);
                sctc = cur.sctc.mtc(1:vstin);
                isv =1;
            end
        case 'fsc'
            if isfield(cur,'sctc')
                sfit = cur.curvefit;
                sfitg = cur.goodness.adjrsquare;
                scfit = cur.sctc.curvefit;
                scfitg = cur.sctc.goodness.adjrsquare;
                
                sfitc = coeffvalues(sfit);
                sfitcb = confint(sfit,0.95);
                sre = sfitc(end-1);
                sri = sfitc(end);
                sfg = sfitg;
                scfitc = coeffvalues(scfit);
                scfitcb = confint(scfit,0.95);
                scre = scfitc(end-1);
                scri = scfitc(end);
                scfg = scfitg;
                [ssi smax smin]=FSI(sfit,sti,stiend);
                [scsi scmax scmin]=FSI(scfit,sti,stiend);
                isv =1;
            end
        case 'wps'
            cfr = SBST{i,2};
            %             ps = cfr.wps.data';
            tps = cfr.wps.wps;
            tttps = [];
            for t = 1:size(tps,1)
                ttps = squeeze(tps(t,:,:))';
                tttps = cat(3,tttps,cn(ttps,'r'));
            end
            ps = mean(tttps,3);
            ps = ps(:,1:vstin);
            f = cfr.wps.frequencies;
            fn = length(f);
            %             if fn>4295%3222
            %                 df = f;
            %             else
            %                 ps = interp1(f,ps,df,'spline');
            %             end
            if fn>4295%3222
                ps = ps(1:2:end,:);
            else
                df = f;
            end
            power(i,:,:) = ps;
            powerac(i,:,:) = ps;
            powerrc(i,:,:) = ps;
            %             power(i,:,:) = cn(ps,'n');
            %             powerac(i,:,:) = cn(ps,'an');
            %             powerrc(i,:,:) = cn(ps,'r');
        case 'scps'
            if isfield(cur,'scps')
                ps = cur.scps.data';
                ps = ps(:,1:vstin);
                f = cur.scps.frequencies;
                                if length(f)>3222
                                    df = f;
                                else
                                    ps = interp1(f,ps,df,'spline');
                                end
%                 if length(f)>3222
%                     ps = ps(1:2:end,:);
%                 else
%                     df = f;
%                 end
                p = ps; %cn(ps,'n');
                pac = cn(ps,'a');
                prc = cn(ps,'r');
                isv = 1;
            end
        case 'sfc'
            cs = cur.data';
            cs = cs(:,1:vstin);
            ps = cur.phase';
            ps = ps(:,1:vstin);
            f = cur.frequencies;
            fn = length(f);
            if fn>3222
                cs = cs(1:2:fn,:);
                ps = ps(1:2:fn,:);
            else
                df = f;
            end
            coherence(i,:,:) = cs;
            coherenceac(i,:,:) = cn(cs,'a');
            coherencerc(i,:,:) = cn(cs,'r');
            phase(i,:,:) = ps;
            phaseac(i,:,:) = cn(pha2con(ps),'a');
            phaserc(i,:,:) = cn(pha2con(ps),'r');
            sessionindex(i) = cur.sessionindex;
            ch(i) = cur.ch;
            sortid(i) = cur.sortid;
        case 'sc'
            if isfield(cur,'sctc')
                ssi = cur.si(1);
                smax = cur.si(2);
                smin = cur.si(3);
                sre = smax;
                sri = smin;
                stc = cur.mtc(1:vstin);
                scsi = cur.sctc.si(1);
                scmax = cur.sctc.si(2);
                scmin = cur.sctc.si(3);
                scre = scmax;
                scri = scmin;
                sctc = cur.sctc.mtc(1:vstin);
                sfg = 0;
                scfg = 0;
                isv = 1;
            end
        case 'su'
            ssd = cur.spikeduration;
            shsw = cur.halfspikewidth;
            shasw = cur.halfafterspikewidth;
            sar = cur.amplituderatio;
            ssw = cur.meanspikewave;
            sssw = cur.smoothspikewave;
            sind = cur.sessionindex;
            chan = cur.ch;
            sort = cur.sortid;
            isv = 1;
        otherwise
            cfr = SBST{i,2};
            ssi = cur.si(1);
            smax = cur.si(2);
            smin = cur.si(3);
            sre = smax;
            sri = smin;
            %%%%%%%%%%%%%%%
            tc = cur.tc;
            for t = 1:size(tc,1)
                tc(t,:) = cn(tc(t,:),'an');
            end
            stc = fmean2(tc);
            [ssi smax smin shw] = SI(stc,sti);
            stc = stc(1:vstin);
            %%%%%%%%%%%%%%%
%                         stc = cur.mtc(1:vstin);
            fsi = cfr.wtc.si(1);
            fmax = cfr.wtc.si(2);
            fmin = cfr.wtc.si(3);
            fre = fmax;
            fri = fmin;
            %%%%%%%%%%%%%%
            tc = cfr.wtc.tc;
            for t = 1:size(tc,1)
                tc(t,:) = cn(tc(t,:),'an');
            end
            ftc = fmean2(tc);
            [fsi fmax fmin fhw] = SI(ftc,sti);
            ftc = ftc(1:vstin);
            %%%%%%%%%%%%%%
%                         ftc = cfr.wtc.mtc(1:vstin);
            sfg = 0;
            ffg = 0;
            if isfield(cur,'sctc')
                scsi = cur.sctc.si(1);
                scmax = cur.sctc.si(2);
                scmin = cur.sctc.si(3);
                scre = scmax;
                scri = scmin;
                %%%%%%%%%%%
                tc = cur.sctc.tc;
                for t = 1:size(tc,1)
                    tc(t,:) = cn(tc(t,:),'an');
                end
                sctc = fmean2(tc);
                try
                [scsi scmax scmin schw] = SI(sctc,sti);
                catch err
                    continue;
                end
                sctc = sctc(1:vstin);
                %%%%%%%%%%%%%%%%
%                                 sctc = cur.sctc.mtc(1:vstin);
                scfg = 0;
            end
            sind = cur.sessionindex;
            chan = cur.ch;
            sort = cur.sortid;
            rsite = cur.site;
            isv = 1;
    end
    
    if isv
        switch type
            case 'scps'
                power(vsn,:,:) = p;
                powerac(vsn,:,:) = pac;
                powerrc(vsn,:,:) = prc;
            case {'sc','fsc'}
                sis(vsn) = ssi;
                maxs(vsn) = smax;
                mins(vsn) = smin;
                res(vsn) = sre;
                ris(vsn) = sri;
                tcs(vsn,:) = cn(stc,'an');
                sisc(vsn) = scsi;
                maxsc(vsn) = scmax;
                minsc(vsn) = scmin;
                resc(vsn) = scre;
                risc(vsn) = scri;
                tcsc(vsn,:) = cn(sctc,'an');
                fgs(vsn) = sfg;
                fgsc(vsn) = scfg;
            case 'su'
                sds(vsn) = ssd;
                hsws(vsn) = shsw;
                hasws(vsn) = shasw;
                ars(vsn) = sar;
                sws(vsn,:) = ssw';
                ssws(vsn,:) = sssw';
                sessionindex(vsn) = sind;
                ch(vsn) = chan;
                sortid(vsn) = sort;
            otherwise
                sis(vsn) = ssi;
                maxs(vsn) = smax;
                mins(vsn) = smin;
                hws(vsn) = shw;
                res(vsn) = sre;
                ris(vsn) = sri;
                %                 tcs(vsn,:) = stc;
                tcs(vsn,:) = cn(stc,'an');
                fgs(vsn) = sfg;
                
                sif(vsn) = fsi;
                maxf(vsn) = fmax;
                minf(vsn) = fmin;
                hwf(vsn) = fhw;
                ref(vsn) = fre;
                rif(vsn) = fri;
                %                 tcf(vsn,:) = ftc;
                tcf(vsn,:) = cn(ftc,'an');
                fgf(vsn) = ffg;
                
                sisc(vsn) = scsi;
                maxsc(vsn) = scmax;
                minsc(vsn) = scmin;
                hwsc(vsn) = schw;
                resc(vsn) = scre;
                risc(vsn) = scri;
                %                 tcsc(vsn,:) = sctc;
                tcsc(vsn,:) = cn(sctc,'an');
                fgsc(vsn) = scfg;
                
                sessionindex(vsn) = sind;
                ch(vsn) = chan;
                sortid(vsn) = sort;
                site(vsn) = rsite;
        end
        vsn = vsn+1;
    end
    
    clear ps;
end

switch type
    case {'wps','scps'}
        si.power = power;
        si.ps = squeeze(mean(power,1));
        si.sd = squeeze(std(power,0,1));
        si.se = si.sd/sqrt(size(power,1));
        si.powerac = powerac;
        si.psac = squeeze(mean(powerac,1));
        si.sdac = squeeze(std(powerac,0,1));
        si.seac = si.sdac/sqrt(size(powerac,1));
        si.powerrc = powerrc;
        si.psrc = squeeze(mean(powerrc,1));
        si.sdrc = squeeze(std(powerrc,0,1));
        si.serc = si.sdrc/sqrt(size(powerrc,1));
        si.frequencies = df;
        si.sti = vsti;
    case 'sfc'
        if nargin>2
            suidx = varargin{1};
            coherence = coherence(suidx,:,:);
            phase = phase(suidx,:,:);
        end
        si.coherence = coherence;
        si.cs = squeeze(mean(coherence,1));
        si.se = squeeze(ste(coherence,0,1));
        si.coherenceac = coherenceac;
        si.csac = squeeze(mean(coherenceac,1));
        si.seac = squeeze(ste(coherenceac,0,1));
        si.coherencerc = coherencerc;
        si.csrc = squeeze(mean(coherencerc,1));
        si.serc = squeeze(ste(coherencerc,0,1));
        
        si.phase = phase;
        si.p = circ_rtest3d(phase);
        mu = circ_mean(phase,[],1);
        si.ps = squeeze(mu);
        [s s0] = circ_std(phase,[],[],1);
        si.psd = squeeze(s0);
        si.phaseac = phaseac;
        si.psac = squeeze(mean(phaseac,1));
        si.pseac = squeeze(ste(phaseac,0,1));
        si.phaserc = phaserc;
        si.psrc = squeeze(mean(phaserc,1));
        si.pserc = squeeze(ste(phaserc,0,1));
        
        si.frequencies = df;
        si.sti = vsti;
        si.sessionindex = sessionindex;
        si.ch = ch;
        si.sortid = sortid;
        type = SBST{end,1}.sfctype;
    case {'sc','fsc'}
        si.sis = sis;
        si.maxs = maxs;
        si.mins = mins;
        si.res = res;
        si.ris = ris;
        si.tcs = tcs;
        si.mtcs = mean(tcs,1);
        si.tcses = ste(tcs,0,1);
        si.sisc = sisc;
        si.maxsc = maxsc;
        si.minsc = minsc;
        si.resc = resc;
        si.risc = risc;
        si.tcsc = tcsc;
        si.mtcsc = mean(tcsc,1);
        si.tcsesc = ste(tcsc,0,1);
        si.fgs = fgs;
        si.fgsc = fgsc;
        si.bin = (0:0.1:1);
        si.sti = vsti;
    case 'su'
        si.sd = sds;
        si.hsw = hsws;
        si.hasw = hasws;
        si.ar = ars;
        si.sw = sws;
        si.ssw = ssws;
        si.sessionindex = sessionindex;
        si.ch = ch;
        si.sortid = sortid;
    otherwise
        si.sis = sis;
        si.maxs = maxs;
        si.mins = mins;
        si.hws = hws;
        si.res = res;
        si.ris = ris;
        si.tcs = tcs;
        si.mtcs = mean(tcs,1);
        si.tcses = ste(tcs,0,1);
        si.fgs = fgs;
        
        si.sif = sif;
        si.maxf = maxf;
        si.minf = minf;
        si.hwf = hwf;
        si.ref = ref;
        si.rif = rif;
        si.tcf = tcf;
        si.mtcf = mean(tcf,1);
        si.tcsef = ste(tcf,0,1);
        si.fgf = fgf;
        
        si.sisc = sisc;
        si.maxsc = maxsc;
        si.minsc = minsc;
        si.hwsc = hwsc;
        si.resc = resc;
        si.risc = risc;
        si.tcsc = tcsc;
        si.mtcsc = mean(tcsc,1);
        si.tcsesc = ste(tcsc,0,1);
        si.fgsc = fgsc;
        
        si.sessionindex = sessionindex;
        si.ch = ch;
        si.sortid = sortid;
        si.site = site;
        si.bin = (0:0.1:1);
        si.sti = vsti;
end

si.info = SBST{end,1};
si.info.stiend = stiend;
si.info.ssttype = type;
