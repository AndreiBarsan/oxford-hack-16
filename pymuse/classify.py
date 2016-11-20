#!/usr/bin/env python3
"""Simple utility which classifies EEG data.

The input should be a 516-dimensional feature vector, and the output should be
the class code--0 tense, 1 relaxed, 2 baseline.

Expects the feature vector to be passed as a single string, i.e. between quotes.
"""

import numpy as np

import os
import pickle
import sys

FEATURE_COUNT = 516
PICKLE_FPATH = os.path.join('.', 'model-lr.pkl')


def classify(clf, feats: np.ndarray) -> int:
    return int(clf.predict(feats.reshape(1, -1)))


def main(argv):
    result = argv[1]
    res_vec = [float(part) for part in result.split(", ")]

    if len(res_vec) != FEATURE_COUNT:
        raise ValueError("Expected {0}-d vector, but got {1}-d one.".format(
            FEATURE_COUNT, len(res_vec)
        ))

    with open(PICKLE_FPATH, 'rb') as f:
        clf = pickle.load(f)

    print(classify(clf, np.array(res_vec)))


if __name__ == '__main__':
    main(sys.argv)
