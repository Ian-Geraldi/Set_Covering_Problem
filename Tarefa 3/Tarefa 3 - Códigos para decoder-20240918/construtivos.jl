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

    println("Implemente outro metodo construtivo")
end


function randomConst(instance::scpInstance, chrms)

   
end
