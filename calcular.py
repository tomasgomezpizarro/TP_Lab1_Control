import numpy as np
from scipy import signal

R1 = 100e3
C1 = 0.1e-6
tau1 = R1 * C1 # 0.01 s

R2 = 47e3
C2 = 0.1e-6
tau2 = R2 * C2 # 0.0047 s

ks = [1.0, 3.2, 5.7, 11.0, 34.0]

for k in ks:
    num = [k / (tau1 * tau2)]
    den = [1.0, (1/tau1 + 1/tau2), (1 + k) / (tau1 * tau2)]
    sys = signal.TransferFunction(num, den)

    wn = np.sqrt(den[2])
    xi = den[1] / (2 * wn)
    
    y_inf = k / (1 + k)
    ess = 1.0 - y_inf # for unit step
    
    if xi < 1.0:
        wd = wn * np.sqrt(1 - xi**2)
        PO = 100 * np.exp(-np.pi * xi / np.sqrt(1 - xi**2))
        Tp = np.pi / wd
        beta = np.arccos(xi)
        tr = (np.pi - beta) / wd
    else:
        wd = 0
        PO = 0.0
        Tp = np.nan
        tr = np.nan
        
    Ts_approx = 4.0 / (xi * wn) # criterio 2%
    
    # Numerical simulation
    t = np.linspace(0, 0.15, 200000)
    t, y = signal.step(sys, T=t)
    
    idx_max = np.argmax(y)
    Tp_sim = t[idx_max] if PO > 0 else np.nan
    PO_sim = ((y[idx_max] - y_inf) / y_inf * 100) if PO > 0 else 0.0
    
    # 2% settling time
    band = 0.02 * y_inf
    outside = np.where(np.abs(y - y_inf) > band)[0]
    Ts_sim = t[outside[-1]] if len(outside) > 0 else 0.0
    
    print(f"k = {k:4.1f} | wn = {wn:7.2f} rad/s | xi = {xi:.4f} | PO = {PO:5.2f}% | Tp = {Tp*1e3:6.2f} ms | Ts(2%) = {Ts_approx*1e3:5.2f} ms (sim: {Ts_sim*1e3:5.2f} ms) | y(oo) = {y_inf:.4f} | ess = {ess:.4f}")
