import numpy as np

def constByCost(instance):
    descoberto = True
    v_cobertura = np.zeros(instance.num_lin, dtype=np.int64)

    v_sol = np.zeros(instance.num_col, dtype=np.int64)
    cost_sol = 0

    # Sort indices by the cost (equivalent of sortperm in Julia)
    v_ind = np.argsort(instance.v_cost)

    j = 0
    while descoberto:
        coluna = v_ind[j]
        v_sol[coluna] = 1
        cost_sol += instance.v_cost[coluna]

        descoberto = False
        for linha in range(instance.num_lin):
            v_cobertura[linha] += instance.m_coverage[linha][coluna]
            if v_cobertura[linha] == 0:
                descoberto = True

        j += 1

    return v_sol, cost_sol, v_cobertura


def outroConst(instance):
    print("Implemente outro metodo construtivo")
    

def randomConst(instance, chrms):
    v_cobertura = np.zeros(instance.num_lin, dtype=np.int64)
    v_sol = np.zeros(instance.num_col, dtype=np.int64)
    cost_sol = 0
    
    # Sort columns by their corresponding values in the chrms (random keys vector)
    v_ind = np.argsort(chrms)
    
    j = 0
    descoberto = True
    
    while descoberto:
        coluna = v_ind[j]  # Select the column based on sorted random keys
        v_sol[coluna] = 1  # Mark the column as selected
        cost_sol += instance.v_cost[coluna]  # Add the cost of the selected column
        
        descoberto = False
        for linha in range(instance.num_lin):
            v_cobertura[linha] += instance.m_coverage[linha][coluna]
            if v_cobertura[linha] == 0:
                descoberto = True  # If any row is still uncovered, continue selecting
        
        j += 1
    
    return v_sol, cost_sol, v_cobertura