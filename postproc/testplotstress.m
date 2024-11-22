clear all
close all

%% Settings
xi = 0.0014;
gridsize = 5;

%%
loc = pwd;
afile = strcat(loc,'\atoms.dump');
bfile = strcat(loc,'\bonds.dump');

[x,y,z,id,ty,mol,natoms,bAtom1,bAtom2,bType,bLength,bForce,bForcex,bForcey,bForcez,bEngpot,xlims,ylims,zlims,rx,ry,rz] = parse_dump_full_fun(afile,bfile);

try 
    load("Stress.mat")
    %parse outputs
catch

    %get stress
    [S] = getVirialStress(rx,ry,rz,bForcex,bForcey,bForcez,x,y,id,bAtom1,bAtom2);

    save("Stress.mat","S")
end
%%

%for ii = 1:length(S)
ii=12;
stress = S{ii};

Nxgrid = xlims{ii}(1)-xi*gridsize:xi*gridsize:xlims{ii}(2)+xi*gridsize;
Nygrid = ylims{ii}(1)-xi*gridsize:xi*gridsize:ylims{ii}(2)+xi*gridsize;

Nxgridpt = xlims{ii}(1)-(xi*gridsize/2):xi*gridsize:xlims{ii}(2)+(xi*gridsize/2);
Nygridpt = ylims{ii}(1)-(xi*gridsize/2):xi*gridsize:ylims{ii}(2)+(xi*gridsize/2);

[X,Y] = meshgrid(Nxgridpt,Nygridpt);

figure(1)
scatter(x{1},y{1})
xline(Nxgrid)
yline(Nygrid)
hold on
scatter(X,Y,'red')

ijAtoms = cell(length(Nxgrid)-1,length(Nygrid)-1);

for xx = 1:length(Nxgrid)-1
    
    xx =7;
    xleft = Nxgrid(xx);
    xright = Nxgrid(xx+1);
    
    %find atoms in column
    indatomx = (x{ii} > xleft).*(x{ii} < xright);
    
    if ~any(indatomx)
        continue
    end

    for yy = 1:length(Nygrid)-1
        yy=30
        ydown = Nygrid(yy);
        yup = Nygrid(yy+1);

        %find atoms in row
        indatomy = (y{ii} >  ydown).*(y{ii} < yup);
        indatom = indatomx.*indatomy;

        if ~any(indatom)
            continue
        end

        ijAtoms{xx,yy} = id{ii}(logical(indatom));
    end
end

[m,n] = size(ijAtoms);



for mm = 1:m
    for nn = 1:n
        %preallocate
        Sd = zeros(3);
        Sx{ii}(mm,nn) = Sd(1);
        Sy{ii}(mm,nn) = Sd(1);
        Sxy{ii}(mm,nn) = Sd(1);

        ij = ijAtoms{mm,nn};
        Sd = zeros(3);

        if isempty(ij)
            continue
        end
        
        for zz = 1:length(ij)
            Sd = Sd + stress(:,:,ij(zz));
        end
        
        Sx{ii}(mm,nn) = Sd(1);
        Sy{ii}(mm,nn) = Sd(4);
        Sxy{ii}(mm,nn) = Sd(2);
    end
end

figure(99)
contourf(X,Y,Sx{ii}')
colorbar

%end 
%
