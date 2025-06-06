function Radar_Plot_Cluster(var_value,min_var_value,max_var_value,var_name)
    figure('units','normalized','outerposition',[0.1 0.1 0.55 0.8])
    subplot('Position',[0.05,0.05,0.9,0.9]);
    theta_v=0:2*pi/length(var_value):(2*pi-2*pi/length(var_value));

    ax_r=linspace(0,1,5);
    for aa=1:length(theta_v)
        x=ax_r.*cos(theta_v(aa));
        y=ax_r.*sin(theta_v(aa));
        plot(x,y,'-.','Color',[0.75 0.75 0.75],'LineWidth',2);hold on;
    
        x=1.1.*cos(theta_v(aa));
        y=1.1.*sin(theta_v(aa));

        text(x,y,var_name{aa},'Fontsize',16,'Rotation',270+180*theta_v(aa)/(pi),'HorizontalAlignment','center','VerticalAlignment','top');
    end

    for aa=1:length(ax_r)
        x=ax_r(aa).*cos([theta_v(:);theta_v(1)]);
        y=ax_r(aa).*sin([theta_v(:);theta_v(1)]);
        plot(x,y,'-.','Color',[0.75 0.75 0.75],'LineWidth',2);hold on;
    end

    r_norm=(var_value-min_var_value)./(max_var_value-min_var_value);
    x=r_norm(:).*cos(theta_v(:));
    y=r_norm(:).*sin(theta_v(:));

    x=[x(:);x(1)];
    y=[y(:);y(1)];
    plot(x,y,'k-o','LineWidth',2); 
    xlim([-1 1])
    ylim([-1 1])

    box off;
    axis off;
end