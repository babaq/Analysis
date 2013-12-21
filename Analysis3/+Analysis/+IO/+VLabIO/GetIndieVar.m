function [ ct ] = GetIndieVar( ct,ivvdim, tt,nivs )
%GETINDIEVAR Summary of this function goes here
%   Detailed explanation goes here

if isempty(nivs)
    % Get Non-Independent Variables according to TestType
    switch tt
        case 'BO_Natim_Hybrid'
            nivs = {'FILENAME','IMPOSX','IMPOSY'};
        otherwise
            nivs = {''};
    end
end
nii = arrayfun(@(x)find(x==categorical(ct.Properties.VariableNames)),categorical(nivs),...
    'uniformoutput',false);
nii = cell2mat(nii);
ct(:,nii) = [];
ivvdim(nii) = [];


[uivvdim, ia, ic]=unique(ivvdim);
didi = [];
if length(uivvdim)<length(ivvdim)
    for i = 1:length(uivvdim)
        dii = ic==i;
        if nnz(dii)>1
            didi = [didi;dii'];
        end
    end
    didi = logical(didi);
end

if ~isempty(didi)
    idx = 1:length(ivvdim);
    ivg = [];
    tdii = [];
    for i = 1:size(didi,1)
        dii = idx(didi(i,:));
        tdii = [tdii dii];
        tvg = ct(:,dii);
        ivg = [ivg testvargroup(tvg)];
    end
    ct(:,tdii)=[];
    ct = [ct ivg];
end

    function tvg = testvargroup(tvg)
        s = 1;
        while s<=width(tvg)-1
            sv = tvg{:,s};
            usv = unique(sv,'stable');
            dvi=[];
            e = s+1;
            while e<=width(tvg)
                ev = tvg{:,e};
                uev = unique(ev,'stable');
                tv = [];
                for u = 1:length(usv)
                    t1 = usv{u}==categorical(sv);
                    t2 = uev{u}==categorical(ev);
                    if nnz(t1==t2)==height(tvg)
                        tu = true;
                    else
                        tu = false;
                    end
                    tv = [tv tu];
                end
                if nnz(tv)==length(tv)
                    dvi = [dvi e];
                end
                e = e + 1;
            end
            if ~isempty(dvi)
                tvg(:,dvi)=[];
            end
            s = s + 1;
        end
    end

end
