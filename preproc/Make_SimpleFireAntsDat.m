clear all; clc

%%% Options %%%
iplot = 1;      %plot the outpu
idefect = 0;    %make a defect (hole)

%%% User Inputs %%%
%Mesh Size
xi = 1.4*1e-3;          % Spacing

%Domain length (units xi)
L = 8;

%Defect radues (units xi)
Rdefect = 10;

%Properties
dia = 1e-3;
rho = 0.304*1e6;

%%% Size of domain (m) %%%
Lx  = L*xi;             % Length of x dimension
Ly  = L*xi;         % Length of y dimension

%%% Limits for x and y cps %%%
ax = (Lx)/2;
ay = (Ly)/2;
bx = -ax;
by = -ay;

%%% Random cp %%%
cp = [ax + (bx-ax)*rand(1) ay + (by-ay)*rand(1)];

%initialize
coords = cp;

itry = 1;
while 1 == 1

    if itry > 1000
        break
    end

    cp = [ax + (bx-ax)*rand(1) ay + (by-ay)*rand(1)];

    % Get the distance btw randomly chosen cp and rest of cps
    data = repmat(cp',[1,size(coords,1)])'-coords;
    dist2 = data(:,1).^2+data(:,2).^2;

    % Get the indicies of any cps within one particle diameter
    iclose = find(dist2 < xi^2);

    % If there are no potential intersections - successful placement
    if  isempty(iclose)
        coords = [coords; cp];
        itry = 1;
        continue
    end

    itry = itry + 1;
end

if idefect
    r2 = coords(:,1).^2 + coords(:,2).^2;

    indefect = r2 < (Rdefect*xi)^2;
    coords(indefect,:) = [];

end

natoms  = size(coords,1);

if iplot
    figure(2); clf
    hold on
    scatter(coords(:,1),coords(:,2),36,'filled')
    axis equal
end


%%% Write to .dat file %%%
disp('Writing to .dat file')

% Begin writing
fid = fopen('CatchAtomsSchema.dat','w');
fprintf(fid,'Non-intersecting ant raft\n\n');

% Atoms and bonds
fprintf(fid,'%d atoms\n',natoms);
% fprintf(fid,'%d bonds\n',nbonds);
fprintf(fid,'1 atom types\n');
fprintf(fid,'1 bond types\n');

% Simulation boundaries
fprintf(fid,'%g %g xlo xhi\n',-Lx/2 -5*xi,Lx/2 + 5*xi);
fprintf(fid,'%g %g ylo yhi\n',-Ly/2,Ly/2);
fprintf(fid,'%g %g zlo zhi\n\n',-Lx/20,Lx/20);

% For: atom_style hybrid bpm/sphere
% atom-ID molecule-ID atom-type diameter density x y z
fprintf(fid,'Atoms\n\n');
for ii = 1:natoms
    fprintf(fid,'%d %d %d %g %g %g %g %g\n',ii,ii,1,dia,rho,coords(ii,1),coords(ii,2),0.0);
end

natoms  = size(coords,1);
rhotrue = natoms/Lx/Ly;

fprintf('Goal: %g, Achieved: %g\n',rho,rhotrue)

% Depreciated - For: atom_style hybrid bond sphere
% atom-ID atom-type x y z molecule-ID diameter density
% fprintf(fid,'Atoms\n\n');
% jj = 1;
% atype = [1 2 1 2 1];
% for ii = 1:natoms
%     fprintf(fid,'%d %d %g %g %g %d %g %g\n',ii,1,coords(ii,1),coords(ii,2),0.0,ii,dia,rho);
%     jj = jj + 1;
%     if jj == 6
%         jj = 1;
%     end
% end

fclose(fid);
disp('done')

%%% DEPRECIATED %%%
% %% Parameters
% 
% %%% Single ant parameters %%%
% Lr = 2.93*1e-3;              % Length of one ant (m)
% dia = 1*Lr;                  % Diameter of one body segment (m)
% 
% %%% Size of domain (m) %%%
% Lx  = 50*1e-3;             % Length of x dimension
% Ly  = 50*1e-3;             % Length of y dimension
% 
% %%% Density of ants %%%
% rho = 0.304*1e6;           % (ants/m2)
% %dr  = sqrt(rho);           % Critical overlap distance
% dr  = Lr/1;
% 
% % Option to plot the network (don't use for large systems..)
% iplot = 1;
% 
% %% Randomly placing
% 
% % rng(1234);
% 
% %%% Limits for x and y cps %%%
% ax = (Lx-Lr)/2;
% ay = (Ly-Lr)/2;
% bx = -ax;
% by = -ay;
% 
% %%% Random cp %%%
% cp = [ax + (bx-ax)*rand(1) ay + (by-ay)*rand(1)];
% 
% 
% %initialize
% coords = cp;
% 
% itry = 1;
% while 1 == 1
% 
%     if itry > 150
%         break
%     end
% 
%     cp = [ax + (bx-ax)*rand(1) ay + (by-ay)*rand(1)];
% 
%     % Get the distance btw randomly chosen cp and rest of cps
%     data = repmat(cp',[1,size(coords,1)])'-coords;
%     dist2 = data(:,1).^2+data(:,2).^2;
% 
%     % Get the indicies of any cps within one particle diameter
%     iclose = find(dist2 < dia^2);
% 
%     % If there are no potential intersections - successful placement
%     if  isempty(iclose)
%         coords = [coords; cp];
%         itry = 1;
%         continue
%     end
% 
%     itry = itry + 1;
% end
% 
% natoms  = size(coords,1);
% rhotrue = natoms/Lx/Ly;
% 
% fprintf('Goal: %g, Achieved: %g\n',rho,rhotrue)
% 
% 
% %% Plotting (optional)
% 
% if iplot
%     figure(2); clf
%     hold on
%     scatter(coords(:,1),coords(:,2),36,'filled')
%     axis equal
% end
% 
% %% Write to .dat file
% 
% disp('Writing to .dat file')
% 
% % Begin writing
% fid = fopen('FireAntsSimple_bpm.dat','w');
% fprintf(fid,'Non-intersecting ant raft\n\n');
% 
% % Atoms and bonds
% fprintf(fid,'%d atoms\n',natoms);
% % fprintf(fid,'%d bonds\n',nbonds);
% fprintf(fid,'1 atom types\n');
% fprintf(fid,'1 bond types\n');
% 
% % Simulation boundaries
% fprintf(fid,'%g %g xlo xhi\n',-Lx/2,Lx/2);
% fprintf(fid,'%g %g ylo yhi\n',-Ly/2,Ly/2);
% fprintf(fid,'%g %g zlo zhi\n\n',-Lx/20,Lx/20);
% 
% % For: atom_style hybrid bpm/sphere
% % atom-ID molecule-ID atom-type diameter density x y z
% fprintf(fid,'Atoms\n\n');
% for ii = 1:natoms
%     fprintf(fid,'%d %d %d %g %g %g %g %g\n',ii,ii,1,dia,rho,coords(ii,1),coords(ii,2),0.0);
% end
% 
% % Depreciated - For: atom_style hybrid bond sphere
% % atom-ID atom-type x y z molecule-ID diameter density
% % fprintf(fid,'Atoms\n\n');
% % jj = 1;
% % atype = [1 2 1 2 1];
% % for ii = 1:natoms
% %     fprintf(fid,'%d %d %g %g %g %d %g %g\n',ii,1,coords(ii,1),coords(ii,2),0.0,ii,dia,rho);
% %     jj = jj + 1;
% %     if jj == 6
% %         jj = 1;
% %     end
% % end
% 
% fclose(fid);
% disp('done')

%% Compute number of neighbors within cutoff

% cutoff = 2.0*xi;
% for zz = 1:natoms
% 
%     corp = coords(zz,:);
%     datat = repmat(corp',[1,size(coords,1)])'-coords;
%     dist2t = datat(:,1).^2+datat(:,2).^2;
% 
%     % Get the indicies of any cps within one particle diameter
%     icloset = find(dist2t < cutoff^2);
%     neigh(zz) = length(icloset)-1;
% end
% 
% mean(neigh)