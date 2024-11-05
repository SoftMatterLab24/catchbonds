    clear all
    close all
    
    loc = 'C:\Users\zwhit\GitClones\catchbonds\src\template\StressRelaxation';
    afile = strcat(loc,'\','atoms.dump');
    bfile = strcat(loc,'\','bonds.dump');

    efile = strcat(loc,'\','Energy.out');
    Energy = load(efile);

    [x,y,id,ty,mol,natoms,bAtom1,bAtom2,bType,bLength,bForce,bForcex,bForcey,bForcez,bEngpot,xlims,ylims,zlims] = parse_dump_full_fun(afile,bfile);
    
    %find the maxstress
    %[~,ind_s] = max(Energy(:,5));
 
    %% Catch Parameters
    %Inputs
    eta = 1.5;
    f0 = 0.0008;
    kd0 = 0.0074;
    
    B = 2*eta^2 + 2*sqrt(eta^4 -eta^2) - 1;

    %theoretical force
    f_th = [0:0.00001:0.004];
    tau_th = (kd0/(B+1).*(exp(f_th./f0) + B*exp(-f_th./f0))).^-1;
    

     %% Rest Lifetime
    xi = 0.0019;
    eps  = 1.0533e-06;
    lambda = 1.9*2*0.0014;

    f_init = 2*eps*(lambda^2)*xi/(xi^2 - lambda^2)^2; 
    tau_init = (kd0/(B+1).*(exp(f_init/f0) + B*exp(-f_init/f0))).^-1;
    
    clear tau_b
    cnt = 1;
    for ind = [1 25 50]
        %Compute
        tau_b{cnt} = (kd0/(B+1).*(exp(abs(bForce{ind})./f0) + B*exp(-abs(bForce{ind})./f0))).^-1;
        f_b{cnt} = abs(bForce{ind})./f0;
        cnt = cnt +1;
    end
    
    g1 = repmat({'First'},length(tau_b{1}),1);
    g2 = repmat({'Second'},length(tau_b{2}),1);
    g3 = repmat({'Third'},length(tau_b{3}),1);
    g = [g1; g2; g3];
    figure(1)
    boxplot([f_b{1}; f_b{2}; f_b{3}],g)
    
    histogram(f_b{1},'Normalization','probability')

    figure(2); hold on
    ind = 50;
    tau_b = (kd0/(B+1).*(exp(abs(bForce{ind})./f0) + B*exp(-abs(bForce{ind})./f0))).^-1;
    plot(f_th/f0,tau_th)
    scatter(abs(bForce{ind})./f0,tau_b)