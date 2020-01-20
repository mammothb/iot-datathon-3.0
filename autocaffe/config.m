\ Sizes for the Neural Network
{{ 512 }} := nn-size

\ The number of inputs 
\ You definitely need to amend this depending on 
\ the number of features you use.
{{ 106 }} := input-size

\ Max iterations for solver. 
10000 := iters

\ Solver type. 
\ Adam is highly optimized for gradient descent. (default)
\ SGD is Stochasic Gradient Descent. (can be better in some cases) 
"Adam" := solver-type
5 repeats
