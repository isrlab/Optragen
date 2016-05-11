% =======================================================================
%   OPTRAGEN
%   Copyright (c) 2005 by
%   Raktim Bhattacharya, (raktim@aero.tamu.edu)
%   Department of Aerospace Engineering
%   Texas A&M University.
%   All right reserved.
% =======================================================================
function writeMFunction(fname,code)

% Check if the file exists
% ss=dir(fname);
% if ~isempty(ss)
%     disp(['Deleting ' fname]);
%     eval(['delete ' fname]);
% end

fd = fopen(fname,'w');
if fd == -1
    error(['Cannot create ' fname '.']);
end
fprintf(fd,'%s',code);
fclose(fd);