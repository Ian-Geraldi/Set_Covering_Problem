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
    while covered_total<instance.num_lin
        col = calculateCost(instance)
        solution[col] = 1
        cost += instance.v_cost[col]
        covered_total += selectCol(col, instance, covered)
        
        println("Covered total: ", covered_total)
    end
    return solution, cost, covered
end

function randomConst(instance::scpInstance, chrms)
    covered = zeros(Int64, instance.num_lin)
    covered_total = 0
    solution = zeros(Int64, instance.num_col)
    cost = 0

    # Ordena as colunas pelos valores correspondentes em chrms (vetor de chaves aleatórias)
    column_indexes = sortperm(chrms)
    i = 1
    
    while covered_total < instance.num_lin
        coluna = column_indexes[i]  # Seleciona a coluna com base nas chaves aleatórias ordenadas
        if instance.v_num_covered[coluna] == 0
            print("Coluna $coluna não cobre nenhuma linha. Pulando...\n")
            i += 1
            continue
        end
        solution[coluna] = 1
        cost += instance.v_cost[coluna]
        covered_total += selectCol(coluna, instance, covered)

        println("Iteração $i: Custo atual = $cost, Linhas cobertas = $(sum(covered .> 0))")
        i += 1
    end

    # before returning the solution, we check if there are any redundant columns
    for col = 1:instance.num_col
        is_redundant = true
        for line = 1:instance.num_lin
            if instance.v_times_covered[col] == 1
                is_redundant = false
                break
            end
        end
        if is_redundant
            solution[col] = 0
            cost -= instance.v_cost[col]
            for line = 1:instance.num_lin
                if instance.m_coverage[line, col] == 1
                    instance.v_times_covered[col] -= 1
                end
            end
        end
    end
    
    return solution, cost, covered
end

function calculateCost(instance:: scpInstance)
    coverage = zeros(Float64,instance.num_col)
    for col = 1:instance.num_col
        coverage[col] = instance.v_num_covered[col]/instance.v_cost[col]
    end
    max_value, index = findmax(coverage)
    return index
end

function cobreNovaLinha(coluna::Int64, instance::scpInstance)
    for linha = 1:instance.num_lin
        if instance.m_coverage[linha,coluna] == 1
            return true
        end
    end
    return false
end

# faz o upkeep de selecionar uma matriz e retorna quantas novas linhas foram cobertas ao selecioná-la
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
            covered[lin] = 1
            covered_total += 1
        end
    end
    return covered_total
end