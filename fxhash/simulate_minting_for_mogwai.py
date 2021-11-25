from itertools import combinations
import numpy as np
from random import randint
import pandas as pd


NUM_MINTED = 100
REPEATS = 100


def mint():
    return np.array([
        randint(1,270),
        randint(1,100)
        ])

total_stats = {}
for i in range(REPEATS):
    print(f"simulating: {i}")
    all_mints = [mint() for _ in range(NUM_MINTED)]
    comparisons = []
    for a,b in combinations(all_mints,2):
        comparisons.append(round(np.sum(a==b)/len(a),2))
    stats = pd.Series(comparisons).value_counts()
    for key in stats.index:
        if key not in total_stats:
            total_stats[key] = stats[key]
        else:
            total_stats[key] += stats[key]

final_stats = []
for key in total_stats:
    total_stats[key] = total_stats[key] / REPEATS
    final_stats.append((key, total_stats[key]))

final_stats.sort(key=lambda y: y[0])
print(f"On average, when minting {NUM_MINTED} pieces, simulated {REPEATS} times, a given pair will have X% identical features this many times:\n")
print(final_stats)
