function [pe,event] = nsdist(ns,varargin)
%   [pe,event] = nsdist(ns)
%   [pe,event] = nsdist(ns,condition)
%   [pe,event] = nsdist(ns,condition,'bin','on/off')
%   Computes the conditional and unconditional distribution of neural signal.
%
%   Input:
%     ns        neural signal[Trial,nStimuli]
%     condition conditional probability under which stimulus condition
%     bin       if make ns bined to size of nConditions
%
%   Output:
%     pe 		probability of event
%     event     neural signal event value
%
%   2008-11-30 Zhang Li


%% Parsing Input Arguments
nCondition = size(ns,2);

IP = inputParser;
IP.addRequired('ns',@isnumeric);
IP.addOptional('condition',0,@(x)any(x<=nCondition));
IP.addParamValue('bin','on',@ischar);
IP.parse(ns,varargin{:});


%% Distribution
binns = ns;
if strcmp(IP.Results.bin,'on')
    for i=1:size(ns,1)
        nsmax = max(binns(i,:));
        nsmin = min(binns(i,:));
        binwidth = (nsmax-nsmin)/(nCondition-1);
        binvector = (nsmin:binwidth:nsmax);
        [n,bin] = histc(binns(i,:),binvector);
        ns(i,:) = bin;
    end
end


if IP.Results.condition==0 % unconditional probability
    sample = ns;
else % conditional probability
    sample = ns(:,IP.Results.condition);
end

samplesize = numel(sample);
event = unique(sample);
eventsize = numel(event);
pe = event;

for j =1:eventsize
    pe(j) = numel( find(sample==event(j)) )/samplesize;
end


    