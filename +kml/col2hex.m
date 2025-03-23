function chex = col2hex(col, alpha)
% Convert color to KML color string
% Author: Taro Suzuki
arguments
    col   (:,3) double % [red, green, blue] (0.0 to 1.0)
    alpha (1,1) double = 1.0 % transparent (0.0 to 1.0)
end
nc = size(col, 1);
col(isnan(col)) = 0;
ckml = round(255*fliplr(col)); % order is BGR
hs = reshape(string(dec2hex(ckml,2)), nc, 3); % HEX color
chex = dec2hex(alpha*255)+hs(:,1)+hs(:,2)+hs(:,3); % KML HEX color