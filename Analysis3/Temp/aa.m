cell = unique(a.cellid);

for i=1:length(cell)
    idx = find(categorical(a.cellid)==cell{i} & categorical(a.Source) == '"ORFLIP"');
    idx = idx(1);
    orflip(1:3,i) = [b.p(idx);c.p(idx);a.p(idx)];
    
    idx = find(categorical(a.cellid)==cell{i} & categorical(a.Source) == '"LocalContrast"');
    idx = idx(1);
    localcontrast(1:3,i) = [b.p(idx);c.p(idx);a.p(idx)];
    
    idx = find(categorical(a.cellid)==cell{i} & categorical(a.Source) == '"RFTarget"');
    idx = idx(1);
    rftarget(1:3,i) = [b.p(idx);c.p(idx);a.p(idx)];
end