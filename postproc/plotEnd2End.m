function  [] = plotEnd2End(rx,ry,r,ux,uy)

for ii = 1:length(rx)
   % h = histogram2(rx{ii},ry{ii},'Normalization','probability');
   % prob{ii} = h.Values;
   % pause

    rxavg(ii) = mean(rx{ii});
    ryavg(ii) = mean(ry{ii});
    ravg(ii)  = mean(r{ii});
end

% figure(1); hold on
% plot(ravg,'k')
% hold on
% plot(rxavg,'r')
% plot(ryavg,'b')
% for ii = 1:length(prob)
%     contourf(prob{ii},256,'LineStyle','none')
%     pause
% end

end