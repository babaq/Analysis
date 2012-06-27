function sticode = RecoverRandom_NET(seed, trial, nsti)
% RecoverRandom_NET.m %
% Recover Experiment Random Sequence Using .NET Random Class
% 2009-09-11 Zhang Li

import System.Random

random = Random(seed);
sticode = -ones(trial,nsti);

for i=1:trial
    for j=0:nsti-1
        while 1
            t = random.Next(nsti);
            if (sticode(i,t+1) < 0)
                sticode(i,t+1) = j;
                break;
            end
        end
    end
end

