# Ant Colony Optimization (ACO)-Based PID Controller Tuning for a Time-Delayed System

**Note:** This project was my Bachelor thesis during my studies at Qazvin Azad University under the supervision of [Prof. Hamid Qadiri](https://scholar.google.com/citations?user=NFe6cnoAAAAJ&hl=en).


---

## **1. Introduction**
This project focuses on designing and tuning a Proportional–Integral–Derivative (PID) controller using Ant Colony Optimization (ACO) for a time-delayed system. The main objective is to minimize the Integral of Time-weighted Absolute Error (ITAE), which helps achieve a desirable transient response (reduced overshoot, faster settling time, and minimal steady-state error).

Time delays and system dynamics can complicate the tuning of a PID controller. Traditional tuning methods may not yield optimal performance in such cases. ACO provides a robust stochastic optimization approach to iteratively refine PID gains and achieve a superior closed-loop response.

---

## **2. System Definition and Delay Modeling**

1. **Plant Transfer Function**  
   We begin with a simple second-order transfer function:
   \[
   G(s) = \frac{1}{s^2 + 2s + 3}.
   \]
   This system is stable but exhibits transient behavior determined by its poles.

2. **Time Delay**  
   A time delay is introduced, represented by the exponential term \( e^{-s} \). Direct simulation of this pure delay is challenging, so a first-order Padé approximation is used:
   \[
   \exp(-s) \approx \frac{1 - \frac{s}{2}}{1 + \frac{s}{2}}.
   \]
   This rational approximation allows MATLAB to simulate the system with delay.

3. **Closed-Loop Feedback**  
   The open-loop system with delay is \( G_{\text{delay}}(s) = G(s) \cdot \exp(-s) \). With unity feedback, the closed-loop transfer function is obtained.

---

## **3. PID Controller and Control Objective**

1. **PID Controller Structure**  
   The PID controller is defined as:
   \[
   G_c(s) = K_p + \frac{K_i}{s} + K_d \, s,
   \]
   where \( K_p \), \( K_i \), and \( K_d \) are the proportional, integral, and derivative gains, respectively.

2. **ITAE (Integral of Time-weighted Absolute Error)**  
   The ITAE criterion is used to evaluate the closed-loop performance:
   \[
   \text{ITAE} = \int_{0}^{T} t \, | e(t) | \, dt,
   \]
   where \( e(t) \) is the error between the reference and system output. Minimizing ITAE generally results in faster settling times and reduced overshoot.

---

## **4. Ant Colony Optimization (ACO)**

1. **ACO Inspiration**  
   ACO is inspired by the foraging behavior of ants, where pheromones deposited on promising paths guide others to follow, eventually leading to an optimal solution. This concept is used to find the optimal PID gains.

2. **ACO Parameters**  
   - **Number of Ants (N):** Determines the number of candidate solutions sampled per iteration.  
   - **Pheromone Decay Factor (\(\phi\)):** Controls how quickly pheromone trails evaporate.  
   - **Scaling Factor (Sca_fact):** Scales the pheromone update based on the best solution in each iteration.  
   - **Search Space (a, b, h_size):** Defines the range of possible PID gains (from 0 to 1000 in steps of 5).

3. **ACO Main Loop**  
   - **Initialization:** PID gains (\(K_p, K_i, K_d\)) are discretized into candidate values, each starting with a uniform pheromone level.
   - **Probability Calculation:** For each gain, the probability of selecting a value is proportional to its pheromone level.
   - **Roulette-Wheel Selection:** Each ant selects candidate gains based on the probability distribution.
   - **Objective Function Evaluation:** The selected PID gains are used to simulate the closed-loop response, and the ITAE is computed.
   - **Pheromone Update:**  
     - Increase pheromone on the best solution (lowest ITAE).  
     - Evaporate pheromone on all other solutions.
   - **Convergence:** The pheromone distribution converges toward the optimal PID gains over iterations.

---

## **5. Code Structure**

1. **System Setup:**  
   - Define the transfer function \( G(s) \).  
   - Apply the Padé approximation for the delay.  
   - Plot the **Step Response of Original System with Delay** (Figure 1).

2. **ACO Initialization:**  
   - Set the number of ants, pheromone decay factor, scaling factor, and number of iterations.  
   - Define the search space for \(K_p, K_i, K_d\).  
   - Initialize the pheromone matrices.

3. **Main ACO Loop:**  
   - Calculate selection probabilities for each candidate value.  
   - Use roulette-wheel selection for each ant to pick PID gains.
   - Simulate the system to compute the ITAE for each candidate solution.
   - Update the pheromones and track the best solution.

4. **Result Visualization:**  
   - **Figure 1:** Step Response of the Original System with Delay.  
   - **Figure 2:** Step Response with the Optimized PID Controller.  
   - **Figure 3:** ITAE vs. Iterations.

---

## **6. Results and Figures**

### **Figure 1: Step Response of Original System with Delay**
![Step Response of Original System with Delay](./pictures/Figure1.jpg)
1. **Analysis:**  
   - Displays the transient behavior of the original time-delayed system without PID control.
   - Shows overshoot and undershoot, indicating the negative impact of delay on performance.
   - Highlights the need for a robust PID controller.

2. **Interpretation:**  
   - The natural system has poor damping, necessitating improved control via tuning.

---

### **Figure 2: Step Response with Optimized PID Controller**
![Step Response with Optimized PID Controller](./pictures/Figure2.jpg)
1. **Analysis:**  
   - Represents the step response after applying the optimized PID gains determined by the ACO algorithm.
   - Exhibits a faster settling time and reduced oscillations compared to the original system.
   - Contains a minor overshoot, but overall performance is significantly improved.

2. **Interpretation:**  
   - The optimized controller enables the system to track the reference input more effectively with enhanced transient response.

---

### **Figure 3: ITAE with Each Iteration**
![ITAE with Each Iteration](./pictures/Figure3.jpg)
1. **Analysis:**  
   - Illustrates the evolution of the ITAE cost function across ACO iterations.
   - A high initial ITAE value decreases steadily, indicating improved control performance.
   - Convergence of the ITAE suggests that the optimal PID gains have been reached.

2. **Interpretation:**  
   - The decreasing ITAE trend validates the effectiveness of the ACO approach in optimizing the PID controller.

---

## **7. Why We Use These Methods**

1. **Time-Delayed Systems:**  
   - Delays (e.g., transport delays, sensor lags) are common in practical systems.
   - The Padé approximation converts the pure delay into a rational function suitable for control design.

2. **ACO for Optimization:**  
   - **Robustness:** ACO can overcome local minima better than traditional methods.
   - **Exploration vs. Exploitation:** Pheromone updates balance discovering new candidate solutions with exploiting the best ones.
   - **Discrete Tuning:** Discretizing PID gains allows efficient navigation through the search space.

3. **ITAE Cost Function:**  
   - Emphasizes both the magnitude and duration of errors, promoting quick error reduction.
   - Typically results in fast and stable system responses with minimal overshoot.

---

## **8. How to Run the Code**

1. **Prerequisites:**  
   - MATLAB (with the Control System Toolbox).
   - Basic familiarity with MATLAB scripting and control system simulation.

2. **Execution Steps:**  
   - Open the MATLAB script (e.g., `PID_ACO.m`) in your MATLAB environment.
   - Run the script.
   - The script will display the final PID gains and the minimum ITAE value in the command window.
   - Three figures will be generated:
     1. **Figure 1:** Step Response of the Original System with Delay.
     2. **Figure 2:** Step Response with the Optimized PID Controller.
     3. **Figure 3:** ITAE vs. Iterations.

3. **Modifying Parameters:**  
   - Experiment with different ACO parameters (number of ants, pheromone decay, scaling factor, iterations) to observe their impact on performance.
   - Adjust the search space parameters (lower bound, upper bound, step size) to refine PID tuning.
   - Consider exploring alternative objective functions or constraints based on specific application requirements.

---

## **9. Conclusion**
This project demonstrates how **Ant Colony Optimization** can be effectively applied to tune a **PID controller** for a **time-delayed second-order system**. By minimizing the **ITAE** criterion, the optimized controller significantly enhances the closed-loop performance—achieving fast settling times, reduced overshoot, and improved overall stability.

The results are summarized by:
- **Figure 1:** The suboptimal performance of the original system with delay.
- **Figure 2:** The improved step response after PID tuning.
- **Figure 3:** The convergence of the ITAE cost function across iterations.

These results validate the effectiveness of ACO in addressing complex, multi-parameter optimization problems in control systems, and underscore the advantages of using the ITAE metric in controller design.

---
