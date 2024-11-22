%Crack parameters
xi = 0.0014;
c = 10*xi;
p = 0.6;

for aa= 2:10

loc = strcat('C:\Users\zwhit\Desktop\DaneUploads\FinalRun1\networks\300x150\',num2str(aa,'%03.f'));

% location of this script
hmdir = pwd; 

% load data
cd(loc)
loc_local = pwd;

afile = strcat(loc_local,'\','atoms_equilib.dump');
bfile = strcat(loc_local,'\','bonds_equilib.dump');

cd(hmdir)
[x,y,id,ty,mol,natoms,bAtom1,bAtom2,bType,bLength,bForce,bEngpot,xlims,ylims,zlims,rx,ry] = parse_equidump_full_fun(afile,bfile);

%Properties
dia = 1e-3;
rho = 0.304*1e6;
%% Extract data from the last time step
%coords
X = x{end};
Y = y{end};

%types
TYPE = ty{end};
bondType = bType{end};

%limits
Xlimits = xlims{end};
Ylimits = ylims{end};
Zlimits = zlims{end};

%typology
iatom = bAtom1{end};
jatom = bAtom2{end};

%IDs
ID = id{end};
MOL = mol{end};

for ii = 1:length(bondType)
    if rand() < p
        bondType(ii) = 2;
    end
end

ntype2 = sum(bondType == 2);
nbonds = length(bondType);
ntype2/nbonds

xmin = -0.142;
xmax = max(X);
ymin = min(Y);
ymax = max(Y);
dely = (ymax-ymin)/2;
%% create vector for bonds
sortedIDs = NaN(length(ID),1);
    for ii = 1:length(sortedIDs)
        sortedIDs(ID(ii)) = ii;
    end
    
i_index = sortedIDs(iatom(:));
j_index = sortedIDs(jatom(:));
        
%list of bond vectors
XY1 = [X(i_index) Y(i_index) X(j_index) Y(j_index)];

%crack vector
XY2 = [Xlimits(1) dely+ymin xmin+c dely+ymin];

%find where crack intersects bonds
out = lineSegmentIntersect(XY1,XY2);
idx = out.intAdjacencyMatrix;

%create list


%update
natoms = length(ID);
nbonds = sum(~idx);

iplot = 0;
if iplot
    figure(99); hold on
    for mm = 1:length(XY1)
        plot([XY1(mm,1) XY1(mm,3)],[XY1(mm,2) XY1(mm,4)])
    end

    plot([XY2(1,1) XY2(1,3)],[XY2(1,2) XY2(1,4)],'k','LineWidth',4)

end

%%
%%% Write to .dat file %%%
disp('Writing to .dat file')

% Begin writing
fid = fopen('Crack300x150.dat','w');
fprintf(fid,'Network with Crack\n\n');

% Atoms and bonds
fprintf(fid,'%d atoms\n',natoms);
fprintf(fid,'%d bonds\n',nbonds);
fprintf(fid,'1 atom types\n');
fprintf(fid,'2 bond types\n');

% Simulation boundaries
fprintf(fid,'%g %g xlo xhi\n',Xlimits(1), Xlimits(2));
fprintf(fid,'%g %g ylo yhi\n',Ylimits(1), Ylimits(2));
fprintf(fid,'%g %g zlo zhi\n\n',Zlimits(1), Zlimits(2));

% For: atom_style hybrid bpm/sphere
% atom-ID molecule-ID atom-type diameter density x y z
fprintf(fid,'Atoms\n\n');
for ii = 1:natoms
    fprintf(fid,'%d %d %d %g %g %g %g %g\n',ID(ii),MOL(ii),TYPE(ii),dia,rho,X(ii),Y(ii),0.0);
end

fprintf(fid,'Bonds\n\n');
counter = 0;
for jj = 1:length(idx)
    if ~idx(jj)
        counter = counter + 1;
        fprintf(fid,'%d %d %d %d\n',counter,bondType(jj),iatom(jj),jatom(jj));
    end
end

fclose(fid);
disp('done')

end