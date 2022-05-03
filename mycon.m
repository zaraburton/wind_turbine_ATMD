function [c,ceq] = mycon(x0)
numT=length(x0(:,1)); % number of turbines
diamD = km2deg(0.3); % turbine diameter in degrees (200 plus 100 extra for safety)

%% Proximity constraints

ar=x0(:,1);
cp = zeros(size(ar)); % column vector for each turbine (proximity constraint result)

% to compare each turbine with the others (with no repeat comparisions)
for turbA=1:numT
    for turbB=turbA+1:numT
        %[turbA,turbB] 
        % proximity should be less than 0 to satisfy the constraint
        proximity = diamD - sqrt( (x0(turbA,1)-x0(turbB,1))^2 + (x0(turbA,2)-x0(turbB,2))^2);
        %x0(comp)
        cp(turbA)=cp(turbA)+proximity;
        cp(turbB)=cp(turbB)+proximity;
    end
end

cp;

%% Area boundary constraints

% reading hornsea shapefile
S = getGlobalS;
% use: hornshape = S.Geometry to get coordinates of each corner
xv = S.X;
yv = S.Y;

cb=[]; % column vector of boundary constraint values 
for i=1:length(x0(:,1))
    y=x0(i,1);
    x=x0(i,2);
    % produce array of distances each point is outside turbine
    cb(i) = p_poly_dist(x, y, xv, yv);
end

cb;

%% Constraint results scaling 

cScale = 100;

%c = (cb+cp)*cScale;  % Compute nonlinear inequalities at x.n (to satisfy c must be < 0)
c=[cb(:),cp(:)]*cScale;
ceq = []; % Compute nonlinear equalities at x.

end