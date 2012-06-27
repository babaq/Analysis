function dt = SDG(SBDG,type,varargin)
% SDG.m %
% 2011-04-09 by Zhang Li
% Statistics of Batched Drift Grating

if nargin<2
    type = 'dt';
end
sn = size(SBDG,1)-1;
stin = SBDG{end,1}.stin;
vsn=1;
for i = 1:sn
    cur = SBDG{i,1};
    sti = cur.sti;
    vsti = sti(sti<=stin);
    vstin = length(vsti);
    isv = 0;
    
    switch type
        case 'fsi'
            sind = cur.sessionindex;
            chan = cur.ch;
            sort = cur.sortid;
            rsite = cur.site;
            cfr = SBDG{i,2};
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
                [ssi smax smin]=FSI(sfit,sti,stin);
                stc = cur.mtc(1:vstin);
                [fsi fmax fmin]=FSI(ffit,sti,stin);
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
                [scsi scmax scmin]=FSI(scfit,sti,stin);
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
                [ssi smax smin]=FSI(sfit,sti,stin);
                [scsi scmax scmin]=FSI(scfit,sti,stin);
                isv =1;
            end
        case 'wps'
            cfr = SBDG{i,2};
            ps = cfr.wps.data';
            pse = cfr.wps.se';
            ps = ps(:,1:vstin);
            pse = pse(:,1:vstin);
            f = cfr.wps.frequencies;
            fn = length(f);
            if fn>4295%3222
                df = f;
            else
                ps = interp1(f,ps,df,'spline');
                pse = interp1(f,pse,df,'spline');
            end
            power(i,:,:) = cn(ps,'n');
            powerac(i,:,:) = cn(ps,'an');
            powerrc(i,:,:) = cn(ps,'r');
        case 'scps'
            if isfield(cur,'scps')
                ps = cur.scps.data';
                pse = cur.scps.se';
                ps = ps(:,1:vstin);
                pse = pse(:,1:vstin);
                f = cur.scps.frequencies;
                if length(f)>3222 %==2458
                    df = f;
                else
                    ps = interp1(f,ps,df,'spline');
                    pse = interp1(f,pse,df,'spline');
                end
                p = ps; %cn(ps,'n');
                pac = cn(ps,'an');
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
                ssi = cur.dt(1);
                smax = cur.dt(2);
                smin = cur.dt(3);
                sre = smax;
                sri = smin;
                stc = cur.mtc(1:vstin);
                scsi = cur.sctc.dt(1);
                scmax = cur.sctc.dt(2);
                scmin = cur.sctc.dt(3);
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
            cfr = SBDG{i,2};
            ssi = cur.dt(1);
            smax = cur.dt(2);
            smin = cur.dt(3);
            sre = smax;
            sri = smin;
            stc = cur.mtc(1:vstin);
            fsi = cfr.wtc.dt(1);
            fmax = cfr.wtc.dt(2);
            fmin = cfr.wtc.dt(3);
            fre = fmax;
            fri = fmin;
            ftc = cfr.wtc.mtc(1:vstin);
            sfg = 0;
            ffg = 0;
            if isfield(cur,'sctc')
                scsi = cur.sctc.dt(1);
                scmax = cur.sctc.dt(2);
                scmin = cur.sctc.dt(3);
                scre = scmax;
                scri = scmin;
                sctc = cur.sctc.mtc(1:vstin);
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
                res(vsn) = sre;
                ris(vsn) = sri;
                tcs(vsn,:) = cn(stc,'an');
                sif(vsn) = fsi;
                maxf(vsn) = fmax;
                minf(vsn) = fmin;
                ref(vsn) = fre;
                rif(vsn) = fri;
                tcf(vsn,:) = cn(ftc,'an');
                fgs(vsn) = sfg;
                fgf(vsn) = ffg;
                
                sisc(vsn) = scsi;
                maxsc(vsn) = scmax;
                minsc(vsn) = scmin;
                resc(vsn) = scre;
                risc(vsn) = scri;
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
        dt.power = power;
        dt.ps = squeeze(mean(power,1));
        dt.sd = squeeze(std(power,0,1));
        dt.se = dt.sd/sqrt(size(power,1));
        dt.powerac = powerac;
        dt.psac = squeeze(mean(powerac,1));
        dt.sdac = squeeze(std(powerac,0,1));
        dt.seac = dt.sdac/sqrt(size(powerac,1));
        dt.powerrc = powerrc;
        dt.psrc = squeeze(mean(powerrc,1));
        dt.sdrc = squeeze(std(powerrc,0,1));
        dt.serc = dt.sdrc/sqrt(size(powerrc,1));
        dt.frequencies = df;
        dt.sti = vsti;
    case 'sfc'
        if nargin>2
            suidx = varargin{1};
            coherence = coherence(suidx,:,:);
            phase = phase(suidx,:,:);
        end
        dt.coherence = coherence;
        dt.cs = squeeze(mean(coherence,1));
        dt.se = squeeze(ste(coherence,0,1));
        dt.coherenceac = coherenceac;
        dt.csac = squeeze(mean(coherenceac,1));
        dt.seac = squeeze(ste(coherenceac,0,1));
        dt.coherencerc = coherencerc;
        dt.csrc = squeeze(mean(coherencerc,1));
        dt.serc = squeeze(ste(coherencerc,0,1));
        
        dt.phase = phase;
        dt.p = circ_rtest3d(phase);
        mu = circ_mean(phase,[],1);
        dt.ps = squeeze(mu);
        [s s0] = circ_std(phase,[],[],1);
        dt.psd = squeeze(s0);
        dt.phaseac = phaseac;
        dt.psac = squeeze(mean(phaseac,1));
        dt.pseac = squeeze(ste(phaseac,0,1));
        dt.phaserc = phaserc;
        dt.psrc = squeeze(mean(phaserc,1));
        dt.pserc = squeeze(ste(phaserc,0,1));
        
        dt.frequencies = df;
        dt.sti = vsti;
        dt.sessionindex = sessionindex;
        dt.ch = ch;
        dt.sortid = sortid;
        type = SBDG{end,1}.sfctype;
    case {'sc','fsc'}
        dt.sis = sis;
        dt.maxs = maxs;
        dt.mins = mins;
        dt.res = res;
        dt.ris = ris;
        dt.tcs = tcs;
        dt.mtcs = mean(tcs,1);
        dt.tcses = ste(tcs,0,1);
        dt.sisc = sisc;
        dt.maxsc = maxsc;
        dt.minsc = minsc;
        dt.resc = resc;
        dt.risc = risc;
        dt.tcsc = tcsc;
        dt.mtcsc = mean(tcsc,1);
        dt.tcsesc = ste(tcsc,0,1);
        dt.fgs = fgs;
        dt.fgsc = fgsc;
        dt.bin = (0:0.1:1);
        dt.sti = vsti;
    case 'su'
        dt.sd = sds;
        dt.hsw = hsws;
        dt.hasw = hasws;
        dt.ar = ars;
        dt.sw = sws;
        dt.ssw = ssws;
        dt.sessionindex = sessionindex;
        dt.ch = ch;
        dt.sortid = sortid;
    otherwise
        dt.sis = sis;
        dt.maxs = maxs;
        dt.mins = mins;
        dt.res = res;
        dt.ris = ris;
        dt.tcs = tcs;
        dt.mtcs = mean(tcs,1);
        dt.tcses = ste(tcs,0,1);
        dt.sif = sif;
        dt.maxf = maxf;
        dt.minf = minf;
        dt.ref = ref;
        dt.rif = rif;
        dt.tcf = tcf;
        dt.mtcf = mean(tcf,1);
        dt.tcsef = ste(tcf,0,1);
        dt.fgs = fgs;
        dt.fgf = fgf;
        
        dt.sisc = sisc;
        dt.maxsc = maxsc;
        dt.minsc = minsc;
        dt.resc = resc;
        dt.risc = risc;
        dt.tcsc = tcsc;
        dt.mtcsc = mean(tcsc,1);
        dt.tcsesc = ste(tcsc,0,1);
        dt.fgsc = fgsc;
        
        dt.sessionindex = sessionindex;
        dt.ch = ch;
        dt.sortid = sortid;
        dt.site = site;
        dt.bin = (0:0.1:1);
        dt.sti = vsti;
end

dt.info = SBDG{end,1};
dt.info.ssttype = type;
