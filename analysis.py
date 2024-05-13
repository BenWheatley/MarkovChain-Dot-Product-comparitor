#!python

import numpy as np
import matplotlib.pyplot as plt
import csv

def generate_random_unit_vector(dimension):
    vec = np.random.randn(dimension)
    return vec / np.linalg.norm(vec)

def cosine_similarity(vec1, vec2):
    return np.dot(vec1, vec2) / (np.linalg.norm(vec1) * np.linalg.norm(vec2))

def calculate_average_similarity(dimensions, num_pairs):
    avg_similarities = []
    for d in range(1, dimensions + 1):
        similarities = []
        for _ in range(num_pairs):
            vec1 = generate_random_unit_vector(d)
            vec2 = generate_random_unit_vector(d)
            similarities.append(abs(cosine_similarity(vec1, vec2)))
        avg_similarity = np.mean(similarities)
        avg_similarities.append(avg_similarity)
    return avg_similarities

def plot_similarity(dimensions, avg_similarities, output_csv):
    data = np.vstack((range(1, dimensions + 1), avg_similarities)).T
    np.savetxt(output_csv, data, delimiter=',', header='Dimension,Average Cosine Similarity', comments='', fmt='%d,%.6f')

    plt.plot(range(1, dimensions + 1), avg_similarities, marker='o')
    plt.xlabel('Dimension')
    plt.ylabel('Average Cosine Similarity')
    plt.title('Average Cosine Similarity for Different Dimensions')
    plt.grid(True)
    plt.show()

# Parameters
num_dimensions = 50  # Number of dimensions to consider
num_pairs = 10000     # Number of random vector pairs to generate for each dimension
output_csv = 'graph_values.csv'  # Output CSV file path

# Calculate average similarities
avg_similarities = calculate_average_similarity(num_dimensions, num_pairs)

# Plot the results and export graph values as CSV
plot_similarity(num_dimensions, avg_similarities, output_csv)
