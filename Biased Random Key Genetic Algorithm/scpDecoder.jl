
function scp_decode!(chromosome::Array{Float64}, instance::scpInstance,
    rewrite::Bool)::Float64
    instance = scpInstance(instance) # Make a copy
    covered = zeros(Int64, instance.num_lin)
    covered_total = 0
    solution = zeros(Int64, instance.num_col)
    cost = 0

    # Ordena as colunas pelos valores correspondentes em chrms (vetor de chaves aleatórias)
    column_indexes = sortperm(chromosome)
    i = 1
    
    while covered_total < instance.num_lin
        coluna = column_indexes[i]  # Seleciona a coluna com base nas chaves aleatórias ordenadas
        if instance.v_num_covered[coluna] == 0
            i += 1
            continue
        end
        solution[coluna] = 1
        cost += instance.v_cost[coluna]
        covered_total += selectCol(coluna, instance, covered)
        i += 1
    end
    return cost
end

function selectCol(col::Int64, instance::scpInstance, covered::Array{Int64})
    covered_total = 0
    for lin = 1:instance.num_lin
        if instance.m_coverage[lin,col] == 1
            for c = 1:instance.num_col
                if instance.m_coverage[lin,c] == 1
                    instance.m_coverage[lin,c] = 0
                    instance.v_num_covered[c] -= 1
                end
            end
            instance.m_coverage[lin,col] = 0
            covered_total += 1
        end
        if instance.m_coverage_starter[lin,col] == 1
            covered[lin] += 1
        end
    end
    return covered_total
end