# 🔧 Digital Control – Project
This project is a professional adaptation of an academic task in **Digital Control Systems**, focusing on **Z-transform analysis**, **stability checks**, and **time/frequency domain simulations** using **MATLAB**.

It demonstrates the full engineering workflow from theoretical formulation to simulation, visualization, and result extraction – all structured for clarity, reproducibility and clean repository presentation.


## 📁 Project Structure

```
digital-control-lab/
├── code/            ← All MATLAB code (main.m, functions, etc.)
├── plots/           ← Auto-generated figures: step response, bode, pzmap
├── report/          ← Highlighted summary from the report 
├── Theory/          ← Includes theory background and numeric summary
└── README.md        ← This file – project overview
```
## ⚙️ Key Concepts

	•	Discrete-time state-space representation
	•	State-feedback via pole placement
	•	Dead-beat observer design
	•	DC gain compensation (steady-state tracking)
	•	Controller-only vs observer-based simulation
	•	Pole-zero analysis & stability via Z-domain
	•	MATLAB Control Toolbox usage
---

## 🚀 How to Run

	1.	Open code/digital_control_script.m in MATLAB
	2.	Run the script to:
	•	Define the system
	•	Simulate and plot responses
	•	Save output to /plots/ and /Theory/
	3.	Check Theory/summary.txt for numeric results
	4.	Review generated plots in plots/ for visual insight

---

## 📊 Sample Outputs

When the script runs, the following plots are generated:
	•	step_response.png – Closed-loop system response
	•	pzmap.png – Pole-zero map
	•	simulation_comparison.png – Output: full-state vs observer
	•	state_estimation_error.png – Error between true and estimated states

---

## 🧠 Motivation

This project demonstrates a full discrete control design pipeline: from system definition to simulation,
backed by theoretical context and clear MATLAB implementation.
It’s designed to be understandable, reusable, and easily adaptable for similar academic or engineering tasks.
