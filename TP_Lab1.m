%% Trabajo de Laboratorio Integrador - Sistemas de Control
% Parte A: Modelado y Análisis (Puntos 1 al 4) usando Control System Toolbox
clear; clc; close all;

%% 1. Parámetros físicos del circuito (Figura 1)
R1 = 100e3;          % 100 kOhm
C1 = 0.1e-6;         % 0.1 uF
tau1 = R1 * C1;      % Constante de tiempo etapa 1: 0.01 s

R2 = 47e3;           % 47 kOhm
C2 = 0.1e-6;         % 0.1 uF
tau2 = R2 * C2;      % Constante de tiempo etapa 2: 0.0047 s

% Ganancia nominal de la etapa no inversora U2A (R7 = 10k, R9 = 1k)
R7_nom = 10e3;
R9_nom = 1e3;
k_nom  = 1 + R7_nom / R9_nom;  % k = 11

%% 2. Puntos 1, 2 y 3: Modelo de transferencia y respuesta al escalón (k = 11)
s = tf('s');

Sys1 = 1 / (tau1 * s + 1);
Sys2 = k_nom / (tau2 * s + 1);

% Lazo abierto G(s) y lazo cerrado con realimentación unitaria Sysf(s)
G_nom    = Sys1 * Sys2;
Sysf_nom = feedback(G_nom, 1);

disp('=== FUNCIÓN DE TRANSFERENCIA EN LAZO CERRADO Sysf(s) (k = 11) ===');
Sysf_nom

% Frecuencia natural (wn) y amortiguamiento (xi) con damp()
[wn_vec, xi_vec] = damp(Sysf_nom);
wn_nom = wn_vec(1);
xi_nom = xi_vec(1);

% Parámetros de respuesta al escalón con stepinfo() y ganancia DC con dcgain()
info_nom  = stepinfo(Sysf_nom);
y_inf_nom = dcgain(Sysf_nom);
ess_nom   = 1 - y_inf_nom;
Ts_teor   = 4 / (xi_nom * wn_nom);  % Aproximación teórica de envolvente (2%)

fprintf('=== PARÁMETROS CASO NOMINAL (k = %.1f) ===\n', k_nom);
fprintf('wn    = %.2f rad/s\n', wn_nom);
fprintf('xi    = %.4f\n', xi_nom);
fprintf('PO    = %.2f %%\n', info_nom.Overshoot);
fprintf('Tp    = %.4f s (%.2f ms)\n', info_nom.PeakTime, info_nom.PeakTime*1e3);
fprintf('Ts    = %.4f s (stepinfo exacto) | %.4f s (4/(xi*wn))\n', info_nom.SettlingTime, Ts_teor);
fprintf('tr    = %.4f s (10%%-90%%)\n', info_nom.RiseTime);
fprintf('y(oo) = %.4f V\n', y_inf_nom);
fprintf('ess   = %.4f V\n\n', ess_nom);

%% 3. Punto 4: Barrido de valores de k con resistencias comerciales E24
k_vals  = [1,   3.2,   5.7,   34];
R7_vals = [0,   2.2e3, 4.7e3, 33e3];
R9_vals = [Inf, 1e3,   1e3,   1e3];

n = length(k_vals);
k_ef      = zeros(n, 1);
wn        = zeros(n, 1);
xi        = zeros(n, 1);
PO        = zeros(n, 1);
Tp        = zeros(n, 1);
Ts_aprox  = zeros(n, 1);
Ts_exacto = zeros(n, 1);
y_inf     = zeros(n, 1);
ess       = zeros(n, 1);

for i = 1:n
    % Ganancia efectiva con los resistores comerciales elegidos
    k_ef(i) = 1 + R7_vals(i) / R9_vals(i);
    
    % Armamos la FT en lazo cerrado para este valor de k
    Sys2_i = k_ef(i) / (tau2 * s + 1);
    Sysf_i = feedback(Sys1 * Sys2_i, 1);
    
    % Extraemos wn, xi, dcgain y métricas con stepinfo
    [wn_i, xi_i] = damp(Sysf_i);
    info_i       = stepinfo(Sysf_i);
    
    wn(i)        = wn_i(1);
    xi(i)        = xi_i(1);
    PO(i)        = info_i.Overshoot;
    Tp(i)        = info_i.PeakTime;
    Ts_aprox(i)  = 4 / (xi(i) * wn(i));
    Ts_exacto(i) = info_i.SettlingTime;
    y_inf(i)     = dcgain(Sysf_i);
    ess(i)       = 1 - y_inf(i);
end

R7_R9_str = ["0 / Inf"; "2.2k / 1k"; "4.7k / 1k"; "33k / 1k"];
Tabla_Punto4 = table(k_vals(:), R7_R9_str, k_ef, round(wn, 2), round(xi, 4), ...
    round(PO, 2), round(Tp, 4), round(Ts_aprox, 4), round(Ts_exacto, 4), ...
    round(y_inf, 4), round(ess, 4), ...
    'VariableNames', {'k', 'R7_R9', 'k_ef', 'wn_rad_s', 'xi', ...
                      'PO_pct', 'Tp_s', 'Ts_teor_s', 'Ts_stepinfo_s', 'y_inf', 'ess'});

disp('=== TABLA PUNTO 4 ===');
disp(Tabla_Punto4);
