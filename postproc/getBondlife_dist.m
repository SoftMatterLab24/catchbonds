    clear all
    close all
    
    loc = 'D:\CU_Boulder\Research\Fields\7CatchBondNetworks\Data\crack\crack300x150\slip\300x150_slipdamage';
    afile = strcat(loc,'\','atoms.dump');
    bfile = strcat(loc,'\','bonds.dump');

    %efile = strcat(loc,'\','Energy.out');
    %Energy = load(efile);

    [x,y,z,id,ty,mol,natoms,bAtom1,bAtom2,bType,bLength,bForce,bForcex,bForcey,bForcez,bEngpot,xlims,ylims,zlims,rx,ry,rz] = parse_dump_full_fun(afile,bfile);
    
    %find the maxstress
    %[~,ind_s] = max(Energy(:,5));
 
    %% Catch Parameters
    %Inputs
    eta = 1.0;
    f0 = 0.0004;
    kd0 = 0.0074;
    
    B = 2*eta^2 + 2*sqrt(eta^4 -eta^2) - 1;

    %theoretical force
    f_th = [0:0.00001:0.004];
    tau_th = (kd0/(B+1).*(exp(f_th./f0) + B*exp(-f_th./f0))).^-1;
    
%% Lifetime Distribution

for ii = 1:length(bForce)
    
    f = abs(bForce{ii});
    %histogram(f./f0)
    tau_exp = ((kd0/(B+1))*(exp(f./f0)+ B*exp(-f./f0))).^-1;
    
   %histogram(tau_exp,100)
    %Pd = 1 - exp(-1./tau_exp);
    h = histogram(tau_exp,100,'Normalization','probability','BinLimits',[0 1/kd0]);
    bond_lifeprob{ii} = h.Values;
    binEdges = h.BinEdges;
    for mm = 1:length(binEdges)-1
        binCenter(mm) = (binEdges(mm+1) + binEdges(mm))/2;
    end
    bond_lifebincenters{ii} =  binCenter;

end

%ploting
index = [1:4:48]; %[1 43 47]

c1 = [172 204 228]/255;
c2 = [1 22 69]/255;
c = colorGradient(c1,c2,length(index));
figure(2); hold on
cnt = 0;
for jj = index
    cnt = cnt +1;
    plot(bond_lifebincenters{jj}*kd0, bond_lifeprob{jj},'Color',c(cnt,:),'LineWidth',4)
    axis([0 1 0 0.05])
end

set(gcf,"Position",[100 100 800 800])
set(gca,"FontName",'Helvetica','LineWidth',4,'FontSize',32)
box on
axis square

     %%% Rest Lifetime
    % % xi = 0.0014;
    % % eps  = 1.0533e-06;
    % % lambda = 1.9*2*0.0014;
    % % 
    % % f_init = 2*eps*(lambda^2)*xi/(xi^2 - lambda^2)^2; 
    % % tau_init = (kd0/(B+1).*(exp(f_init/f0) + B*exp(-f_init/f0))).^-1;
    % % 
    % % clear tau_b
    % % cnt = 1;
    % % for ind = [1 25 50]
    % %     %Compute
    % %     tau_b{cnt} = (kd0/(B+1).*(exp(abs(bForce{ind})./f0) + B*exp(-abs(bForce{ind})./f0))).^-1;
    % %     f_b{cnt} = abs(bForce{ind})./f0;
    % %     cnt = cnt +1;
    % % end
    % % 
    % % g1 = repmat({'First'},length(tau_b{1}),1);
    % % g2 = repmat({'Second'},length(tau_b{2}),1);
    % % g3 = repmat({'Third'},length(tau_b{3}),1);
    % % g = [g1; g2; g3];
    % % figure(1)
    % % boxplot([f_b{1}; f_b{2}; f_b{3}],g)
    % % 
    % % histogram(f_b{1},'Normalization','probability')
    % % 
    % % figure(2); hold on
    % % ind = 50;
    % % tau_b = (kd0/(B+1).*(exp(abs(bForce{ind})./f0) + B*exp(-abs(bForce{ind})./f0))).^-1;
    % % plot(f_th/f0,tau_th)
    % % scatter(abs(bForce{ind})./f0,tau_b)