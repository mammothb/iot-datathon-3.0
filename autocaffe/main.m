terra/ac
project: dengue

: data 
    \ you need to create train.csv and test.csv
    \ using data access! 
    "test.csv" preprocess 
    "train.csv" preprocess
    "validation.csv" preprocess
    "test-preprocessed.csv"  "dengue/test/nn"  csv>data
    "train-preprocessed.csv" "dengue/train/nn" csv>data
    "validation-preprocessed.csv"  "dengue/validation/nn"  csv>data
; 

network: network.m

: losses
    best-config@ train-loss . cr
    best-config@ test-loss  . cr
    1 nconfigs plot-losses cr
    all-config
; 

: evaluate
    {{ best-config@ }} evaluate
; 

: plot-predictions
    best-config@ { n }
    n . cr
    n 1 (plot-train-predictions) cr
    n 2 (plot-test-predictions) cr
    n 1 2 (plot-scatter) cr
    n 104 1 2 (plot-lags) cr
; 

\ This will will retrieve the predictions for an evaluated
\ configuration and save is as "predictions.csv"
\ Syntax for eval>csv:
\ <config#> <eval#> "filename" EVAL<CSV
\ <eval#> is in eval-config.m. 1 = train data , 2 = test data. 
\ this is set to test data = 2. 
: save-predictions
    best-config@ 1 "train-predictions.csv" eval>csv
    best-config@ 2 "test-predictions.csv" eval>csv
    best-config@ 3 "validation-predictions.csv" eval>csv
; 

\ <model name> <config#> deploy-model
\ Eg. "my-model" 1 deploy-model
: deploy-model 
    "convergence-nn-final-05" best-config@ deploy-model
;
