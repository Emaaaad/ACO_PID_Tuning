## **Ant Colony Optimization (ACO)-Based PID Controller Tuning for a Time-Delayed System**

**Note:** This project was my Bachelor thesis during my studies at Qazvin Azad University under the supervision of [Prof. Hamid Qadiri](https://scholar.google.com/citations?user=NFe6cnoAAAAJ&hl=en).

---

### **1. Introduction**
This project focuses on designing and tuning a Proportional–Integral–Derivative (PID) controller using Ant Colony Optimization (ACO) for a time-delayed system. The main objective is to minimize the Integral of Time-weighted Absolute Error (ITAE), achieving a desirable transient response with reduced overshoot, faster settling time, and minimal steady-state error.

Time delays and complex system dynamics can complicate PID tuning. Traditional methods may fall short in such cases. ACO provides a robust, stochastic optimization approach to iteratively refine PID gains and achieve superior closed-loop performance.

---

### **2. System Definition and Delay Modeling**

1. **Plant Transfer Function**  
   We begin with a simple second-order transfer function:

<div align="center">
  <img src="https://quicklatex.com/latex3.f/quicklatex.com-a2cbe0d2d34b42ef7efef21cc2209496_l3.png"
       alt="Example Formula"
       width="70%">
</div>

   This system is stable but exhibits transient behavior governed by its poles.

2. **Time Delay**  
   A time delay is introduced, represented by the exponential term:

<div align="center">
  <img src="https://latex.codecogs.com/png.latex?\dpi{150}e^{-s}&bg=FFFFFF" alt="Exponential formula"/>
</div>

   Because directly simulating a pure delay is challenging, a first-order Padé approximation is used:

<div align="center">
  <img src="https://latex.codecogs.com/png.latex?\dpi{150}e^{-s}\approx\frac{1-\frac{s}{2}}{1+\frac{s}{2}}&bg=FFFFFF" alt="Padé approximation formula"/>
</div>

   This rational approximation allows MATLAB to simulate the system with delay.

3. **Closed-Loop Feedback**  
   The open-loop system with delay is:

<div align="center">
  <img src="https://latex.codecogs.com/png.latex?\dpi{150}G_{\text{delay}}(s)=G(s)\,e^{-s}&bg=FFFFFF" alt="G_delay formula"/>
</div>

   With unity feedback, the closed-loop transfer function is obtained.

---

### **3. PID Controller and Control Objective**

1. **PID Controller Structure**  
   The PID controller is defined as:

<div align="center">
  <img src="https://latex.codecogs.com/png.latex?\dpi{150}G_c(s)=K_p+\frac{K_i}{s}+K_d\,s&bg=FFFFFF" alt="PID controller formula"/>
</div>

   where \(K_p\), \(K_i\), and \(K_d\) are the proportional, integral, and derivative gains, respectively.

2. **ITAE (Integral of Time-weighted Absolute Error)**  
   The ITAE criterion is used to evaluate the closed-loop performance:

<div align="center">
  <img src="https://latex.codecogs.com/png.latex?\dpi{150}\text{ITAE}=\int_{0}^{T}t\,\bigl|e(t)\bigr|\,dt&bg=FFFFFF" alt="ITAE formula"/>
</div>

   where *`e(t)`* is the error between the reference input and the system output. Minimizing ITAE typically results in faster settling times and reduced overshoot.

---

### **4. Ant Colony Optimization (ACO)**

1. **ACO Inspiration**  
   ACO is inspired by the foraging behavior of ants. Ants deposit pheromones on promising paths that guide others toward optimal routes. This mechanism is used to find the optimal PID gains.

2. **ACO Parameters**  
   - **Number of Ants (N):** Determines how many candidate solutions are sampled per iteration.  
   - **Pheromone Decay Factor (\( \phi \)):** Controls how quickly pheromone trails evaporate.  
   - **Scaling Factor (Sca_fact):** Scales the pheromone update based on the best solution in each iteration.  
   - **Search Space (`a`, `b`, `h_size`):** Defines the range of possible PID gains (from 0 to 1000 in steps of 5).

3. **ACO Main Loop**  
   - **Initialization:** Discretize the PID gains `K(p)`, `K(i)`, and `K(d)` into candidate values, each starting with a uniform pheromone level.  
   - **Probability Calculation:** For each candidate value, compute the selection probability proportional to its pheromone level.  
   - **Roulette-Wheel Selection:** Each ant selects candidate gains based on the computed probability distribution.  
   - **Objective Function Evaluation:** Simulate the closed-loop system using the selected PID gains and compute the ITAE.  
   - **Pheromone Update:**  
     - Increase the pheromone level for the best (lowest ITAE) solution.  
     - Evaporate the pheromone on other candidate values.  
   - **Convergence:** The pheromone distribution converges toward the optimal PID gains over iterations.

---

### **5. Code Structure**

1. **System Setup:**  
   - Define the transfer function `G(s)`.  
   - Apply the Padé approximation for the delay.  
   - Plot the **Step Response of the Original System with Delay** (Figure 1).

2. **ACO Initialization:**  
   - Set the number of ants, pheromone decay factor, scaling factor, and number of iterations.  
   - Define the search space for `K(p)`, `K(i)`, and `K(d)`.  
   - Initialize the pheromone matrices.

3. **Main ACO Loop:**  
   - Compute selection probabilities for each candidate value.  
   - Use roulette-wheel selection to choose PID gains for each ant.  
   - Simulate the system and compute the ITAE for each candidate solution.  
   - Update the pheromones and track the best solution.

4. **Result Visualization:**  
   - **Figure 1:** Step Response of the Original System with Delay.  
   - **Figure 2:** Step Response with the Optimized PID Controller.  
   - **Figure 3:** ITAE vs. Iterations.

---

### **6. Results and Figures**

### **Figure 1: Step Response of Original System with Delay**

<div align="center">
  <img src="https://github.com/Emaaaad/ACO_PID_Tuning/blob/main/Pictures/Figure1.jpg"
       alt="Step Response of Original System with Delay"
       width="70%">
</div>

**Analysis:**  
- Displays the transient behavior of the original time-delayed system without PID control.  
- Shows overshoot and undershoot, highlighting the adverse impact of delay on performance.  
- Emphasizes the need for a robust PID controller.

**Interpretation:**  
- The natural system suffers from poor damping, motivating the application of PID tuning to improve performance.

---

### **Figure 2: Step Response with Optimized PID Controller**

<div align="center">
  <img src="https://github.com/Emaaaad/ACO_PID_Tuning/blob/main/Pictures/Figure2.jpg"
       alt="Step Response with Optimized PID Controller"
       width="70%">
</div>

**Analysis:**  
- Represents the step response after applying the optimized PID gains from the ACO algorithm.  
- Exhibits faster settling time and reduced oscillations compared to the original system.  
- Shows a minor overshoot, but overall performance is significantly enhanced.

**Interpretation:**  
- The optimized controller enables the system to track the desired reference input effectively with an improved transient response.

---

### **Figure 3: ITAE with Each Iteration**

<div align="center">
  <img src="https://github.com/Emaaaad/ACO_PID_Tuning/blob/main/Pictures/Figure3.jpg"
       alt="ITAE with Each Iteration"
       width="70%">
</div>

**Analysis:**  
- Illustrates the evolution of the ITAE cost function across the ACO iterations.  
- A high initial ITAE value decreases steadily as the algorithm converges toward optimal PID gains.  
- The plateau at the end indicates that near-optimal gains have been achieved.

**Interpretation:**  
- The decreasing ITAE trend confirms the effectiveness of the ACO method in optimizing the PID controller.

---

### **7. Why We Use These Methods**

1. **Time-Delayed Systems:**  
   - Delays such as transport delays and sensor lags are common in practical systems.  
   - The Padé approximation converts the pure delay into a rational function that is amenable to standard control design techniques.

2. **ACO for Optimization:**  
   - **Robustness:** ACO can escape local minima better than traditional gradient-based methods.  
   - **Exploration vs. Exploitation:** The pheromone update mechanism balances exploring new candidate solutions with exploiting the best ones.  
   - **Discrete Tuning:** Discretizing PID gains enables efficient navigation through the search space.

3. **ITAE Cost Function:**  
   - Emphasizes both the magnitude and duration of error, promoting fast error reduction.  
   - Typically results in controllers that achieve a fast, stable response with minimal overshoot.

---

### **8. How to Run the Code**

1. **Prerequisites:**  
   - MATLAB (with the Control System Toolbox).  
   - Basic familiarity with MATLAB scripting and control system simulation.

2. **Execution Steps:**  
   - Open the MATLAB script (e.g., `PID_ACO.m`) in MATLAB.  
   - Run the script.  
   - The script will display the final PID gains and the minimum ITAE value in the command window.  
   - Three figures will be generated:  
     1. **Figure 1:** Step Response of the Original System with Delay.  
     2. **Figure 2:** Step Response with the Optimized PID Controller.  
     3. **Figure 3:** ITAE vs. Iterations.

3. **Modifying Parameters:**  
   - Experiment with different ACO parameters (number of ants, pheromone decay, scaling factor, iterations) to observe their impact on performance.  
   - Adjust the search space parameters (lower bound, upper bound, step size) to refine PID tuning.  
   - Consider exploring alternative objective functions or constraints based on your specific application.

---

### **9. Conclusion**
This project demonstrates how **Ant Colony Optimization** can be effectively applied to tune a **PID controller** for a **time-delayed second-order system**. By minimizing the **ITAE** criterion, the optimized controller significantly enhances the closed-loop performance—achieving fast settling times, reduced overshoot, and improved stability.

The results are summarized by:
- **Figure 1:** The suboptimal performance of the original system with delay.  
- **Figure 2:** The improved step response after PID tuning.  
- **Figure 3:** The convergence of the ITAE cost function across iterations.

These outcomes validate the effectiveness of ACO in solving complex, multi-parameter optimization problems in control systems, and they underscore the benefits of using the ITAE metric for controller design.

---
