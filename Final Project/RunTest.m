% this file runs all of the tests we're interested in

clear all

[p r] = GestureGetDataByLabel('high_kick');

[optimal_gesture alignment_indices] = LearnOptimalGesture(r);

p
r
size(optimal_gesture)
alignment_indices

%GestureVisualize(optimal_gesture);