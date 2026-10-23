%% Trabajo de Laboratorio Integrador - Sistemas de Control
% Parte A: Modelado y Análisis (Puntos 1 al 4)
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
k_nom = 1 + R7_nom / R9_nom;  % k = 11

%% 2. Punto 1 y 2: Caso nominal (k = 11)
% Denominador mónico: s^2 + (1/tau1 + 1/tau2)*s + (1 + k)/(tau1*tau2)
wn_nom = sqrt((1 + k_nom) / (tau1 * tau2));
xi_nom = (1/tau1 + 1/tau2) / (2 * wn_nom);
wd_nom = wn_nom * sqrt(1 - xi_nom^2);
beta_nom = acos(xi_nom);

y_inf_nom = k_nom / (1 + k_nom);
PO_nom    = 100 * exp(-pi * xi_nom / sqrt(1 - xi_nom^2));
Tp_nom    = pi / wd_nom;
Ts_nom    = 4 / (xi_nom * wn_nom);          % Criterio del 2%
tr_nom    = (pi - beta_nom) / wd_nom;       % 0 a 100%
ess_nom   = 1 / (1 + k_nom);                % Error al escalón unitario

fprintf('=== CASO NOMINAL (k = %.1f) ===\n', k_nom);
fprintf('wn    = %.2f rad/s\n', wn_nom);
fprintf('xi    = %.4f\n', xi_nom);
fprintf('PO    = %.2f %%\n', PO_nom);
fprintf('Tp    = %.4f s (%.2f ms)\n', Tp_nom, Tp_nom*1e3);
fprintf('Ts    = %.4f s (%.2f ms)\n', Ts_nom, Ts_nom*1e3);
fprintf('tr    = %.4f s (%.2f ms)\n', tr_nom, tr_nom*1e3);
fprintf('y(oo) = %.4f V\n', y_inf_nom);
fprintf('ess   = %.4f V\n\n', ess_nom);

%% 3. Punto 4: Barrido de valores de k con resistencias comerciales E24
% Valores de k pedidos: 1, 3.2, 5.7 y 34
% Fijando R9 = 1 kOhm, calculamos R7 = (k - 1)*R9 dentro de la serie E24:
% - Para k = 1:   R7 = 0 Ohm (puente), R9 = Inf (circuito abierto) -> k_ef = 1
% - Para k = 3.2: R7 = 2.2 kOhm,       R9 = 1 kOhm                 -> k_ef = 3.2
% - Para k = 5.7: R7 = 4.7 kOhm,       R9 = 1 kOhm                 -> k_ef = 5.7
% - Para k = 34:  R7 = 33 kOhm,        R9 = 1 kOhm                 -> k_ef = 34

k_vals  = [1,   3.2,   5.7,   34];
R7_vals = [0,   2.2e3, 4.7e3, 33e3];
R9_vals = [Inf, 1e3,   1e3,   1e3];

n = length(k_vals);
k_ef  = zeros(n, 1);
wn    = zeros(n, 1);
xi    = zeros(n, 1);
PO    = zeros(n, 1);
Tp    = zeros(n, 1);
Ts    = zeros(n, 1);
y_inf = zeros(n, 1);
ess   = zeros(n, 1);

for i = 1:n
    % Ganancia efectiva con los resistores comerciales elegidos
    if isinf(R9_vals(i))
        k_ef(i) = 1;
    else
        k_ef(i) = 1 + R7_vals(i) / R9_vals(i);
    end
    
    % Parámetros de 2do orden para cada k
    wn(i) = sqrt((1 + k_ef(i)) / (tau1 * tau2));
    xi(i) = (1/tau1 + 1/tau2) / (2 * wn(i));
    wd    = wn(i) * sqrt(1 - xi(i)^2);
    
    % Métricas de desempeño ante escalón unitario
    PO(i)    = 100 * exp(-pi * xi(i) / sqrt(1 - xi(i)^2));
    Tp(i)    = pi / wd;
    Ts(i)    = 4 / (xi(i) * wn(i));
    y_inf(i) = k_ef(i) / (1 + k_ef(i));
    ess(i)   = 1 - y_inf(i);
end

% Armamos y mostramos la tabla resumen del Punto 4
R7_R9_str = ["0 / Inf"; "2.2k / 1k"; "4.7k / 1k"; "33k / 1k"];
Tabla_Punto4 = table(k_vals(:), R7_R9_str, k_ef, round(wn, 2), round(xi, 4), ...
    round(PO, 2), round(Tp, 4), round(Ts, 4), round(y_inf, 4), round(ess, 4), ...
    'VariableNames', {'k_pedido', 'R7_R9', 'k_efectivo', 'wn_rad_s', 'xi', ...
                      'PO_pct', 'Tp_s', 'Ts_s', 'y_inf', 'ess'});

disp('=== TABLA PUNTO 4 ===');
disp(Tabla_Punto4);
