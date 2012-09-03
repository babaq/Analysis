function PlotSoul(sdataset)
% PlotSoul.m
% 2010-04-24 Zhang Li
% Plot Soul simulation system record files data

if(isfield(sdataset,'potential'))
    PlotPotential(sdataset);
end
if(isfield(sdataset,'spike'))
    PlotSpike(sdataset);
end