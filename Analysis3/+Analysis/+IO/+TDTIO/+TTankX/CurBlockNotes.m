function [ blocknotes ] = CurBlockNotes( TX )
%CURBLOCKNOTE returns notes associated with the currently selected block.
%output:
%   blocknotes
%       StoreName       name of each store
%       Enabled         enable status of store
%       CircType        circuit type
%       NumChan         number of channels
%       StrobeMode      onset/offset strobe
%       StrobeBuddy     buddy epoch if applicable
%       SecTag          secondary tag information if applicable
%       NumPoints       number of points
%       DataFormat      data format(0: float, 1: 32-bit integer, 2: short, 3: byte)
%       SampleFreq      sample frequency

blocknotes = TX.CurBlockNotes();
end

