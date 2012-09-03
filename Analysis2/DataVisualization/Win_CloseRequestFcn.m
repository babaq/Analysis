function Win_CloseRequestFcn(hObject, eventdata, handles)
% Win_CloseRequestFcn.m
% 2011-05-30 by Zhang Li
% Figure Close Callback

SaveFigure(hObject);

delete(hObject);