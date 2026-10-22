function info = stepinfo(y, t, yfinal)
%STEPINFO Calcula los parametros de respuesta al escalon (compatible con Control System Toolbox)
%   info = STEPINFO(y, t)
%   info = STEPINFO(y, t, yfinal)

    y = y(:);
    t = t(:);
    if nargin < 3 || isempty(yfinal)
        yfinal = y(end);
    end
    y0 = y(1);
    dy = yfinal - y0;

    [ypeak, idx_peak] = max(y);
    tpeak = t(idx_peak);

    if abs(dy) > 0
        overshoot = max(0, (ypeak - yfinal) / abs(dy) * 100);
        undershoot = max(0, (y0 - min(y)) / abs(dy) * 100);
    else
        overshoot = 0;
        undershoot = 0;
    end

    % Settling time (2% criterion)
    tol = 0.02 * abs(dy);
    idx_unsettled = find(abs(y - yfinal) > tol, 1, 'last');
    if isempty(idx_unsettled)
        ts = t(1);
    elseif idx_unsettled < length(t)
        ts = t(idx_unsettled + 1);
    else
        ts = NaN;
    end

    % Rise time (10% to 90%)
    y10 = y0 + 0.10 * dy;
    y90 = y0 + 0.90 * dy;
    idx10 = find((y - y10) * sign(dy) >= 0, 1, 'first');
    idx90 = find((y - y90) * sign(dy) >= 0, 1, 'first');
    if ~isempty(idx10) && ~isempty(idx90)
        tr = t(idx90) - t(idx10);
    else
        tr = NaN;
    end

    info = struct( ...
        'RiseTime', tr, ...
        'TransientTime', ts, ...
        'SettlingTime', ts, ...
        'SettlingMin', min(y(idx90:end)), ...
        'SettlingMax', ypeak, ...
        'Overshoot', overshoot, ...
        'Undershoot', undershoot, ...
        'Peak', abs(ypeak), ...
        'PeakTime', tpeak);
end
