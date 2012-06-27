function ri = SRS(SBRS,type,varargin)
% SRS.m %
% 2012-04-09 by Zhang Li
% Statistics of Batched RF_Surround


sn = size(SBRS,1)-1;
vsn=1;
%%%%%%%%%%%%%
interptime = 3;
sms = [];
fmf = [];
oosursc = [];
suros = [];
surof = [];
surosc = [];
surocns = [];
surocnf = [];
surocnsc = [];
%%%%%%%%%%%%%
for i = 1:sn
    cur = SBRS{i,1};
    sti = cur.sti;
    ckey = cur.ckey;
    
    dir = ckey{5,2};
    tdiam = ckey{10,2};
    cdiam = ckey{11,2};
    step = ckey{end,2};
    cind = (length(sti{1})-1)/2+1;
    c1 = sti{1}';
    c2 = sti{2};
    isv = 0;
    
    switch type
        case 'fsi'
            sind = cur.sessionindex;
            chan = cur.ch;
            sort = cur.sortid;
            rsite = cur.site;
            cfr = SBRS{i,2};
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
            cfr = SBRS{i,2};
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
            cfr = SBRS{i,2};
            %%%%%%%%%% trial normalized average %%%%%%%%%
            sm = cur.sm;
            fm = cfr.fm;
            for t = 1:size(sm,1)
                %                 temp = interp2(squeeze(sm(t,:,:)),interptime,'cubic');
                %                 cind = (size(temp,1)-1)/2+1;
                %                 temp = (temp-temp(cind,cind))/temp(cind,cind);
                %                 tsm(t,:,:) = shiftdim(temp,-1);
                %                 temp = interp2(squeeze(fm(t,:,:)),interptime,'cubic');
                %                 temp = (temp-temp(cind,cind))/temp(cind,cind);
                %                 tfm(t,:,:) = shiftdim(temp,-1);
                sm(t,:,:) = (sm(t,:,:)-sm(t,cind,cind))/sm(t,cind,cind);
                fm(t,:,:) = (fm(t,:,:)-fm(t,cind,cind))/fm(t,cind,cind);
            end
            %             sm = squeeze(fmean(tsm));
            %             fm = squeeze(fmean(tfm));
            %             clear tsm tfm;
            sm = squeeze(fmean(sm));
            fm = squeeze(fmean(fm));
            %%%%%%%%%% Spike %%%%%%%%%%%
            %                         sm = cur.msm;
            %                         fm = cfr.mfm;
            %                         sm = (sm-sm(cind,cind))/sm(cind,cind);
            %                         fm = (fm-fm(cind,cind))/fm(cind,cind);
            sm = interp2(sm,interptime,'cubic');
            fm = interp2(fm,interptime,'cubic');
            cind = (size(sm,1)-1)/2+1;
            
            ind = find(sm<0);
            [r c] = ind2sub(size(sm),ind);
            rr=-(r-cind);
            cc = c-cind;
            d = sqrt(rr.*rr+cc.*cc);
            dsin = asin(rr./d);
            dcos = acos(cc./d);
            ed = dcos;
            ed(dsin<0) = 2*pi-dcos(dsin<0);
            
            avv = abs(sm(ind)).*exp(1i*ed);
            avs = sum(avv);
            adirs = rad2deg(angle(avs))-dir;
            asis = abs(avs)/abs(sum(sm(ind)));
            %%%%%%%%%%%%% Wave %%%%%%%%%%%%%
            ind = find(fm<0);
            [r c] = ind2sub(size(fm),ind);
            rr=-(r-cind);
            cc = c-cind;
            d = sqrt(rr.*rr+cc.*cc);
            dsin = asin(rr./d);
            dcos = acos(cc./d);
            ed = dcos;
            ed(dsin<0) = 2*pi-dcos(dsin<0);
            
            avv = abs(fm(ind)).*exp(1i*ed);
            avf = sum(avv);
            adirf = rad2deg(angle(avf))-dir;
            asif = abs(avf)/abs(sum(fm(ind)));
            %%%%%%%%%%%%%%% Spike Power %%%%%%%%%%%%%%%
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
                adir(vsn,1) = adirs;
                adir(vsn,2) = adirf;
                asi(vsn,1) = asis;
                asi(vsn,2) = asif;
                
                sms{vsn,1} = sm;
                fmf{vsn,1} = fm;
                %                 oosursc = cat(1,oosursc,opmorisursc);
                %                 suros = cat(3,suros,suroris);
                %                 surof = cat(3,surof,surorif);
                %                 surocns = cat(3,surocns,suroricns);
                %                 surocnf = cat(3,surocnf,suroricnf);
                %                 tcs = cat(3,tcs,stc);
                %                 tcf = cat(3,tcf,ftc);
                %                 tcsc = cat(3,tcsc,sctc);
                
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
        ri.power = power;
        ri.ps = squeeze(mean(power,1));
        ri.sd = squeeze(std(power,0,1));
        ri.se = ri.sd/sqrt(size(power,1));
        ri.powerac = powerac;
        ri.psac = squeeze(mean(powerac,1));
        ri.sdac = squeeze(std(powerac,0,1));
        ri.seac = ri.sdac/sqrt(size(powerac,1));
        ri.powerrc = powerrc;
        ri.psrc = squeeze(mean(powerrc,1));
        ri.sdrc = squeeze(std(powerrc,0,1));
        ri.serc = ri.sdrc/sqrt(size(powerrc,1));
        ri.frequencies = df;
        ri.sti = vsti;
    case 'sfc'
        if nargin>2
            suidx = varargin{1};
            coherence = coherence(suidx,:,:);
            phase = phase(suidx,:,:);
        end
        ri.coherence = coherence;
        ri.cs = squeeze(mean(coherence,1));
        ri.se = squeeze(ste(coherence,0,1));
        ri.coherenceac = coherenceac;
        ri.csac = squeeze(mean(coherenceac,1));
        ri.seac = squeeze(ste(coherenceac,0,1));
        ri.coherencerc = coherencerc;
        ri.csrc = squeeze(mean(coherencerc,1));
        ri.serc = squeeze(ste(coherencerc,0,1));
        
        ri.phase = phase;
        ri.p = circ_rtest3d(phase);
        mu = circ_mean(phase,[],1);
        ri.ps = squeeze(mu);
        [s s0] = circ_std(phase,[],[],1);
        ri.psd = squeeze(s0);
        ri.phaseac = phaseac;
        ri.psac = squeeze(mean(phaseac,1));
        ri.pseac = squeeze(ste(phaseac,0,1));
        ri.phaserc = phaserc;
        ri.psrc = squeeze(mean(phaserc,1));
        ri.pserc = squeeze(ste(phaserc,0,1));
        
        ri.frequencies = df;
        ri.sti = vsti;
        ri.sessionindex = sessionindex;
        ri.ch = ch;
        ri.sortid = sortid;
        type = SBRS{end,1}.sfctype;
    case {'sc','fsc'}
        ri.sis = sis;
        ri.maxs = maxs;
        ri.mins = mins;
        ri.res = res;
        ri.ris = ris;
        ri.tcs = tcs;
        ri.mtcs = mean(tcs,1);
        ri.tcses = ste(tcs,0,1);
        ri.sisc = sisc;
        ri.maxsc = maxsc;
        ri.minsc = minsc;
        ri.resc = resc;
        ri.risc = risc;
        ri.tcsc = tcsc;
        ri.mtcsc = mean(tcsc,1);
        ri.tcsesc = ste(tcsc,0,1);
        ri.fgs = fgs;
        ri.fgsc = fgsc;
        ri.bin = (0:0.1:1);
        ri.sti = vsti;
    case 'su'
        ri.sd = sds;
        ri.hsw = hsws;
        ri.hasw = hasws;
        ri.ar = ars;
        ri.sw = sws;
        ri.ssw = ssws;
        ri.sessionindex = sessionindex;
        ri.ch = ch;
        ri.sortid = sortid;
    otherwise
        adir = mod(adir+min(min(adir)),360);
        ri.adir = adir;
        ri.asi = asi;
        ri.av = asi.*exp(1i*deg2rad(adir));
        
        ri.sms = sms;
        ri.fmf = fmf;
        %         ri.foof = foof;
        %         ri.oosurs = oosurs;
        %         ri.oosurf = oosurf;
        %         ri.oosursc = oosursc;
        %
        %         ots = permute(suros,[3 1 2]);
        %         ri.ots = ots;
        %         ri.mots = squeeze(mean(ots,1));
        %         ri.otses = squeeze(ste(ots,0,1));
        %         otf = permute(surof,[3 1 2]);
        %         ri.otf = otf;
        %         ri.motf = squeeze(mean(otf,1));
        %         ri.otsef = squeeze(ste(otf,0,1));
        %
        %         otcns = permute(surocns,[3 1 2]);
        %         ri.otcns = otcns;
        %         ri.motcns = squeeze(mean(otcns,1));
        %         ri.otsecns = squeeze(ste(otcns,0,1));
        %         otcnf = permute(surocnf,[3 1 2]);
        %         ri.otcnf = otcnf;
        %         ri.motcnf = squeeze(mean(otcnf,1));
        %         ri.otsecnf = squeeze(ste(otcnf,0,1));
        %
        %         tcs = permute(tcs,[3 1 2]);
        %         ri.tcs = tcs;
        %         ri.mtcs = squeeze(mean(tcs,1));
        %         ri.tcses = squeeze(ste(tcs,0,1));
        %         tcf = permute(tcf,[3 1 2]);
        %         ri.tcf = tcf;
        %         ri.mtcf = squeeze(mean(tcf,1));
        %         ri.tcsef = squeeze(ste(tcf,0,1));
        %         tcsc = permute(tcsc,[3 1 2]);
        %         ri.tcsc = tcsc;
        %         ri.mtcsc = squeeze(mean(tcsc,1));
        %         ri.tcsesc = squeeze(ste(tcsc,0,1));
        
        ri.sessionindex = sessionindex;
        ri.ch = ch;
        ri.sortid = sortid;
        ri.site = site;
        ri.bin = (0:0.1:1);
        ri.sti = sti;
end

ri.info = SBRS{end,1};
ri.info.srstype = type;
