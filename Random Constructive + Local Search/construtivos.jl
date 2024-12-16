function constDeterministico(instance::scpInstance)
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

function constDeterministicoBL(instance::scpInstance)
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
    println("Resultado antes da busca local: Custo = $cost")
    cost -= buscaLocal(instance, solution, covered)
    return solution, cost, covered
end

function randomConstBL(instance::scpInstance, chrms)
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
            print("Coluna $coluna não cobre nenhuma linha nova. Pulando...\n")
            i += 1
            continue
        end
        solution[coluna] = 1
        cost += instance.v_cost[coluna]
        covered_total += selectCol(coluna, instance, covered)

        println("Iteração $i: Custo atual = $cost, Linhas cobertas = $(covered_total)")
        i += 1
    end
    println("Resultado antes da busca local: Custo = $cost")
    cost -= buscaLocal(instance, solution, covered)
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
            print("Coluna $coluna não cobre nenhuma linha nova. Pulando...\n")
            i += 1
            continue
        end
        solution[coluna] = 1
        cost += instance.v_cost[coluna]
        covered_total += selectCol(coluna, instance, covered)

        println("Iteração $i: Custo atual = $cost, Linhas cobertas = $(covered_total)")
        i += 1
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

function buscaLocal(instance::scpInstance, solution::Array{Int64}, covered)
    cost_reduction = 0
    for c = 1:instance.num_col
        if solution[c] == 0
            continue
        end
        is_redundant = true
        for l = 1:instance.num_lin
            if instance.m_coverage_starter[l,c] == 1
                if covered[l] == 1
                    is_redundant = false
                    break
                end
            end
        end
        if is_redundant
            removeRedundantCol(c, instance, solution, covered)
            cost_reduction += instance.v_cost[c]
        end
    end
    println("Busca local - redução de custo: $cost_reduction")
    return cost_reduction

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

function removeRedundantCol(col::Int64, instance::scpInstance, solution::Array{Int64}, covered)
    for lin = 1:instance.num_lin
        if instance.m_coverage_starter[lin,col] == 1
            covered[lin] -= 1
        end
    end
    solution[col] = 0
end
