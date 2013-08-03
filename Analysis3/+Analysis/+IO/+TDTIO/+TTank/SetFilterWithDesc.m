function [ nepoc ] = SetFilterWithDesc( TTX, filterdesc )
%SETFILTERWITHDESC same as SetFilter except that the filter is
%               specified as a string rather than four longs
% A filter description contains three parts, (1) epoch name, (2) operation
% specification and (3) the value(s). The format looks like: [EpochName]
% [OperationSpec] [Value(s)].
% EpochName -- The epoch name is specified as four chars, such as FREQ, SwpN,
% or Puff. There are three special keywords that will invoke special non-epoch
% driven filtering, they are: TIME, CHAN, and SORT. These three keywords
% allow for full filtering function on the time stamp, channel number, and sort
% code for event records.
% OperationSpec -- Each of the operations enumerated in the SetFilter description
% has a corresponding text character specification. These characters are '=', '<>',
% '>=', '<=', '>', and '<'. They meaning of each is based on their use in standard
% mathematical equations. One exception is that a value range, or the 'include,
% between' function, is specified using the '=' character. For example, FREQ =
% 1000:8000 is used to specify all FREQs between 1000 and 8000. To specify the
% 'outside' or not between function use the '<>' characters in the form: FREQ <>
% 1000:8000.
% Value(s) -- The values parameter is always a decimal number, such as 12.3 or
% 768. If two numbers are needed (for specifying a range) use a colon between
% them, for example 4:44.

nepoc = TTX.SetFilterWithDesc(filterdesc);
end

