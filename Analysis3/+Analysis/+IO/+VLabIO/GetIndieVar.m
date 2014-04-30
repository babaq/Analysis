function [ ct ] = GetIndieVar( ct,ivvdim, tt,nivs )
%GETINDIEVAR Eliminate Dependent Variables
%   Detailed explanation goes here


if isempty(nivs)
    % Get Non-Independent Variables according to TestType
    switch tt
        case 'BO_Natim_Hybrid'
            nivs = {'FILENAME','IMPOSX','IMPOSY'};
        case 'Foraging_10'
            nivs = {'FIXFIGIDX','RFFIGIDX'};
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
        % Exclude Dependent Variable
        s = 1;
        while s<=width(tvg)-1
            sv = categorical(tvg{:,s});
            usv = unique(sv,'rows','stable');
            dvi=[];
            e = s+1;
            while e<=width(tvg)
                ev = categorical(tvg{:,e});
                uev = unique(ev,'rows','stable');
                tv = [];
                for u = 1:size(usv,1)
                    t1 = Analysis.Base.roweq(usv(u,:),sv);
                    t2 = Analysis.Base.roweq(uev(u,:),ev);
                    tv = [tv all(t1==t2)];
                end
                if all(tv)
                    dvi = [dvi e];
                end
                e = e + 1;
            end
            tvg(:,dvi)=[];
            s = s + 1;
        end
    end

end
