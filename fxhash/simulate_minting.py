from itertools import combinations
import numpy as np
from random import randint
import pandas as pd


NUM_MINTED = 1000
REPEATS = 100


def mint():
    xf1_min = max(randint(-1,3),0)
    xf1_max = max(randint(0,3), xf1_min)
    xf2_min = max(randint(-1,3),0)
    xf2_max = max(randint(0,3), xf2_min)
    yf1_min = max(randint(-1,3),0)
    yf1_max = max(randint(0,3), yf1_min)
    yf2_min = max(randint(-1,3),0)
    yf2_max = max(randint(0,3), yf2_min)
    palette = randint(1,15)
    brush = randint(1,4)
    brush_h = max(randint(-1,3),0)
    brush_w = max(randint(-1,3),0)
    brush_wiggle = max(randint(-3,4),0)
    mirror_type = max(randint(-3,3),0)
    mirror_type_correct = {
      0: 0,
      1: 5,
      2: 6,
      3: 7
    }
    mirror_type = mirror_type_correct[mirror_type]

    palettes = {
      1: "heatmap",
      2: "heatmap_green",
      3: "blue_white_green",
      4: "yellow_orange_red",
      5: "black_green",
      6: "black_blue",
      7: "purple_white_blue",
      8: "purple_white_green",
      9: "pnk_prpl_rd_yllw",
      10: "mono_loops",
      11: "stock_pico8",
      12: "secret_pico8",
      13: "dead_god",
      14: "dead_god_awake",
      15: "Guandanarian"
    }

    brushes = {
      1: "rect",
      2: "rectfill",
      3: "oval",
      4: "ovalfill"
    }

    brushes_label = brushes[brush]
    if (brush_h == 0 & brush_w == 0):
        brushes_label = "pixel"
    if ((brush_h == 0 and not (brush_w == 0)) or (brush_w == 0 and not (brush_h == 0))):
        brushes_label = "line"

    mirror_labels = {
      0: "none",
      5: "horizontal",
      6: "vertical",
      7: "double"
    }


    return np.array([
        xf1_min,xf1_max,xf2_min,xf2_max,yf1_min,yf1_max,yf2_min,yf2_max,
        palettes[palette],
        brushes_label,
        brush_h,
        brush_w,
        brush_wiggle,
        mirror_labels[mirror_type]
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
