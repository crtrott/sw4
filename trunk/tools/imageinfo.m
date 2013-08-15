%
%  IMAGEINFO
%
%  Get some info (see below) about the content of an SW4 image file
%
%       Syntax:
%               [cvals,np,plane,mx,mn]=imageinfo( fil, nc )
%
%       Input:  fil - Name of image file
%               nc  - Number of countour levels (default=10).
%       Output: cvals - Contour level vector to be used with function plotimage (for equally spaced levels between mn and mx)
%               np    - Number of patches on file.
%               plane - 0: x=const, 1: y=const, 2: z=const.
%               mx    - Maximum data value over all patches.
%               mn    - Minimum data value over all patches.
%
     function [cvals,np,plane,mx,mn]=imageinfo( fil, nc, verbose )

if nargin < 3
   verbose = 0;
end;
if nargin < 2
   nc = 10;
end;

fd = fopen(fil,'r');
pr = fread(fd,1,'int');
np = fread(fd,1,'int');
   t       =fread(fd,1,'double');
   plane   =fread(fd,1,'int');
   coord   =fread(fd,1,'double');
   mode    =fread(fd,1,'int');
   gridinfo=fread(fd,1,'int');
   timecreated=fread(fd,[1 25],'uchar');
   timestring=num2str(timecreated,'%c');
   mstr=getimagemodestr(mode);
% Display header
   if verbose == 1
      disp(['Found:  prec  = ' num2str(pr)  ' t= ' num2str(t) ' plane= ' num2str(plane)]);   
      disp(['        coord = ' num2str(coord) ' mode= ' mstr ' #patches= ' num2str(np) ]);
      disp(['        gridinfo = ' num2str(gridinfo) ]); 
     disp(['    file created ' timecreated(1:24)]);
   end;
fclose(fd);

mx=0;
mn=0;
for b=1:np
  im = readimage(fil,b);
  mx1 = max(max(im));
  mn1 = min(min(im));
  if b == 1 
    mx = mx1;
    mn = mn1;
  else
    mx = max([mx mx1]);
    mn = min([mn mn1]);
  end;
end;
cvals = linspace(mn,mx,nc);
