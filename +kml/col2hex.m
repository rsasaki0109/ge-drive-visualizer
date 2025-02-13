function chex = col2hex(col,alpha)
arguments
    col (:,3)
    alpha = 1
end
nc = size(col,1);
ckml = round(255*fliplr(col)); % order is BGR
hs = reshape(string(dec2hex(ckml,2)),nc,3);
chex = dec2hex(alpha*255)+hs(:,1)+hs(:,2)+hs(:,3);