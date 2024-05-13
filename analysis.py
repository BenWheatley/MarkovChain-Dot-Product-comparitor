#!python

import numpy as np
import matplotlib.pyplot as plt
from sklearn.preprocessing import PolynomialFeatures
from sklearn.linear_model import LinearRegression

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

def plot_similarity(dimensions, avg_similarities):
    plt.plot(range(1, dimensions + 1), avg_similarities, marker='o', label='Data')
    plt.xlabel('Dimension')
    plt.ylabel('Average Cosine Similarity')
    plt.title('Average Cosine Similarity for Different Dimensions')
    plt.grid(True)

    # Polynomial regression
    poly = PolynomialFeatures(degree=3)  # You can adjust the degree of the polynomial
    X = np.array(range(1, dimensions + 1)).reshape(-1, 1)
    X_poly = poly.fit_transform(X)
    y = np.array(avg_similarities)
    model = LinearRegression()
    model.fit(X_poly, y)
    y_pred = model.predict(X_poly)
    plt.plot(X, y_pred, color='red', label='Best-fitting Monomial')

    plt.legend()
    plt.show()

# Parameters
num_dimensions = 10  # Number of dimensions to consider
num_pairs = 1000     # Number of random vector pairs to generate for each dimension

# Calculate average similarities
avg_similarities = calculate_average_similarity(num_dimensions, num_pairs)

# Plot the results
plot_similarity(num_dimensions, avg_similarities)
