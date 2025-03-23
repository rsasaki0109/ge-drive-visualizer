function ango = unwrap360(angi)
% Author: Taro Suzuki

% Compute phase differences
phase_diff = diff(angi);

% Detect jumps (correct changes exceeding 180 degrees)
jumps = (abs(phase_diff) > 180);

% Compute jump correction
shift = cumsum(jumps .* -sign(phase_diff) * 360);

% Compute unwrapped phase
ango = angi;
ango(2:end) = angi(2:end) + shift;