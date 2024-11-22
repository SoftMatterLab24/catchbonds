clear all
close all

loc = 'D:\CU_Boulder\Research\Fields\7CatchBondNetworks\Data\crack\crack300x150\permanent';

%first read data from atoms.dump and bonds
afile = strcat(loc,'\atoms.dump');
bfile = strcat(loc,'\bonds.dump');


[x,y,z,id,ty,mol,natoms,bAtom1,bAtom2,bType,bLength,bForce,bForcex,bForcey,bForcez,bEngpot,xlims,ylims,zlims,rx,ry,rz] = parse_dump_full_fun(afile,bfile);


%% write ATOMS
disp('Writing to atom file')

% Begin writing
fid = fopen('ATOMS.dump','w');

a = length(x);
for aa = 1:a
    
    timestep = aa-1;
    numAtoms = natoms(1);
    XLIM = xlims{1};
    YLIM = ylims{1};
    ZLIM = zlims{1};
    ID = id{1};
    TYPE = ty{1};
    MOL = mol{1};

    X = x{1};
    Y = y{1};
    
    %Write the header
    fprintf(fid,'ITEM: TIMESTEP\n');
    fprintf(fid,'%i\n',timestep);
    fprintf(fid,'ITEM: NUMBER OF ATOMS\n');
    fprintf(fid,'%i\n',numAtoms);
    fprintf(fid,'ITEM: BOX BOUNDS ff ff pp\n');
    fprintf(fid,'%1.8f %1.8f\n',XLIM(1),XLIM(2));
    fprintf(fid,'%1.8f %1.8f\n',YLIM(1),YLIM(2));
    fprintf(fid,'%1.8f %1.8f\n',ZLIM(1),ZLIM(2));
    fprintf(fid,'ITEM: ATOMS id type mol x y\n');

    for bb = 1:numAtoms
    fprintf(fid,'%d %d %d %f %f\n',ID(bb),TYPE(bb),MOL(bb),X(bb),Y(bb));
    end
end
fclose(fid);
disp('done')

disp('Writing to atom file')

% Begin writing
fid = fopen('ATOMS.dump','w');

a = length(x);
for aa = 1:a
    
    timestep = aa-1;
    numAtoms = natoms(1);
    XLIM = xlims{1};
    YLIM = ylims{1};
    ZLIM = zlims{1};
    ID = id{1};
    TYPE = ty{1};
    MOL = mol{1};

    X = x{1};
    Y = y{1};
    
    %Write the header
    fprintf(fid,'ITEM: TIMESTEP\n');
    fprintf(fid,'%i\n',timestep);
    fprintf(fid,'ITEM: NUMBER OF ATOMS\n');
    fprintf(fid,'%i\n',numAtoms);
    fprintf(fid,'ITEM: BOX BOUNDS ff ff pp\n');
    fprintf(fid,'%1.8f %1.8f\n',XLIM(1),XLIM(2));
    fprintf(fid,'%1.8f %1.8f\n',YLIM(1),YLIM(2));
    fprintf(fid,'%1.8f %1.8f\n',ZLIM(1),ZLIM(2));
    fprintf(fid,'ITEM: ATOMS id type mol x y\n');

    for bb = 1:numAtoms
    fprintf(fid,'%d %d %d %f %f\n',ID(bb),TYPE(bb),MOL(bb),X(bb),Y(bb));
    end
end
fclose(fid);
disp('done')

%% write BONDS
disp('Writing to bond file')

% Begin writing
fid = fopen('BONDS.dump','w');

a = length(x);
for aa = 1:a
    
    timestep = aa-1;
    numBonds = length(bType{aa});
    XLIM = xlims{1};
    YLIM = ylims{1};
    ZLIM = zlims{1};

    BTYPE = bType{aa};
    BATOM1 = bAtom1{aa};
    BATOM2 = bAtom2{aa};
    BLENGTH = bLength{aa};
    BFORCE = bForce{aa};
    BFORCEX = bForcex{aa};
    BFORCEY =  bForcey{aa};
    BFORCEZ = bForcez{aa};
    BENGPOT = bEngpot{aa};
    
    %Write the header
    fprintf(fid,'ITEM: TIMESTEP\n');
    fprintf(fid,'%i\n',timestep);
    fprintf(fid,'ITEM: NUMBER OF ENTRIES\n');
    fprintf(fid,'%i\n',numBonds);
    fprintf(fid,'ITEM: BOX BOUNDS ff ff pp\n');
    fprintf(fid,'%1.8f %1.8f\n',XLIM(1),XLIM(2));
    fprintf(fid,'%1.8f %1.8f\n',YLIM(1),YLIM(2));
    fprintf(fid,'%1.8f %1.8f\n',ZLIM(1),ZLIM(2));
    fprintf(fid,'ITEM: ENTRIES c_1[1] c_1[2] c_1[3] c_2[1] c_2[2] c_2[3] c_2[4] c_2[5] c_2[6]\n');

    for bb = 1:numBonds
    fprintf(fid,'%u %u %u %f %f %f %f %f %f\n',BTYPE(bb),BATOM1(bb),BATOM2(bb),BLENGTH(bb),BFORCE(bb),BFORCEX(bb),BFORCEY(bb),BFORCEZ(bb),BENGPOT(bb));
    end
end
fclose(fid);
disp('done')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% disp('Writing to .dat file')
% 
% % Begin writing
% fid = fopen('ATOMS.dump','w');
% fprintf(fid,'Network with Crack\n\n');
% 
% % Atoms and bonds
% fprintf(fid,'%d atoms\n',natoms);
% fprintf(fid,'%d bonds\n',nbonds);
% fprintf(fid,'1 atom types\n');
% fprintf(fid,'2 bond types\n');
% 
% % Simulation boundaries
% fprintf(fid,'%g %g xlo xhi\n',Xlimits(1), Xlimits(2));
% fprintf(fid,'%g %g ylo yhi\n',Ylimits(1), Ylimits(2));
% fprintf(fid,'%g %g zlo zhi\n\n',Zlimits(1), Zlimits(2));
% 
% % For: atom_style hybrid bpm/sphere
% % atom-ID molecule-ID atom-type diameter density x y z
% fprintf(fid,'Atoms\n\n');
% for ii = 1:natoms
%     fprintf(fid,'%d %d %d %g %g %g %g %g\n',ID(ii),MOL(ii),TYPE(ii),dia,rho,X(ii),Y(ii),0.0);
% end
% 
% fprintf(fid,'Bonds\n\n');
% counter = 0;
% for jj = 1:length(idx)
%     if ~idx(jj)
%         counter = counter + 1;
%         fprintf(fid,'%d %d %d %d\n',counter,bondType(jj),iatom(jj),jatom(jj));
%     end
% end
% 
% fclose(fid);
% disp('done')