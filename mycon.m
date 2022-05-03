function [c,ceq] = mycon(x0)
% reading hornsea shapefile
%S = shaperead('horn3shape.shp');
S = getGlobalS;
% use: hornshape = S.Geometry to get coordinates of each corner
xv = S.X;
yv = S.Y;
for i=1:length(x0(:,1))
    y=x0(i,1);
    x=x0(i,2);
    cb(i) = p_poly_dist(x, y, xv, yv);
end
c = cb*100;     % Compute nonlinear inequalities at x.
ceq = []; % Compute nonlinear equalities at x.

end