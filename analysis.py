#!python

import numpy as np
import matplotlib.pyplot as plt
from scipy.optimize import curve_fit

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

def exponential_func(x, a, b):
    return a * np.exp(b * x)

def plot_similarity(dimensions, avg_similarities):
    plt.plot(range(1, dimensions + 1), avg_similarities, marker='o', label='Data')
    plt.xlabel('Dimension')
    plt.ylabel('Average Cosine Similarity')
    plt.title('Average Cosine Similarity for Different Dimensions')
    plt.grid(True)

    # Fit exponential curve
    popt, pcov = curve_fit(exponential_func, range(1, dimensions + 1), avg_similarities)
    y_fit = exponential_func(range(1, dimensions + 1), *popt)
    plt.plot(range(1, dimensions + 1), y_fit, color='red', label='Exponential Fit')

    plt.legend()
    plt.show()

# Parameters
num_dimensions = 30  # Number of dimensions to consider
num_pairs = 10000     # Number of random vector pairs to generate for each dimension

# Calculate average similarities
avg_similarities = calculate_average_similarity(num_dimensions, num_pairs)

# Plot the results with exponential fit
plot_similarity(num_dimensions, avg_similarities)
