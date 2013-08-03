function [ epi ] = stimark( tick, rseq )
%STIMARK Check and organize stimulus marker based on random sequence
%   Detailed explanation goes here

epi.error = '';
% Check Marker Completion
if length(tick)/2 == numel(rseq)
    % -----two marker mode----- %
    epi.tickpersti = 2;
    on = tick(1:2:end);
    off = tick(2:2:end);
elseif length(tick) == numel(rseq)
    % -----one marker mode----- %
    epi.tickpersti = 1;
    on = tick;
    off = circshift(tick,[0,-1]);
    off(end) = off(end-1) + (on(2)-on(1));
else
    epi.error = 'Marker Incomplete.';
end
if isempty(epi.error)
    epi.on = zeros(size(rseq,2),size(rseq,1));
    epi.off = zeros(size(rseq,2),size(rseq,1));
    [s, t] = ind2sub(size(rseq),1:length(on));
    for i = 1:length(on)
        epi.on(t(i),rseq(i)+1) = on(i);
        epi.off(t(i),rseq(i)+1) = off(i);
    end
end

end

