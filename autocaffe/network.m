use timeseries

: leaky-relu
    0.1 lrelu
; 

: perceptron ( n -- layer )
    innerproduct leaky-relu
; 

: perceptron-dropout ( n -- layer )
    innerproduct leaky-relu
    0.5 dropout
; 

: shrink ( n -- n )
    2 * 3 /
; 

: six-layer-network ( l -- l )
    ${nn-size} perceptron
    ${nn-size} shrink perceptron
    ${nn-size} shrink shrink perceptron
    ${nn-size} shrink shrink shrink perceptron
    ${nn-size} shrink shrink shrink shrink perceptron
    ${nn-size} shrink shrink shrink shrink shrink perceptron-dropout
; 

: network ( l -- l )
    named temps 
        six-layer-network
        1 innerproduct
    end-named
; 

: train ( -- l )
  4 5 ... ${input-size} take { input-indices }
  "dengue/train/nn" csv train
    input-indices := xs
    3 := y0
    1 := y
  "dengue/test/nn" csv test
    input-indices := xs
    3 := y0
    2 := y
    
   network '$y0 +
   '$y euclidean >> loss
; 

: deploy ( -- ) 

  4 5 ... ${input-size} take { input-indices }
  "${deploy-source}" csv
    input-indices := xs
    3 := y0
    1 .batch_size
    false .load_once
 
  network '$y0 + >> prediction
; 

: solver 
  %s solver_mode "CPU"
  %s max_iter 10000
  %s type "${solver-type}"
  %s early_stop 25 20

  %s gamma 0.4
  %s momentum2 0.999
  %s delta 0.00000001
;
