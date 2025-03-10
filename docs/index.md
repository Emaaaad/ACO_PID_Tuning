# **Optimal Tuning of PID Controller in Time Delay Systems Using Metaheuristic Algorithms**

## **Introduction**
This project focuses on optimizing **PID controller** parameters for **time delay systems** using the **Ant Colony Optimization (ACO) algorithm**. The objective is to enhance **control performance** by reducing error and improving stability.

## **PID Controller Fundamentals**
A **PID (Proportional-Integral-Derivative) controller** is defined as:

$$ u(t) = K_p e(t) + K_i \int e(t) dt + K_d \frac{de(t)}{dt} $$

where:
- \( K_p \) is the **proportional gain**
- \( K_i \) is the **integral gain**
- \( K_d \) is the **derivative gain**
- \( e(t) \) is the error between the desired and actual output

In **time delay systems**, control is challenging due to **phase lag** and potential stability issues.

## **Time Delay System Model**
A typical **first-order time delay system (FOTD)** is modeled as:

$$ G(s) = \frac{K}{T s + 1} e^{-sL} $$

where:
- \( K \) is the system gain
- \( T \) is the time constant
- \( L \) is the time delay

## **Metaheuristic Optimization Using Ant Colony Optimization (ACO)**
ACO is a bio-inspired optimization algorithm that simulates the foraging behavior of **ants** to determine optimal **PID parameters** \( K_p, K_i, K_d \). The optimization aims to minimize a performance index such as **Integral Time Absolute Error (ITAE):**

$$ ITAE = \int t |e(t)| dt $$

## **Implementation of ACO for PID Tuning**
The **ACO algorithm** iteratively updates the PID parameters by:
- Utilizing **pheromone trails** left by previous best solutions.
- Maintaining an **exploration-exploitation balance** to avoid local optima.

## **Performance Evaluation**
The optimized PID parameters result in:
✔ Faster **settling time**
✔ Reduced **overshoot**
✔ Improved **stability** in time delay systems

## **Repository Structure**
```
ACO_PID_Tuning/
│── docs/
│   ├── index.md  # This file
│── src/
│   ├── aco_pid.py  # Python script for optimization
│   ├── simulation.m  # MATLAB model
│── results/
│   ├── plots/  # Performance graphs
│── README.md
```

## **Usage Guide**
### **Running the Optimization (Python)**
1. Install dependencies:
   ```bash
   pip install numpy matplotlib
   ```
2. Execute the script:
   ```bash
   python src/aco_pid.py
   ```

### **Running the Simulation (MATLAB)**
1. Open `simulation.m` in MATLAB.
2. Run the script to visualize the system response.

## **Online Documentation**
📌 View this documentation online: [ACO_PID_Tuning](https://emaaaad.github.io/ACO_PID_Tuning/)

## **Contributions**
We welcome contributions! Feel free to fork this repository, open issues, or submit pull requests.
