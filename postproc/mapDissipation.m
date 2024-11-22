clear all
close all

plasma=plasma();

loc = 'D:\CU_Boulder\Research\Fields\7CatchBondNetworks\Data\crack\crack300x150\001slip\300x150_slipdamage';
hmdir = pwd;

afile = strcat(loc,'\ATOMS.dump');
bfile = strcat(loc,'\BONDS.dump');

[x,y,z,id,ty,mol,natoms,bAtom1,bAtom2,bType,bLength,bForce,bForcex,bForcey,bForcez,bEngpot,xlims,ylims,zlims,rx,ry,rz] = parse_dump_full_fun(afile,bfile);

cd(loc)
try
    load('BondTrajectories.mat')
catch
    [BondTrajectories] = processBondEnergy(bAtom1,bAtom2,bType,bLength,x,y,id);
    save('BondTrajectories.mat',"BondTrajectories")
end
cd(hmdir)

%sort breaking from detachment
[Ub,Ud,Nb,Nd,Cd,Cb] = getEnergyDiss(BondTrajectories);

%MAP
xi = 0.0014;
gridsize = 4;

cd(loc)

t=50;
for tt = 2:t

%SETUP GRID
width = xlims{tt}(2)  - xlims{tt}(1);
height = ylims{tt}(2)  - ylims{tt}(1);

Nx = ceil(width/(xi*gridsize));
Ny = ceil(height/(xi*gridsize));

for n = 1:Nx
    Nxpts(n).leftbc = xlims{tt}(1) + (n-1)*xi*gridsize;
    Nxpts(n).rightbc = xlims{tt}(1) + (n)*xi*gridsize;

    Nxgrid(n) = xlims{tt}(1) + (n-0.5)*xi*gridsize;
end

for m = 1:Ny
    Nypts(m).bttmbc = ylims{tt}(1) + (m-1)*xi*gridsize;
    Nypts(m).topbc = ylims{tt}(1) + (m)*xi*gridsize;

    Nygrid(m) = ylims{tt}(1) + (m-0.5)*xi*gridsize;
end

%failed bond info
ub = Ub{tt};
cxb = Cb{1,tt};
cyb = Cb{2,tt};

%detached bond info
ud = Ud{tt};
cxd = Cd{1,tt};
cyd = Cd{2,tt};

%SORT BONDS
for ii = 1:Nx
    for jj = 1:Ny
        
        Ubmap(ii,jj) = 0;
        Udmap(ii,jj) = 0;
        
       
        leftboundary = Nxpts(ii).leftbc;
        rightboundary = Nxpts(ii).rightbc;
        bottomboundary = Nypts(jj).bttmbc;
        upperboundary = Nypts(jj).topbc;
        
        % broken bonds
        Bb = [cxb' > leftboundary, cxb' < rightboundary,cyb' > bottomboundary, cyb' < upperboundary];
        ind_broken = all(Bb,2);

        if sum(ind_broken) == 0
            
        else
            Ubmap(ii,jj) = sum(ub(ind_broken));
        end
        
        % dettached bonds
        Bd = [cxd' > leftboundary, cxd' < rightboundary,cyd' > bottomboundary, cyd' < upperboundary];
        ind_dettach = all(Bd,2);

        if sum(ind_dettach) == 0

        else
            Udmap(ii,jj) = sum(ud(ind_dettach));
        end
        
    end
end

[X,Y] = meshgrid(Nxgrid,Nygrid);

%interpolate
Nxq = linspace(Nxgrid(1),Nxgrid(end),length(Nxgrid)*10);
Nyq = linspace(Nygrid(1),Nygrid(end),length(Nygrid)*10);

[Xq, Yq] = meshgrid(Nxq,Nyq);
Udmap_q = interp2(X,Y,Udmap',Xq,Yq);
Ubmap_q = interp2(X,Y,Ubmap',Xq,Yq);

figure(1)
contourf(Xq,Yq,Ubmap_q,'EdgeColor','none')
colormap('hot')
set(gcf,"Position",[100 100 2000 1000])
clim([0 1.5e-6])
set(gcf, 'color', 'none');    
set(gca, 'color', 'none');
axis off
name = strcat('damage',num2str(tt-1,'%03.f'),'.png');
export_fig(name, '-transparent')
clf

figure(2)
contourf(Xq,Yq,Udmap_q,'EdgeColor','none')
colormap(plasma)
set(gcf,"Position",[100 100 2000 1000])
clim([0 1.5e-6])
set(gcf, 'color', 'none');    
set(gca, 'color', 'none');
axis off
name = strcat('dissipated',num2str(tt-1,'%03.f'),'.png');
export_fig(name, '-transparent')
clf

colorbar
end


