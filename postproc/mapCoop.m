clear all
close all

loc = 'D:\CU_Boulder\Research\Fields\7CatchBondNetworks\Data\crack\crack300x150\001slip\300x150_slipdamage';
hmdir = pwd;

afile = strcat(loc,'\ATOMS.dump');
bfile = strcat(loc,'\BONDS.dump');

[x,y,z,id,ty,mol,natoms,bAtom1,bAtom2,bType,bLength,bForce,bForcex,bForcey,bForcez,bEngpot,xlims,ylims,zlims,rx,ry,rz] = parse_dump_full_fun(afile,bfile);

[BondTrajectories] = processBondEnergy(bAtom1,bAtom2,bType,bLength,x,y,id);

cd(loc)

save('BondTrajectories.mat',"BondTrajectories")

% listing = dir(loc);
% jj = 0;
% for ii = 1:length(listing)
%     if(contains(listing(ii).name,'frame'))
%        jj = jj + 1;
%        D{jj} = imread(listing(ii).name);
%     end
% end

cd(hmdir)
%%
xi = 0.0014;
gridsize = 4;

eps = 1.0533e-06;
r0 = xi;
lam = 3.8*xi - xi;

t=50;
for tt = 1:t

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


for ii = 1:Nx
    for jj = 1:Ny

        Ub_i(ii,jj) = {0};
        Ub_j(ii,jj) = {0};
        Ub_total(ii,jj) = 0;

        Ub1(ii,jj) = 0;
        Ub2(ii,jj) = 0;

        Ub_i_frac(ii,jj) = NaN;
        Ub_j_frac(ii,jj) = NaN;

        leftboundary = Nxpts(ii).leftbc;
        rightboundary = Nxpts(ii).rightbc;
        bottomboundary = Nypts(jj).bttmbc;
        upperboundary = Nypts(jj).topbc;

        B = [x{tt} > leftboundary, x{tt} < rightboundary,y{tt} > bottomboundary, y{tt} < upperboundary];
        ind = all(B,2);

        if sum(ind) == 0
            continue
        end
        
        length = bLength{tt}(ind);
        type   = bType{tt}(ind);


        Ub = (eps.*(length-r0).^2)./(lam^2 -(length-r0).^2);

        Ub_i(ii,jj) = {Ub(type==1)};
        Ub_j(ii,jj) = {Ub(type==2)};
        
        Ub1(ii,jj) = sum(Ub(type==1));
        Ub2(ii,jj) = sum(Ub(type==2));
        Ub_total(ii,jj) = sum(Ub);

        %energy fractions
        Ub_i_frac(ii,jj) = sum(Ub(type==1))/Ub_total(ii,jj);
        Ub_j_frac(ii,jj) = sum(Ub(type==2))/Ub_total(ii,jj);
    end
end

%BondEng{tt} = Ub_j_frac;
%TotalEng{tt} = Ub_total;

dynUb{tt} =  Ub1;

Ub1t(tt) = sum(Ub1,'all','omitnan');
Ub2t(tt) = sum(Ub2,'all','omitnan');
Ut(tt) = sum(Ub_total,'all','omitnan');

end

figure(99); hold on
plot(Ut,'-k')
plot(Ub1t,'-r')
plot(Ub2t,'-b')

sBT = sum(BondTrajectories,1);
plot(sBT(6:end))

[X, Y] = meshgrid(Nxgrid,Nygrid);
% 
cd(loc)
for tt = 1:t-1
% 
      BondEngDiff{tt} = dynUb{tt+1} - dynUb{tt};
% 
      figure(1)
      contourf(X,Y,BondEngDiff{tt}','FaceAlpha',1,'EdgeColor','none')
      %pause
      clim([-2e-6 2e-6])
      set(gcf,"Position",[100 100 2000 1000])
      set(gcf, 'color', 'none');    
      set(gca, 'color', 'none');
      name = strcat('engdiff',num2str(tt-1,'%03.f'),'.png');
      export_fig(name, '-transparent')
      clf
 end

