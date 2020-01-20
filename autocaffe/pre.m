: map_sum ( seq -- n )
    0 SWAP ['] +. REDUCE
; 

: ewm ( seq n -- n ) { xs s }
    2 s 1 +. /. { alpha }
    0 1 ... s TAKE [: alpha SWAP ^ ;] MAP { top }
    top xs ['] *. ZIPWITH map_sum top map_sum /.
; 

: get-gradient ( seq n n -- n ) { xs xmean n }
    xs [: xmean -. ;] MAP 0 1 ... n TAKE [: n 2 /. -. ;] MAP ['] *. ZIPWITH SUM
    xs [: xmean -. ;] MAP xs [: xmean -. ;] MAP ['] *. ZIPWITH SUM /.
; 

: norm_temperature ( seq -- seq )
    [: 25 /. ;] MAP
; 

: norm_rainfall ( seq -- seq )
    [: 64 /. ;] MAP
; 

: norm_weekly ( seq -- seq )
    [: 7 /. ;] MAP
; 

: log_trans ( seq -- seq )
    [: 1 +. LN ;] MAP
; 

: transform
    A:8:7 2 ewm   \ training label
    A:8           \ 8-week ahead forecast
    A:0:-1 2 ewm  \ y0 for differencing
    
    \ ========== dengue-sg-log ==========
    A:0:-10 11 ewm
    A:0:-3 A:0:-3 MEAN 4 get-gradient
    
    \ ========== population-sg-log ==========
    2:-30
    
    \ ========== hw-season ==========
    41:8:1
    41:0

    \ ========== temperature-avg ==========
    4:0 norm_temperature
    4:-11:-18 norm_temperature
    4:-27:-30 norm_temperature

    \ ========== abs-humidity-avg ==========
    40:0 [: 100 /. ;] MAP
    40:-7:-9 [: 100 /. ;] MAP

    \ ========== rainfall-avg ==========
    9:0:-3 log_trans
    10:0:-3 log_trans
    11:0:-3 log_trans
    12:0:-3 log_trans
    13:0:-3 log_trans
    
    9:-9:-15 log_trans
    10:-9:-15 log_trans
    11:-9:-15 log_trans
    12:-9:-15 log_trans
    13:-9:-15 log_trans

    \ ========== rainfall-rainy-days ==========
    27:-7:-9 norm_weekly
    28:-7:-9 norm_weekly
    29:-7:-9 norm_weekly
    30:-7:-9 norm_weekly
    31:-7:-9 norm_weekly

    \ ========== rainfall-consecutive-days ==========
    38:-21:-22 norm_weekly

    \ ========== temperature-sg-max/min-diff ==========
    7:-28:-30 [: DUP 0.01 < IF DROP 0 ELSE ;] MAP
 
    \ ========== serotype-diff ==========
    43:-5:-7 43:-13:-15 ['] -. ZIPWITH [: ABS ;] MAP 43:-5:-7 43:-13:-15 ['] -. ZIPWITH [: ABS ;] MAP MEAN 3 get-gradient 100 /.
    43:-5:-7 MEAN
;
