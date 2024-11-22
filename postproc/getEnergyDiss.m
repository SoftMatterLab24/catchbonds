function [Ub, Ud, Nb, Nd,Cd,Cb] = getEnergyDiss(BondTrajectories)

[aa, bb] = size(BondTrajectories);

type = BondTrajectories(:,3);
cx = BondTrajectories(:,4);
cy = BondTrajectories(:,5);

for b = 1:bb-5
    
    if b ==1
         diss_list{b} = [];
         dmg_list{b}  = [];
        continue
    end

    U_time1 = BondTrajectories(:,b+4);
    U_time2 = BondTrajectories(:,b+5);
    
    %if both zero then ignore
    %if first zero bond was just created
    %if last zero bond was just deleted
    u_d = [];
    u_b = [];

    cxd = [];
    cyd = [];

    cxb = [];
    cyb = [];
    for a = 1:aa 

        if U_time1(a) ~= 0 && U_time2(a) == 0
    
            %sort by type
            if type(a) == 1
                u_b = [u_b U_time1(a)];
                cxb = [cxb cx(a)];
                cyb = [cyb cy(a)];
                %diss_list{b} 
            else
                u_d = [u_d U_time1(a)];
                cxd = [cxd cx(a)];
                cyd = [cyd cy(a)];
            end

        end
    end

    Cd{1,b} = cxd;
    Cd{2,b} = cyd;
    Cb{1,b} = cxb;
    Cb{2,b} = cyb;

    Ub{b} = u_b;
    Ud{b} = u_d;

    Nb(b) = length(u_b);
    Nd(b) = length(u_d);
end

end