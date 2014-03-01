classdef VLabGlobal
    %VLABGLOBAL 
    %   Only Single Unit should be recorded and each well sorted SU should be
    %   recorded in different channel.
    
    properties(Constant)
        SUPPORTCHANNEL = 8;
        % Task States
        ITI = 0;
        ITI2 = 1;
        TARGET_ON = 2;
        FOREP = 3;
        TARGET_FLIP = 4;
        TARGET_OFF = 5;
        FIG_ON = 6;
        FIG_OFF = 7;
        FOREP1 = 8;
        ISI = 18;
        ISI2 = 19;
        FIX_ACQUIRED = 101;
        AXISFORCED = 102;
        REACTIONALLOWED = 103;
        FIGARRAY_ON = 104;
        FIGFIX_ACQUIRED = 105;
        FIGFIX_LOST = 106;
        % Spike Recording Time Resolution (ms)
        TICK = 0.1;
        % Impossible Time
        INVALIDTIME = -600000;
        % Task Status
        TASKTRIAL_NONE = 0;
        TASKTRIAL_EARLY = 1;
        TASKTRIAL_HIT = 2;
        TASKTRIAL_MISS = 3;
        TASKTRIAL_CONTINUE = 4;
        TASKTRIAL_END = 5;
        TASKTRIAL_FAIL = 6;
        TASKTRIAL_REPEAT = 7;
        TASKTRIAL_EARLY_HOLD = 11;
        TASKTRIAL_EARLY_RELEASE = 12;
        TASKTRIAL_DONE = 13;
        % Key States
        KEY_Forward = 70;
        KEY_Backward = 66;
        KEY_Center = 67;
        KEY_Left = 76;
        KEY_Right = 82;
        % Color Code
        bw = [100 100 100]/100;
        w = [48.2 56.3 63.1]/100;
        x = [1.5 1.9 1.9]/100;
        r = [85.5 1 0.5]/100;
        g = [5.6 80.2 0]/100;
        b = [1.1 0 100]/100;
        y = [52.5 62.3 0]/100;
        v = [68 0 100]/100;
        aq = [4.2 52.1 60.3]/100;
        gr = [11.1 13.2 13.6]/100;
        br = [15.6 0.2 0.1]/100;
        ol = [1 14.1 0]/100;
        az = [0.4 0 35.5]/100;
        be = [17.6 11 0]/100;
        cy = [1.2 16.1 16.6]/100;
        pu = [19 0 25.3]/100;
        sa = [26 31 32]/100;
        bg = [28 28 28]/100;
    end
    
    methods
    end
    
end

