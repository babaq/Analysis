function ci = SCS(SBCS,type,varargin)
% SCS.m %
% 2012-04-09 by Zhang Li
% Statistics of Batched CenterSurround


sn = size(SBCS,1)-1;
vsn=1;
tcs = [];
tcf = [];
tcsc = [];
oosurs = [];
oosurf = [];
oosursc = [];
suros = [];
surof = [];
surosc = [];
surocns = [];
surocnf = [];
surocnsc = [];
for i = 1:sn
    cur = SBCS{i,1};
    sti = cur.sti;
    c1 = sti{1}';
    c2 = sti{2};
    ox = ctcshift(c1,2);
    ox(ox>90) = ox(ox>90)-180;
    ox(1) = -90;
    isv = 0;
    
    switch type
        case 'fsi'
            sind = cur.sessionindex;
            chan = cur.ch;
            sort = cur.sortid;
            rsite = cur.site;
            cfr = SBCS{i,2};
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
                [ssi smax smin]=FSI(sfit,sti,stiend);
                stc = cur.mtc(1:vstin);
                [fsi fmax fmin]=FSI(ffit,sti,stiend);
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
                [scsi scmax scmin]=FSI(scfit,sti,stiend);
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
            cfr = SBCS{i,2};
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
            cfr = SBCS{i,2};
            %%%%%%%%%% trial normalized average %%%%%%%%%
            stc = cur.tc;
            ftc = cfr.wtc.tc;
            for t = 1:size(stc,1)
                stc(t,:,:) = cn(stc(t,:,:),'n');
                ftc(t,:,:) = cn(ftc(t,:,:),'n');
            end
            stc = squeeze(mean(stc));
            ftc = squeeze(mean(ftc));
            %%%%%%%%%%%%%%%%%%%%%%&&&&&&&&&&&&&&&&&&&&&&&
%             stc = cur.mtc;
%             ftc = cfr.wtc.mtc;
            %%%%%%%%% Optimal Orientation %%%%%%%%%%
            ooi = find(stc(:,1)==max(stc(2:end,1)));
            if length(ooi)>1
                ooi = ooi(1);
                disp('bad spike tuning, no single optimal orientation.');
            end
            oos = c1(ooi);
            ooif = find(ftc(:,1)==max(ftc(2:end,1)));
            if length(ooif)>1
                ooif = ooif(1);
                disp('bad wave tuning, no single optimal orientation.');
            end
            oof = c1(ooif);
            %%%%%%%%%% Spike %%%%%%%%%%%
            %          opmorisurs = cn(stc(ooi,:),'n');
            
            temp = stc;
            for o = 1:length(sti{1})
                temp(o,:) = cn(stc(o,:),'n');
            end
            opmorisurs = cn(mean(temp(1:end,:)),'n');
%             opmorisurs = mean(temp(1:end,:));
            
            temp = stc;
            for o = 1:length(sti{2})
                temp(:,o) = cn(stc(:,o),'n');
                surcvs(:,o) = CV(stc(2:end,o)',deg2rad(c1(2:end)'));
            end
            suroris = ctcshift(temp,ooi);
            suroricns = cn(suroris,'a');
            orits = suroris(:,1);
            orits(1) = orits(end);
            [curvefit,goodness,fitinfo]=OriFit(ox,orits);
            fcs = coeffvalues(curvefit);
            tt = oos+fcs(2);
            tt(tt<0) = tt(tt<0)+180;
            tt(tt>180) = tt(tt>180)-180;
            forits = [tt fcs(3) goodness.adjrsquare];
            
            
            stc = cn(cur.mtc,'n');
            stc = ctcshift(stc,ooi);
            
            %%%%%%%%%%%%% Wave %%%%%%%%%%%%%
             %           opmorisurf = cn(ftc(ooi,:),'n');
            
            temp = ftc;
            for o = 1:length(sti{1})
                temp(o,:) = cn(ftc(o,:),'n');
            end
            opmorisurf = cn(mean(temp(1:end,:)),'n');
%             opmorisurf = mean(temp(1:end,:));
            
            temp = ftc;
            for o = 1:length(sti{2})
                temp(:,o) = cn(ftc(:,o),'n');
                surcvf(:,o) = CV(ftc(2:end,o)',deg2rad(c1(2:end)'));
            end
            surorif = ctcshift(temp,ooif);
            suroricnf = cn(surorif,'a');
            oritf = surorif(:,1);
            oritf(1) = oritf(end);
            [curvefit,goodness,fitinfo]=OriFit(ox,oritf);
            fcf = coeffvalues(curvefit);
            tt = oof+fcf(2);
            tt(tt<0) = tt(tt<0)+180;
            tt(tt>180) = tt(tt>180)-180;
            foritf = [tt fcf(3) goodness.adjrsquare];
            
            
            ftc = cn(cfr.wtc.mtc,'n');
            ftc = ctcshift(ftc,ooi);
            %%%%%%%%%%%%%%% Spike Power %%%%%%%%%%%%%%%
            if isfield(cur,'sctc')
                sctc = cur.sctc.mtc;
                
                %                opmorisursc = cn(sctc(ooi,:),'n');
                
                temp = sctc;
                for o = 1:length(sti{1})
                    temp(o,:) = cn(sctc(o,:),'n');
                end
                opmorisursc = cn(mean(temp(2:end,:)),'n');
                
                sctc = cn(cur.sctc.mtc,'n');
                sctc = ctcshift(sctc,ooi);
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
                oo(vsn,1) = oos;
                oo(vsn,2) = oof;
                cvs(vsn,:) = surcvs;
                cvf(vsn,:) = surcvf;
                foos(vsn,:) = forits;
                foof(vsn,:) = foritf;
                oosurs = cat(1,oosurs,opmorisurs);
                oosurf = cat(1,oosurf,opmorisurf);
                oosursc = cat(1,oosursc,opmorisursc);
                suros = cat(3,suros,suroris);
                surof = cat(3,surof,surorif);
                surocns = cat(3,surocns,suroricns);
                surocnf = cat(3,surocnf,suroricnf);
                tcs = cat(3,tcs,stc);
                tcf = cat(3,tcf,ftc);
                tcsc = cat(3,tcsc,sctc);
                
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
        ci.power = power;
        ci.ps = squeeze(mean(power,1));
        ci.sd = squeeze(std(power,0,1));
        ci.se = ci.sd/sqrt(size(power,1));
        ci.powerac = powerac;
        ci.psac = squeeze(mean(powerac,1));
        ci.sdac = squeeze(std(powerac,0,1));
        ci.seac = ci.sdac/sqrt(size(powerac,1));
        ci.powerrc = powerrc;
        ci.psrc = squeeze(mean(powerrc,1));
        ci.sdrc = squeeze(std(powerrc,0,1));
        ci.serc = ci.sdrc/sqrt(size(powerrc,1));
        ci.frequencies = df;
        ci.sti = vsti;
    case 'sfc'
        if nargin>2
            suidx = varargin{1};
            coherence = coherence(suidx,:,:);
            phase = phase(suidx,:,:);
        end
        ci.coherence = coherence;
        ci.cs = squeeze(mean(coherence,1));
        ci.se = squeeze(ste(coherence,0,1));
        ci.coherenceac = coherenceac;
        ci.csac = squeeze(mean(coherenceac,1));
        ci.seac = squeeze(ste(coherenceac,0,1));
        ci.coherencerc = coherencerc;
        ci.csrc = squeeze(mean(coherencerc,1));
        ci.serc = squeeze(ste(coherencerc,0,1));
        
        ci.phase = phase;
        ci.p = circ_rtest3d(phase);
        mu = circ_mean(phase,[],1);
        ci.ps = squeeze(mu);
        [s s0] = circ_std(phase,[],[],1);
        ci.psd = squeeze(s0);
        ci.phaseac = phaseac;
        ci.psac = squeeze(mean(phaseac,1));
        ci.pseac = squeeze(ste(phaseac,0,1));
        ci.phaserc = phaserc;
        ci.psrc = squeeze(mean(phaserc,1));
        ci.pserc = squeeze(ste(phaserc,0,1));
        
        ci.frequencies = df;
        ci.sti = vsti;
        ci.sessionindex = sessionindex;
        ci.ch = ch;
        ci.sortid = sortid;
        type = SBCS{end,1}.sfctype;
    case {'sc','fsc'}
        ci.sis = sis;
        ci.maxs = maxs;
        ci.mins = mins;
        ci.res = res;
        ci.ris = ris;
        ci.tcs = tcs;
        ci.mtcs = mean(tcs,1);
        ci.tcses = ste(tcs,0,1);
        ci.sisc = sisc;
        ci.maxsc = maxsc;
        ci.minsc = minsc;
        ci.resc = resc;
        ci.risc = risc;
        ci.tcsc = tcsc;
        ci.mtcsc = mean(tcsc,1);
        ci.tcsesc = ste(tcsc,0,1);
        ci.fgs = fgs;
        ci.fgsc = fgsc;
        ci.bin = (0:0.1:1);
        ci.sti = vsti;
    case 'su'
        ci.sd = sds;
        ci.hsw = hsws;
        ci.hasw = hasws;
        ci.ar = ars;
        ci.sw = sws;
        ci.ssw = ssws;
        ci.sessionindex = sessionindex;
        ci.ch = ch;
        ci.sortid = sortid;
    otherwise
        ci.oo = oo;
        ci.cvs = cvs;
        ci.cvf = cvf;
        ci.foos = foos;
        ci.foof = foof;
        ci.oosurs = oosurs;
        ci.oosurf = oosurf;
        ci.oosursc = oosursc;
        
        ots = permute(suros,[3 1 2]);
        ci.ots = ots;
        ci.mots = squeeze(mean(ots,1));
        ci.otses = squeeze(ste(ots,0,1));
        otf = permute(surof,[3 1 2]);
        ci.otf = otf;
        ci.motf = squeeze(mean(otf,1));
        ci.otsef = squeeze(ste(otf,0,1));
        
        otcns = permute(surocns,[3 1 2]);
        ci.otcns = otcns;
        ci.motcns = squeeze(mean(otcns,1));
        ci.otsecns = squeeze(ste(otcns,0,1));
        otcnf = permute(surocnf,[3 1 2]);
        ci.otcnf = otcnf;
        ci.motcnf = squeeze(mean(otcnf,1));
        ci.otsecnf = squeeze(ste(otcnf,0,1));
        
        tcs = permute(tcs,[3 1 2]);
        ci.tcs = tcs;
        ci.mtcs = squeeze(mean(tcs,1));
        ci.tcses = squeeze(ste(tcs,0,1));
        tcf = permute(tcf,[3 1 2]);
        ci.tcf = tcf;
        ci.mtcf = squeeze(mean(tcf,1));
        ci.tcsef = squeeze(ste(tcf,0,1));
        tcsc = permute(tcsc,[3 1 2]);
        ci.tcsc = tcsc;
        ci.mtcsc = squeeze(mean(tcsc,1));
        ci.tcsesc = squeeze(ste(tcsc,0,1));
        
        ci.ox = ox;
        ci.sessionindex = sessionindex;
        ci.ch = ch;
        ci.sortid = sortid;
        ci.site = site;
        ci.bin = (0:0.1:1);
        ci.sti = sti;
end

ci.info = SBCS{end,1};
ci.info.scstype = type;
