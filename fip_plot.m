%% FIP plot
plot = false;

if plot
    % TODO: plot all the stuffs, both in time and trajectories in space
end
    
%% FIP animation
animate = true;
animate_trajectories = true;
rotate = true;
write_gif = true;

L_arm = 0.25;
p_traj = [];
elevation = 20;
azimuth_start = 20;
azimuth_end = 70;

xmin = min(out.x.data(1, :, :) - L_arm);
xmax = max(out.x.data(1, :, :) + L_arm);
ymin = min(out.x.data(2, :, :) - L_arm);
ymax = max(out.x.data(2, :, :) + L_arm);
zmin = min(out.x.data(3, :, :));
zmax = max(out.x.data(3, :, :)) + 2 * L;
    
if animate
    fig = figure(1);
    filename = 'fip.gif';
    for k = 1:K
        p = out.x.data(:, :, k);
        p_traj = [p_traj p];
        x = p(1);
        y = p(2);
        z = p(3);
        alpha = out.attitude.data(k, 1);
        beta = out.attitude.data(k, 2);
        gamma = out.attitude.data(k, 3);
        
        % TODO: nice colors
        % TODO: different angles (moving, xy, xz, yz, ...)
        
        % Find position of rotors:
        R_z = [cos(alpha) -sin(alpha) 0; sin(alpha) cos(alpha) 0; 0 0 1];
        R_y = [cos(beta) 0 sin(beta); 0 1 0; -sin(beta) 0 cos(beta)];
        R_x = [1 0 0; 0 cos(gamma) -sin(gamma); 0 sin(gamma) cos(gamma)];
        R = R_x * R_y * R_z;
        R_inv = R';
        p1 = R_inv * [L_arm; 0; 0] + p;
        p2 = R_inv * [0; L_arm; 0] + p;
        p3 = R_inv * [-L_arm; 0; 0] + p;
        p4 = R_inv * [0; -L_arm; 0] + p;
        %p5 = R_inv * [0; 0; L_arm] + p;
        %p6 = R_inv * [0; 0; -L_arm] + p;

        % Find position of pendulum tip in inertial frame:
        % (assuming center of mass in middle of pendulum)
        r = out.rs.data(k, 1);
        s = out.rs.data(k, 2);
        r_i = x + 2 * r;
        s_i = y + 2 * s;
        zeta = sqrt(L^2 - r^2 - s^2);
        zeta_i = z + 2 * zeta;

        plot3(x, y, z, 'Marker', 'o', 'Color', 'r');
        grid on
        hold on
        
        plot3(p1(1), p1(2), p1(3), 'Marker', 'o', 'Color', 'b');
        plot3(p2(1), p2(2), p2(3), 'Marker', 'o', 'Color', 'b');
        plot3(p3(1), p3(2), p3(3), 'Marker', 'o', 'Color', 'b');
        plot3(p4(1), p4(2), p4(3), 'Marker', 'o', 'Color', 'b');
        plot3([x p1(1)], [y p1(2)], [z p1(3)], 'LineStyle', '-', 'LineWidth', 1.5, 'Color', 'b');
        plot3([x p2(1)], [y p2(2)], [z p2(3)], 'LineStyle', '-', 'LineWidth', 1.5, 'Color', 'b');
        plot3([x p3(1)], [y p3(2)], [z p3(3)], 'LineStyle', '-', 'LineWidth', 1.5, 'Color', 'b');
        plot3([x p4(1)], [y p4(2)], [z p4(3)], 'LineStyle', '-', 'LineWidth', 1.5, 'Color', 'b');
        %plot3([x p5(1)], [y p5(2)], [z p5(3)], 'LineStyle', '-', 'LineWidth', 1.5, 'Color', 'b');
        %plot3([x p6(1)], [y p6(2)], [z p6(3)], 'LineStyle', '-', 'LineWidth', 1.5, 'Color', 'b');
        
        plot3(r_i, s_i, zeta_i, 'Marker', 'o', 'Color', 'r');
        plot3([x r_i], [y s_i], [z zeta_i], 'LineStyle', '-', 'LineWidth', 1.5, 'Color', 'r');
        
        if animate_trajectories
            plot3(x0(1), x0(2), x0(3), 'Marker', 'x', 'Color', 'k');
            plot3(p_traj(1, :), p_traj(2, :), p_traj(3, :), 'LineStyle', ':', 'LineWidth', 1, 'Color', 'k');
        end
        
        axis equal
        axis([-0.5, 2.5, -0.5, 3.5, -2, 2]);
        %axis tight
        
        view(k/K * (azimuth_end - azimuth_start) + azimuth_start, elevation);
        
        drawnow
        hold off

        if write_gif
            % Capture the plot as an image 
            frame = getframe(fig); 
            im = frame2im(frame); 
            [imind,cm] = rgb2ind(im,256); 

            % Write to the GIF File 
            if k == 1 
                imwrite(imind,cm,filename,'gif', 'Loopcount',inf, 'DelayTime', h); 
            else 
                imwrite(imind,cm,filename,'gif','WriteMode','append', 'DelayTime', h); 
            end
        end
    end
end