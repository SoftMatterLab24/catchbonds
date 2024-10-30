    loc = 'C:\Users\zwhit\Desktop\CatchTest\mixedbonds\90'; loc = pwd;
    afile = strcat(loc,'\','atoms.dump');
    bfile = strcat(loc,'\','bonds.dump');

    [x,y,id,ty,mol,natoms,bAtom1,bAtom2,bType,bLength,bForce,bForcex,bForcey,bForcez,bEngpot,xlims,ylims,zlims] = parse_dump_full_fun(afile,bfile);
    

    %% Catch Parameters
    %Inputs
    eta =
    f0 = 0.0004;
    kd0 = 0.0074;
    
    %Compute
    B = 2*eta^2 + 2*sqrt(eta^4 -eta^2) - 1;

    %% 
    ii = 1;
    tau_b = (kd0/(B+1).*(exp(bForce{ii}./f0) + B*exp(-bForce{ii}./f0)))^-1;


   
