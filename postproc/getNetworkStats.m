function [] = getNetworkStats(afile,bfile)
    
    loc = 'C:\Users\zwhit\Desktop\CatchTest\Unloading\UnloadTest1_unfixdynamics';
    afile = strcat(loc,'\','atoms.dump');
    bfile = strcat(loc,'\','bonds.dump');

    [x,y,id,ty,mol,natoms,bAtom1,bAtom2,bType,bLength,bForce,bForcex,bForcey,bForcez,bEngpot,xlims,ylims,zlims] = parse_dump_full_fun(afile,bfile);

    %[rx,ry,r,ux,uy] = getVirial(x,y,id,ty,mol,bAtom1,bAtom2,bLength,bForce,bForcex,bForcey,bForcez,bEngpot,xlims,ylims,zlims);

    [kglobal,kglobalavg,krigid,krigidavg,nbonds] = getConn(bAtom1,bAtom2,bType,natoms);

    %[] = plotEnd2End(rx,ry,r,ux,uy);

end