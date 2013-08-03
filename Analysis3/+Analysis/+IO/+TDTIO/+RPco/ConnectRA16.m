function [ hr ] = ConnectRA16( RPX,interface,devnum )
%CONNECTRA16 Establishes a connection with the Medusa Base Station (RA16BA)
%           via the Gigabit or USB bus interface. Invoking this method causes 
%           the control to search for the 16-channel preamplifier typically
%           connected to the base station and establish a handle to the associated device driver.
%Input:
%      interface: Interface to which the device is connected.
%                   Argument   Connection     Part #s
%                   'GB'         Gigabit      PI5/FI5, PO5/FO5
%                   'USB'          USB        UZ2, UB2, UZ1, UZ4
%      devnum: Logical device number. Starts with 1 and counts upward for
%              each device of a specified type.
% Note: Invoke device connect commands only once to connect to a device,
%       and then use ClearCOF and LoadCOF commands to upload or reload the
%       control object to implement changes to the signal.

hr = RPX.ConnectRA16(interface,devnum);
if hr==0
    hr = false;
else
    hr = true;
end

end

