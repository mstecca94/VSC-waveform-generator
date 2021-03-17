%% Making Surface Plots From Scatter Data
% How do you turn a collection of XYZ triplets into a surface plot? This is
% the most frequently asked 3D plotting question that I got when I was in
% Tech Support.

%%
z = C_p2_nLVRT  ;
y = Ripple_p2_nLVRT;
x = Lt_p2_nLVRT ;
% The problem is that the data is made up of individual (x,y,z)
% measurements. It isn't laid out on a rectilinear grid, which is what the
% SURF command expects. A simple plot command isn't very useful.
figure;
plot3(x,y,z,'.-')

z(isnan(z))= 0 ; 
y(isnan(y))= 0 ; 
x(isnan(x))= 0 ; 
%% Little triangles
% The solution is to use Delaunay triangulation. Let's look at some
% info about the "tri" variable.
figure;
tri = delaunay(x,y);
plot(x,y,'.')

%%
% How many triangles are there?

[r,c] = size(tri);
disp(r)

%% Plot it with TRISURF
figure;
h = trisurf(tri, x, y, z);
axis vis3d

%% Clean it up

axis off
l = light('Position',[-50 -15 29])
set(gca,'CameraPosition',[208 -50 7687])
lighting phong
shading interp
colorbar EastOutside
