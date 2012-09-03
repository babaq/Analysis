function CMark = TTMark(TTX)
% TTMark.m
% 2011-03-17 Zhang Li
% Read Mark Event from TTank ActiveX Control

CMark.markn = TTX.ReadEventsV(10000000, 'Mark', 0, 0, 0.0, 0.0, 'ALL');
CMark.mark=TTX.ParseEvInfoV(0, CMark.markn, 6);