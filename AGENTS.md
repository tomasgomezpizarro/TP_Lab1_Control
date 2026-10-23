# Instrucciones del Proyecto para Agentes LLM (`TP_Lab1_Control`)

## 1. Contexto del Trabajo Práctico
Este repositorio contiene el **Trabajo de Laboratorio Integrador: Modelado de sistemas – Características y medidas de desempeño** de la materia **Sistemas de Control** (MATLAB / Simulink / Simscape).

- **Consigna oficial completa**: `consigna_TP_Lab1.pdf` (ubicada en la raíz de este repositorio).
- **División del trabajo**:
  - **Tomás (autor de este repo)**: Realiza la **Parte A completa (Puntos 1, 2, 3 y 4)** y el **Punto 5 de la Parte B** (verificación en Simscape con amplificadores operacionales ideales).
  - **Compañero de grupo**: Realiza los **Puntos 6 y 7 de la Parte B** (op-amp real TL081 y análisis de sensibilidad a tolerancias).

## 2. Estructura de Archivos del Repositorio
- `consigna_TP_Lab1.pdf`: Enunciado completo del trabajo práctico y su Anexo (parámetros del TL081, tabla de resistores serie E24 y pautas de Simscape).
- `informe_parte1.tex` y `informe_parte1.pdf`: Informe en LaTeX. Actualmente tiene redactados y revisados los **Puntos 1, 2, 3 y 4** (Parte A completa).
- `TP_Lab1.m`: Script principal de MATLAB con el cálculo de parámetros nominales (Puntos 1 a 3) y el barrido de los cuatro valores de $k$ con resistores comerciales E24 para armar la tabla del Punto 4. (Deberá exportarse también como Live Script `.mlx` para la entrega final junto con las simulaciones del Punto 5).
- `stepinfo.m`: Función auxiliar compatible con MATLAB para extraer `RiseTime`, `SettlingTime` (2%), `Overshoot`, `Peak` y `PeakTime` de las curvas simuladas.
- `TP_Lab1_Ideal.slx`: Modelo físico en Simscape del circuito de la Figura 1 usando bloques `Op-Amp` ideales (para el Punto 5).
- `TP_Lab1_TL081.slx`: Modelo físico en Simscape usando bloques `Band-Limited Op-Amp` configurados con los parámetros del TL081 (para los Puntos 6 y 7).
- `figuras/`: Esquemas del circuito (`figura_1.png`), diagrama de bloques (`figura_2.png`) y gráficos de resultados.

## 3. Reglas de Estilo y Redacción del Informe (`informe_parte1.tex`)
1. **Tono de estudiante real de ingeniería**: La redacción debe ser sobria, directa, clara y concisa. **Evitar terminología inflada o adjetivos típicos de IA** (como *"demostraremos fielmente"*, *"disminuye monótonamente"*, *"error inaceptablemente alto"*).
2. **Solo lo que pide la consigna**:
   - No agregar demostraciones de libro de texto no solicitadas (por ejemplo, en el Punto 2 usar directamente la ecuación temporal y las fórmulas de segundo orden sin expandir fracciones simples ni derivar para demostrar de dónde sale $T_p$).
   - No duplicar gráficos: los Puntos 2 y 4 de la Parte A son analíticos (ecuaciones y tabla); los gráficos superponiendo la función de transferencia teórica (`step`) contra el circuito físico en Simscape corresponden al **Punto 5** (Parte B).
3. **Estética limpia en LaTeX**: Mantener formato `article` estándar en negro, sin encabezados coloreados ni exceso de recuadros `\boxed{}`.

## 4. Dinámica de Trabajo con el Usuario
- **Priorizar el aprendizaje activo**: El usuario busca comprender a fondo cada punto físico y matemático. Antes de volcar resultados nuevos (como el Punto 5), hacerle preguntas conceptuales o de predicción física y guiarlo de forma interactiva.
- **Confirmar antes de modificar**: Proponer los cambios y esperar confirmación del usuario antes de editar el código o el informe.
- **Visualización de PDFs**: El IDE abre los enlaces `[archivo.pdf](file:///...)` como binario crudo. Nunca usar links `file://` clickeables para PDFs; en su lugar, abrirlos en Google Chrome mediante `google-chrome "/ruta/absoluta/archivo.pdf" >/dev/null 2>&1 &` o dejar la ruta en un bloque de código.
