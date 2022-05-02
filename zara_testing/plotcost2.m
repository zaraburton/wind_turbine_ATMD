%% --- for plotting cost of support using different sampling sizes --- %%

sample = 0.1;
stxt = num2str(sample);


% for reference
latlim =[53.68 54.01];
lonlim=[2.18 2.81];

% sampling 
x1=[2.18:sample:2.81];
y1=[53.68:sample:54.01];
% create mesh grid
[X,Y] = meshgrid(x1, y1);
% calculate cost (Z)
%[Za,Zn] =allTurbCost(x1,y1);
Zf=allTurbCostPoly(x1,y1);
%Zf=oneTurbCost(x0);


%% create figures
% txt = {['LCOE: ',num2str(fval)],['Num Turbines: ',num2str(numT)], notes};
% all points
f1=figure;
s = surf(X,Y,Zf, 'EdgeColor', 'none');
title('Surface plot of monopile support cost')
subtitle(['Sampling every ',num2str(sample),' degrees'])
zlabel('Monopile support cost (€)')
xlabel('Longitude (degrees E)')
ylabel('Latitude (degrees N)')
f2=figure;
c = contour(X,Y,Zf,30);
title('Contour plot of monopile support cost')
subtitle(['Sampling every ',num2str(sample),' degrees'])
xlabel('Longitude (degrees E)')
ylabel('Latitude (degrees N)')
c = colorbar;
c.Label.String = 'Monopile support cost (€)';

% cutting off high bits
%f3=figure;
%s = surf(X,Y,Zf, 'EdgeColor', 'none');
%title('Surface plot of monopile support cost')
%subtitle({['Sampling every ',num2str(sample),' degrees'],['Excluding cost > 7.5 mill €']})
% zlabel('Monopile support cost (€)')
% xlabel('Longitude (degrees E)')
% ylabel('Latitude (degrees N)')
% f4=figure;
% c = contour(X,Y,Zf,15);
% title('Contour plot of monopile support cost')
% subtitle({['Sampling every ',num2str(sample),' degrees'],['Excluding cost > 7.5 mill €']})
% xlabel('Longitude (degrees E)')
% ylabel('Latitude (degrees N)')
% c = colorbar;
% c.Label.String = 'Monopile support cost (€)';


%% functions
function [Za, Zn]=allTurbCostExc(x1,y1)
% calculates Z cost matrix at each point - excluding points above 7.5 mill
% cost
    
    for e =1:length(x1)
        for q=1:length(y1)
            x0=[y1(q),x1(e)];
            Z=oneTurbCost(x0);
            if Z <= 7500000 % plotting Zn as Nan if bigger to try get gaps in contour
                Za(q,e)=Z;
                Zn(q,e)=Z;
            else 
                Za(q,e)=Z;
                Zn(q,e)=nan;  
            end
        end
    end
end

function [Zf]=allTurbCostPoly(x1,y1)
%% increases cost if outside shape boundary
S = shaperead('horn3shape.shp');

% calculates Z cost matrix at each point - increasing for points not in
% polygon area
    for e =1:length(x1)
        for q=1:length(y1)
            x0=[y1(q),x1(e)];
            Zf(q,e)=oneTurbCost(x0,S); %initial z cost
            

        end
    end
end

function [costb]=oneTurbCost(x0,S)
% setting up inputs to cost function 
% change support design variables here 


% bathymetry data inputs
[A,R] = readgeoraster('hsb.tif','OutputType','double');
latlim = R.LatitudeLimits;
longlim = R.LongitudeLimits;
info = geotiffinfo('hsb.tif');
height = info.Height; % Integer indicating the height of the image in pixels
width = info.Width; % Integer indicating the width of the image in pixels
x = 1:width;
y = 1:height;
[rows,cols] = meshgrid(1:height,1:width);
[ADlat,ADlon] = pix2latlon(info.RefMatrix, rows, cols);

% creates turbine position array needed for cost function 
[~,costTurbPos] = TurbPos2(x0);

% Support Design variables (which may get optimised)
mp_limit_var = -100;
j_limit_var = -160;
supportLimits = [mp_limit_var, j_limit_var];


costa = cost(1,costTurbPos,ADlat,ADlon,A,supportLimits);
%costb = costa;

%from here on = new---



% use: hornshape = S.Geometry to get coordinates of each corner
xv = S.X;
yv = S.Y;
%check if point in polygon
[d,x_poly,y_poly] = p_poly_dist(x0(1), x0(2), xv, yv); 
i=0;
o=0;
if d < 0 %if inside or on edge
    costb = costa; 
    i=i+1
else 
    costb = costa+costa*(d*10000);
    o=o+1
end

end



function [d,x_poly,y_poly] = p_poly_dist(x, y, xv, yv) 
%*******************************************************************************
% function:	p_poly_dist
% Description:	distance from point to polygon whose vertices are specified by the
%              vectors xv and yv
% Input:  
%    x - point's x coordinate
%    y - point's y coordinate
%    xv - vector of polygon vertices x coordinates
%    yv - vector of polygon vertices x coordinates
% Output: 
%    d - distance from point to polygon (defined as a minimal distance from 
%        point to any of polygon's ribs, positive if the point is outside the
%        polygon and negative otherwise)
%    x_poly: x coordinate of the point in the polygon closest to x,y
%    y_poly: y coordinate of the point in the polygon closest to x,y
%
% Routines: p_poly_dist.m
% Revision history:
%    03/31/2008 - return the point of the polygon closest to x,y
%               - added the test for the case where a polygon rib is 
%                 either horizontal or vertical. From Eric Schmitz.
%               - Changes by Alejandro Weinstein
%    7/9/2006  - case when all projections are outside of polygon ribs
%    23/5/2004 - created by Michael Yoshpe 
% Remarks:
%*******************************************************************************

% If (xv,yv) is not closed, close it.
xv = xv(:);
yv = yv(:);
Nv = length(xv);
if ((xv(1) ~= xv(Nv)) || (yv(1) ~= yv(Nv)))
    xv = [xv ; xv(1)];
    yv = [yv ; yv(1)];
%     Nv = Nv + 1;
end
% linear parameters of segments that connect the vertices
% Ax + By + C = 0
A = -diff(yv);
B =  diff(xv);
C = yv(2:end).*xv(1:end-1) - xv(2:end).*yv(1:end-1);
% find the projection of point (x,y) on each rib
AB = 1./(A.^2 + B.^2);
vv = (A*x+B*y+C);
xp = x - (A.*AB).*vv;
yp = y - (B.*AB).*vv;
% Test for the case where a polygon rib is 
% either horizontal or vertical. From Eric Schmitz
id = find(diff(xv)==0);
xp(id)=xv(id);
clear id
id = find(diff(yv)==0);
yp(id)=yv(id);
% find all cases where projected point is inside the segment
idx_x = (((xp>=xv(1:end-1)) & (xp<=xv(2:end))) | ((xp>=xv(2:end)) & (xp<=xv(1:end-1))));
idx_y = (((yp>=yv(1:end-1)) & (yp<=yv(2:end))) | ((yp>=yv(2:end)) & (yp<=yv(1:end-1))));
idx = idx_x & idx_y;
% distance from point (x,y) to the vertices
dv = sqrt((xv(1:end-1)-x).^2 + (yv(1:end-1)-y).^2);
if(~any(idx)) % all projections are outside of polygon ribs
   [d,I] = min(dv);
   x_poly = xv(I);
   y_poly = yv(I);
else
   % distance from point (x,y) to the projection on ribs
   dp = sqrt((xp(idx)-x).^2 + (yp(idx)-y).^2);
   [min_dv,I1] = min(dv);
   [min_dp,I2] = min(dp);
   [d,I] = min([min_dv min_dp]);
   if I==1, %the closest point is one of the vertices
       x_poly = xv(I1);
       y_poly = yv(I1);
   elseif I==2, %the closest point is one of the projections
       idxs = find(idx);
       x_poly = xp(idxs(I2));
       y_poly = yp(idxs(I2));
   end
end
if(inpolygon(x, y, xv, yv)) 
   d = -d;
end

end
