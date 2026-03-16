function D = geometry_diameter(V, K, chamber_length_cm)
D = 2 * sqrt((3 * V) ./ (2 * pi * K * chamber_length_cm));
end
