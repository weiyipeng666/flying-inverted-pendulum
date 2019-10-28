function x_dot = f(x, u, L, g)
% x = [x y z x_dot y_dot z_dot gamma beta alpha r s r_dot s_dot]'
% u = [w_x w_y w_z a]'
    R_x = [1 0 0; 0 cos(x(7)) -sin(x(7)); 0 sin(x(7)) cos(x(7))];
    R_y = [cos(x(8)) 0 sin(x(8)); 0 1 0; -sin(x(8)) 0 cos(x(8))];
    R_z = [cos(x(9)) -sin(x(9)) 0; sin(x(9)) cos(x(9)) 0; 0 0 1];
    zeta = sqrt(L^2 - x(10)^2 - x(11)^2);
    
    x_dot(1:3) = x(4:6);
    x_dot(4:6) = R_z * R_y * R_x * [0 0 u(4)]' + [0 0 -g]; 
    x_dot(7:9) = [cos(x(8)) * cos(x(7)) -sin(x(7)) 0;
                  cos(x(8)) * sin(x(7)) cos(x(7)) 0;
                  -sin(x(8)) 0 1] \ u(1:3);   
    x_dot(10:11) = x(12:13);
    x_dot(12) = (-r^4 * x_dot(4) - (L^2 - x(10)^2)^2 * x_dot(4) ...
    - 2 * x(10)^2 * (x(11) * x(12) * x(13) + (-L^2 + x(11)^2) * x_dot(4)) ...
    + x(10)^3 * (x(13)^2 + 
end

