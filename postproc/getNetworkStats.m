% function [] = getNetworkStats(afile,bfile)
% 
    loc = 'C:\Users\zwhit\Desktop\CatchTest\mixedbonds\90';
    afile = strcat(loc,'\','atoms.dump');
    bfile = strcat(loc,'\','bonds.dump');

    [x,y,id,ty,mol,natoms,bAtom1,bAtom2,bType,bLength,bForce,bForcex,bForcey,bForcez,bEngpot,xlims,ylims,zlims] = parse_dump_full_fun(afile,bfile);

    %[rx,ry,r,ux,uy] = getVirial(x,y,id,ty,mol,bAtom1,bAtom2,bLength,bForce,bForcex,bForcey,bForcez,bEngpot,xlims,ylims,zlims);

    [kglobal,kglobalavg,krigid,krigidavg,nbonds] = getConn(bAtom1,bAtom2,bType,natoms);

    %[] = plotEnd2End(rx,ry,r,ux,uy);
% 
% end


kglobalavg(1)
krigidavg(1)

kg = [5.3602 5.3602 5.3602 5.3602 5.3602];
kr = [4.8557 3.5423 2.7204 1.9168 0.58];
phi = [.1 .35 .5 .65 .9];

plot(phi,kr,'k*','LineWidth',1.75)
xlabel('Fraction Dynamic Bonds')
ylabel('Rigid Network Connectivity')


% close all
% loc = 'C:\Users\zwhit\GitClones\catchbonds\src\template\MixedBondV1';
% D1 = load(strcat(loc,'\','Energy.out'));
% 
% fixedbonds = D1(:,8);
% dynamicbonds = D1(:,9);
% 
% totalbonds = fixedbonds + dynamicbonds;
% 
% figure(1); hold on
% plot(fixedbonds./totalbonds,'LineWidth',1.25)
% plot(dynamicbonds./totalbonds,'LineWidth',1.25)
% axis([0 length(dynamicbonds) 0 1])
% 
% figure(2); hold on
% plot(dynamicbonds,'r','LineWidth',1.25)
% plot(fixedbonds,'b','LineWidth',1.25)
% plot(totalbonds,'k','LineWidth',1.25)