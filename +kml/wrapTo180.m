function ango = wrapTo180(angi)
% Author: Taro Suzuki

ango = mod(angi+180,360)-180;