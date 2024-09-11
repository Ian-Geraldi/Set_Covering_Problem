function constByCost(instance::scpInstance)
    
    descoberto = true
    v_cobertura = zeros(Int64, instance.num_lin)

    v_sol = zeros(Int64, instance.num_col)
    cost_sol = 0

    v_ind = sortperm(instance.v_cost)

    j=1
    while descoberto
        coluna = v_ind[j]
        v_sol[coluna]=1
        cost_sol = cost_sol + instance.v_cost[coluna]

        descoberto = false
        for linha = 1:instance.num_lin
            v_cobertura[linha] = v_cobertura[linha] + instance.m_coverage[linha,coluna]
            if v_cobertura[linha]==0 
                descoberto = true
            end
        end

        j=j+1
    end
    return v_sol, cost_sol, v_cobertura
end



function outroConst(instance::scpInstance)
    covered = zeros(Int64, instance.num_lin)
    covered_total = 0
    solution = zeros(Int64, instance.num_col)
    cost = 0
    while sum(covered) < instance.num_lin
        col = calculateCost(instance)
        solution[col] = 1
        cost += instance.v_cost[col]

        for lin = 1:instance.num_lin
            if instance.m_coverage[lin,col] == 1
                for col = 1:instance.num_col
                    instance.m_coverage[lin,col] = 0
                end
                instance.m_coverage[lin,col] = 0
                covered[lin] = 1
                covered_total += 1
            end
        end
        println("Covered total: ", covered_total)
    end
    return solution, cost, covered
end

function calculateCost(instance:: scpInstance)
    coverage = zeros(Float64,instance.num_col)
    for col = 1:instance.num_col
        num_covered = 0
        for lin = 1:instance.num_lin
            if instance.m_coverage[lin,col] == 1
                num_covered += 1
            end
        end
        coverage[col] = num_covered/instance.v_cost[col]
    end
    max_value, index = findmax(coverage)
    return index
end