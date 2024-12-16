# Set Covering Problem Study

This repository presents different Heuristic methods to tackle the Set Covering Problem. Among them:

- A Mathematical Model that calculates the optimal but takes a long time to run, as the SCP is a NP-Hard problem.
- A Greedy Algorithm that calculates a suboptimal solution (usually within 10% of the optimal) in a much shorter time.
- A constructive method that outputs random solutions
- A version of the same random constructive method with an additional local search
- An implementation of the BRKGA (Biased Random Key Genetic Algorithm) metaheuristic using the random constructive method as the decoder.