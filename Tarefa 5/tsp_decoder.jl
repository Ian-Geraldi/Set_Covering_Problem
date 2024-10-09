
function tsp_decode!(chromosome::Array{Float64}, instance::TSP_Instance,
    rewrite::Bool)::Float64

permutation = Array{Tuple{Float64, Int64}}(undef, instance.num_nodes)
for (index, key) in enumerate(chromosome)
permutation[index] = (key, index)
end

sort!(permutation)

cost = distance(instance, permutation[1][2], permutation[end][2])
for i in 1:(instance.num_nodes - 1)
cost += distance(instance, permutation[i][2], permutation[i + 1][2])
end

return cost
end

# function scp_decode!(chromosome::Array{Float64}, instance::scpInstance,
#     rewrite::Bool)::Float64
#     permutation = Array{Tuple{Float64, Int64}}(undef, instance.num_col)

# end
