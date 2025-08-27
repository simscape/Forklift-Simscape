function clrMap = tbl2heat_clrmap

%clrMap = flipud(cool);
clrMap = flipud(summer);
%clrMap = flipud(parula);

mr = 32;
%clrMap = [linspace(1,1,mr)' linspace(0.7765,1,mr)' linspace(0.6078,1,mr)';
%       linspace(1,0.5843,mr)' linspace(1,0.7020,mr)' linspace(1,0.8431,mr)'];

%clr2 = [150 220 248]/255;
%clr1 = [255 204 153]/255;

clr2 = [102 153 255]/255;
clr1 = [255 124 128]/255;


%clrMap = [linspace(clr1(1),clr2(1),mr)' linspace(clr1(2),clr2(2),mr)' linspace(clr1(3),clr2(3),mr)'];
%       linspace(1,,mr)' linspace(1,,mr)' linspace(1,,mr)'];


clrMap(1,:) = [1.0 0.3 0.3];

clrMap(1,:) = [255 153 153]/255;
