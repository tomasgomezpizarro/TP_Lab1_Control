import numpy as np
import matplotlib.pyplot as plt
from scipy import signal
import os

# Configurar estilo de graficos con matplotlib
plt.rcParams.update({
    'font.size': 11,
    'axes.labelsize': 12,
    'axes.titlesize': 13,
    'xtick.labelsize': 10,
    'ytick.labelsize': 10,
    'legend.fontsize': 10,
    'figure.titlesize': 14,
    'grid.alpha': 0.3,
    'grid.linestyle': '--'
})

out_dir = r'C:\Users\Usuario\Desktop\TOMI\Facu\famaf\TP_Lab1_Control\figuras'
os.makedirs(out_dir, exist_ok=True)

R1 = 100e3
C1 = 0.1e-6
tau1 = R1 * C1

R2 = 47e3
C2 = 0.1e-6
tau2 = R2 * C2

# 1. Grafico para k = 11 (Caso nominal)
k = 11.0
num = [k / (tau1 * tau2)]
den = [1.0, (1/tau1 + 1/tau2), (1 + k) / (tau1 * tau2)]
sys = signal.TransferFunction(num, den)

wn = np.sqrt(den[2])
xi = den[1] / (2 * wn)
wd = wn * np.sqrt(1 - xi**2)
y_inf = k / (1 + k)

t = np.linspace(0, 0.05, 5000)
t, y = signal.step(sys, T=t)

idx_max = np.argmax(y)
Tp = t[idx_max]
y_max = y[idx_max]
PO = (y_max - y_inf) / y_inf * 100

# 2% settling
band = 0.02 * y_inf
outside = np.where(np.abs(y - y_inf) > band)[0]
Ts = t[outside[-1]]

# 10% to 90%
idx_10 = np.where(y >= 0.1 * y_inf)[0][0]
idx_90 = np.where(y >= 0.9 * y_inf)[0][0]
tr = t[idx_90] - t[idx_10]

fig, ax = plt.subplots(figsize=(8, 4.5), dpi=300)
ax.plot(t * 1e3, y, 'b-', lw=2, label=r'Respuesta $y(t)$ ($k=11$)')
ax.axhline(y_inf, color='g', linestyle='--', label=f'Valor final $y(\\infty) = {y_inf:.4f}$ V')
ax.axhline(y_inf * 1.02, color='gray', linestyle=':', label='Banda $\\pm 2\\%$')
ax.axhline(y_inf * 0.98, color='gray', linestyle=':')

ax.set_ylim(-0.05, 1.40)

# Pico
ax.plot(Tp * 1e3, y_max, 'ro', label=f'Pico ($T_p = {Tp*1e3:.2f}$ ms, $y_{{max}} = {y_max:.4f}$ V)')
ax.annotate(f'Pico: {y_max:.3f} V\nPO = {PO:.1f}%',
            xy=(Tp * 1e3, y_max), xytext=(Tp * 1e3 + 3.5, y_max - 0.12),
            arrowprops=dict(facecolor='black', shrink=0.08, width=1, headwidth=5))

# Ts
ax.axvline(Ts * 1e3, color='orange', linestyle='--', label=f'$T_s (2\\%) = {Ts*1e3:.2f}$ ms')

ax.set_xlabel('Tiempo [ms]')
ax.set_ylabel('Amplitud [V]')
ax.set_title('Respuesta al Escalón Unitario - Sysf nominal ($k=11$)')
ax.legend(loc='lower right', frameon=True)
ax.grid(True)
plt.tight_layout()
plt.savefig(os.path.join(out_dir, 'respuesta_escalon_k11.pdf'))
plt.savefig(os.path.join(out_dir, 'respuesta_escalon_k11.png'))
plt.close()

# 2. Comparacion para los distintos valores de k del punto 4
ks = [1.0, 3.2, 5.7, 11.0, 34.0]
labels = [r'$k=1.0$ (Buffer)', r'$k=3.2$', r'$k=5.7$', r'$k=11.0$ (Nominal)', r'$k=34.0$']
colors = ['purple', 'teal', 'green', 'blue', 'crimson']

fig, ax = plt.subplots(figsize=(8, 4.5), dpi=300)
t_comp = np.linspace(0, 0.05, 5000)

for val_k, lab, col in zip(ks, labels, colors):
    num_k = [val_k / (tau1 * tau2)]
    den_k = [1.0, (1/tau1 + 1/tau2), (1 + val_k) / (tau1 * tau2)]
    sys_k = signal.TransferFunction(num_k, den_k)
    _, y_k = signal.step(sys_k, T=t_comp)
    ax.plot(t_comp * 1e3, y_k, label=lab, color=col, lw=1.8)

ax.set_xlabel('Tiempo [ms]')
ax.set_ylabel('Amplitud [V]')
ax.set_title('Comparación de Respuestas al Escalón para distintos valores de $k$')
ax.legend(loc='lower right', frameon=True)
ax.grid(True)
plt.tight_layout()
plt.savefig(os.path.join(out_dir, 'comparacion_respuestas_k.pdf'))
plt.savefig(os.path.join(out_dir, 'comparacion_respuestas_k.png'))
plt.close()

print('Figuras generadas exitosamente.')
