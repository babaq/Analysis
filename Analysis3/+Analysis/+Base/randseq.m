function [ rs ] = randseq( trialn, condn,seed,generator )
%RANDSEQ Summary of this function goes here
%   Detailed explanation goes here

if nargin < 3
    seed = 0;
    generator = 'twister';
elseif nargin < 4
    generator = 'twister';
end
rng(seed,generator);
rs = zeros(trialn,condn);

for i=1:trialn
    for j=1:condn
        while true
            t = randi(condn);
            if rs(i,t) == 0
                rs(i,t) = j;
                break;
            end
        end
    end
end

end

