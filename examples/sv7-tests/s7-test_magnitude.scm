(num-test (magnitude (make-rectangular (expt 2 62) (expt 2 62))) 6.521908912666391106174785903126254184439E18)
(num-test (magnitude (make-rectangular most-positive-fixnum most-negative-fixnum)) 1.30438178253327822116424650250659608445E19)
(num-test (magnitude (make-rectangular most-positive-fixnum most-positive-fixnum)) 1.304381782533278221093535824387941332006E19)
(num-test (magnitude -0) 0)
(num-test (magnitude -0.0) 0.0)
(num-test (magnitude -0.0+0.00000001i) 0.00000001)
(num-test (magnitude -0.0+1.0i) 1.0)
(num-test (magnitude -0.0+1234.0i) 1234.0)
(num-test (magnitude -0.0+1234000000.0i) 1234000000.0)
(num-test (magnitude -0.0+2.71828182845905i) 2.71828182845905)
(num-test (magnitude -0.0+3.14159265358979i) 3.14159265358979)
(num-test (magnitude -0.0-0.00000001i) 0.00000001)
(num-test (magnitude -0.0-1.0i) 1.0)
(num-test (magnitude -0.0-1234.0i) 1234.0)
(num-test (magnitude -0.0-1234000000.0i) 1234000000.0)
(num-test (magnitude -0.0-2.71828182845905i) 2.71828182845905)
(num-test (magnitude -0.0-3.14159265358979i) 3.14159265358979)
(num-test (magnitude -0.00000001) 0.00000001)
(num-test (magnitude -0.00000001+0.00000001i) 0.00000001414214)
(num-test (magnitude -0.00000001+1.0i) 1.0)
(num-test (magnitude -0.00000001+1234.0i) 1234.0)
(num-test (magnitude -0.00000001+1234000000.0i) 1234000000.0)
(num-test (magnitude -0.00000001+2.71828182845905i) 2.71828182845905)
(num-test (magnitude -0.00000001+3.14159265358979i) pi)
(num-test (magnitude -0.00000001-0.00000001i) 0.00000001414214)
(num-test (magnitude -0.00000001-1.0i) 1.0)
(num-test (magnitude -0.00000001-1234.0i) 1234.0)
(num-test (magnitude -0.00000001-1234000000.0i) 1234000000.0)
(num-test (magnitude -0.00000001-2.71828182845905i) 2.71828182845905)
(num-test (magnitude -0.00000001-3.14159265358979i) pi)
(num-test (magnitude -0/1) 0/1)
(num-test (magnitude -0/10) 0/10)
(num-test (magnitude -0/1234) 0/1234)
(num-test (magnitude -0/1234000000) 0/1234000000)
(num-test (magnitude -0/2) 0/2)
(num-test (magnitude -0/3) 0/3)
(num-test (magnitude -0/362880) 0/362880)
(num-test (magnitude -0/500029) 0/500029)
(num-test (magnitude -1) 1)
(num-test (magnitude -1.0) 1.0)
(num-test (magnitude -1.0+0.00000001i) 1.0)
(num-test (magnitude -1.0+1.0i) 1.41421356237310)
(num-test (magnitude -1.0+1234.0i) 1234.00040518631931)
(num-test (magnitude -1.0+1234000000.0i) 1234000000.0)
(num-test (magnitude -1.0+2.71828182845905i) 2.89638673159001)
(num-test (magnitude -1.0+3.14159265358979i) 3.29690830947562)
(num-test (magnitude -1.0-0.00000001i) 1.0)
(num-test (magnitude -1.0-1.0i) 1.41421356237310)
(num-test (magnitude -1.0-1234.0i) 1234.00040518631931)
(num-test (magnitude -1.0-1234000000.0i) 1234000000.0)
(num-test (magnitude -1.0-2.71828182845905i) 2.89638673159001)
(num-test (magnitude -1.0-3.14159265358979i) 3.29690830947562)
(num-test (magnitude -1.0e+00+0.0e+00i) 1e0)
(num-test (magnitude -1.0e+00+1.0e+00i) 1.4142135623730950488e0)
(num-test (magnitude -1.0e+00+1.19209289550781250e-07i) 1.0000000000000071054e0)
(num-test (magnitude -1.0e+00+2.0e+00i) 2.2360679774997896964e0)
(num-test (magnitude -1.0e+00+5.0e-01i) 1.1180339887498948482e0)
(num-test (magnitude -1.0e+00+8.3886080e+06i) 8.3886080000000596046e6)
(num-test (magnitude -1.0e+00-1.0e+00i) 1.4142135623730950488e0)
(num-test (magnitude -1.0e+00-1.19209289550781250e-07i) 1.0000000000000071054e0)
(num-test (magnitude -1.0e+00-2.0e+00i) 2.2360679774997896964e0)
(num-test (magnitude -1.0e+00-5.0e-01i) 1.1180339887498948482e0)
(num-test (magnitude -1.0e+00-8.3886080e+06i) 8.3886080000000596046e6)
(num-test (magnitude -1.19209289550781250e-07+0.0e+00i) 1.1920928955078125e-7)
(num-test (magnitude -1.19209289550781250e-07+1.0e+00i) 1.0000000000000071054e0)
(num-test (magnitude -1.19209289550781250e-07+1.19209289550781250e-07i) 1.6858739404357612715e-7)
(num-test (magnitude -1.19209289550781250e-07+2.0e+00i) 2.0000000000000035527e0)
(num-test (magnitude -1.19209289550781250e-07+5.0e-01i) 5.0000000000001421085e-1)
(num-test (magnitude -1.19209289550781250e-07+8.3886080e+06i) 8.3886080e6)
(num-test (magnitude -1.19209289550781250e-07-1.0e+00i) 1.0000000000000071054e0)
(num-test (magnitude -1.19209289550781250e-07-1.19209289550781250e-07i) 1.6858739404357612715e-7)
(num-test (magnitude -1.19209289550781250e-07-2.0e+00i) 2.0000000000000035527e0)
(num-test (magnitude -1.19209289550781250e-07-5.0e-01i) 5.0000000000001421085e-1)
(num-test (magnitude -1.19209289550781250e-07-8.3886080e+06i) 8.3886080e6)
(num-test (magnitude -1/1) 1/1)
(num-test (magnitude -1/10) 1/10)
(num-test (magnitude -1/1234) 1/1234)
(num-test (magnitude -1/1234000000) 1/1234000000)
(num-test (magnitude -1/2) 1/2)
(num-test (magnitude -1/3) 1/3)
(num-test (magnitude -1/362880) 1/362880)
(num-test (magnitude -1/500029) 1/500029)
(num-test (magnitude -10) 10)
(num-test (magnitude -10/1) 10/1)
(num-test (magnitude -10/10) 10/10)
(num-test (magnitude -10/1234) 10/1234)
(num-test (magnitude -10/1234000000) 10/1234000000)
(num-test (magnitude -10/2) 10/2)
(num-test (magnitude -10/3) 10/3)
(num-test (magnitude -10/362880) 10/362880)
(num-test (magnitude -10/500029) 10/500029)
(num-test (magnitude -1234) 1234)
(num-test (magnitude -1234.0) 1234.0)
(num-test (magnitude -1234.0+0.00000001i) 1234.0)
(num-test (magnitude -1234.0+1.0i) 1234.00040518631931)
(num-test (magnitude -1234.0+1234.0i) 1745.13953596839929)
(num-test (magnitude -1234.0+1234000000.0i) 1234000000.00061702728271)
(num-test (magnitude -1234.0+2.71828182845905i) 1234.00299394130275)
(num-test (magnitude -1234.0+3.14159265358979i) 1234.00399902285608)
(num-test (magnitude -1234.0-0.00000001i) 1234.0)
(num-test (magnitude -1234.0-1.0i) 1234.00040518631931)
(num-test (magnitude -1234.0-1234.0i) 1745.13953596839929)
(num-test (magnitude -1234.0-1234000000.0i) 1234000000.00061702728271)
(num-test (magnitude -1234.0-2.71828182845905i) 1234.00299394130275)
(num-test (magnitude -1234.0-3.14159265358979i) 1234.00399902285608)
(num-test (magnitude -1234/1) 1234/1)
(num-test (magnitude -1234/10) 1234/10)
(num-test (magnitude -1234/1234) 1234/1234)
(num-test (magnitude -1234/1234000000) 1234/1234000000)
(num-test (magnitude -1234/2) 1234/2)
(num-test (magnitude -1234/3) 1234/3)
(num-test (magnitude -1234/362880) 1234/362880)
(num-test (magnitude -1234/500029) 1234/500029)
(num-test (magnitude -1234000000) 1234000000)
(num-test (magnitude -1234000000.0) 1234000000.0)
(num-test (magnitude -1234000000.0+0.00000001i) 1234000000.0)
(num-test (magnitude -1234000000.0+1.0i) 1234000000.0)
(num-test (magnitude -1234000000.0+1234.0i) 1234000000.00061702728271)
(num-test (magnitude -1234000000.0+1234000000.0i) 1745139535.96839928627014)
(num-test (magnitude -1234000000.0+2.71828182845905i) 1234000000.0)
(num-test (magnitude -1234000000.0+3.14159265358979i) 1234000000.0)
(num-test (magnitude -1234000000.0-0.00000001i) 1234000000.0)
(num-test (magnitude -1234000000.0-1.0i) 1234000000.0)
(num-test (magnitude -1234000000.0-1234.0i) 1234000000.00061702728271)
(num-test (magnitude -1234000000.0-1234000000.0i) 1745139535.96839928627014)
(num-test (magnitude -1234000000.0-2.71828182845905i) 1.23400000000000000299394493473690280451E9)
(num-test (magnitude -1234000000.0-3.14159265358979i) 1.234000000000000003999029335935712420981E9)
(num-test (magnitude -1234000000/1) 1234000000/1)
(num-test (magnitude -1234000000/10) 1234000000/10)
(num-test (magnitude -1234000000/1234) 1234000000/1234)
(num-test (magnitude -1234000000/1234000000) 1234000000/1234000000)
(num-test (magnitude -1234000000/2) 1234000000/2)
(num-test (magnitude -1234000000/3) 1234000000/3)
(num-test (magnitude -1234000000/362880) 1234000000/362880)
(num-test (magnitude -1234000000/500029) 1234000000/500029)
(num-test (magnitude -2) 2)
(num-test (magnitude -2.0e+00+0.0e+00i) 2e0)
(num-test (magnitude -2.0e+00+1.0e+00i) 2.2360679774997896964e0)
(num-test (magnitude -2.0e+00+1.19209289550781250e-07i) 2.0000000000000035527e0)
(num-test (magnitude -2.0e+00+2.0e+00i) 2.8284271247461900976e0)
(num-test (magnitude -2.0e+00+5.0e-01i) 2.0615528128088302749e0)
(num-test (magnitude -2.0e+00+8.3886080e+06i) 8.3886080000002384186e6)
(num-test (magnitude -2.0e+00-1.0e+00i) 2.2360679774997896964e0)
(num-test (magnitude -2.0e+00-1.19209289550781250e-07i) 2.0000000000000035527e0)
(num-test (magnitude -2.0e+00-2.0e+00i) 2.8284271247461900976e0)
(num-test (magnitude -2.0e+00-5.0e-01i) 2.0615528128088302749e0)
(num-test (magnitude -2.0e+00-8.3886080e+06i) 8.3886080000002384186e6)
(num-test (magnitude -2.71828182845905) 2.71828182845905)
(num-test (magnitude -2.71828182845905+0.00000001i) 2.71828182845905)
(num-test (magnitude -2.71828182845905+1.0i) 2.89638673159001)
(num-test (magnitude -2.71828182845905+1234.0i) 1234.00299394130275)
(num-test (magnitude -2.71828182845905+1234000000.0i) 1234000000.0)
(num-test (magnitude -2.71828182845905+2.71828182845905i) 3.84423102815912)
(num-test (magnitude -2.71828182845905+3.14159265358979i) 4.15435440231331)
(num-test (magnitude -2.71828182845905+3.14159265358979i) 4.15435440231331)
(num-test (magnitude -2.71828182845905-0.00000001i) 2.71828182845905)
(num-test (magnitude -2.71828182845905-1.0i) 2.89638673159001)
(num-test (magnitude -2.71828182845905-1234.0i) 1234.00299394130275)
(num-test (magnitude -2.71828182845905-1234000000.0i) 1234000000.0)
(num-test (magnitude -2.71828182845905-2.71828182845905i) 3.84423102815912)
(num-test (magnitude -2.71828182845905-3.14159265358979i) 4.15435440231331)
(num-test (magnitude -2/1) 2/1)
(num-test (magnitude -2/10) 2/10)
(num-test (magnitude -2/1234) 2/1234)
(num-test (magnitude -2/1234000000) 2/1234000000)
(num-test (magnitude -2/2) 2/2)
(num-test (magnitude -2/3) 2/3)
(num-test (magnitude -2/362880) 2/362880)
(num-test (magnitude -2/500029) 2/500029)
(num-test (magnitude -3) 3)
(num-test (magnitude -3.14159265358979) pi)
(num-test (magnitude -3.14159265358979+0.00000001i) pi)
(num-test (magnitude -3.14159265358979+1.0i) 3.29690830947562)
(num-test (magnitude -3.14159265358979+1234.0i) 1234.00399902285608)
(num-test (magnitude -3.14159265358979+1234000000.0i) 1234000000.0)
(num-test (magnitude -3.14159265358979+2.71828182845905i) 4.15435440231331)
(num-test (magnitude -3.14159265358979+3.14159265358979i) 4.44288293815837)
(num-test (magnitude -3.14159265358979-0.00000001i) pi)
(num-test (magnitude -3.14159265358979-1.0i) 3.29690830947562)
(num-test (magnitude -3.14159265358979-1234.0i) 1234.00399902285608)
(num-test (magnitude -3.14159265358979-1234000000.0i) 1234000000.0)
(num-test (magnitude -3.14159265358979-2.71828182845905i) 4.15435440231331)
(num-test (magnitude -3.14159265358979-3.14159265358979i) 4.44288293815837)
(num-test (magnitude -3/1) 3/1)
(num-test (magnitude -3/10) 3/10)
(num-test (magnitude -3/1234) 3/1234)
(num-test (magnitude -3/1234000000) 3/1234000000)
(num-test (magnitude -3/2) 3/2)
(num-test (magnitude -3/3) 3/3)
(num-test (magnitude -3/362880) 3/362880)
(num-test (magnitude -3/500029) 3/500029)
(num-test (magnitude -362880) 362880)
(num-test (magnitude -362880/1) 362880/1)
(num-test (magnitude -362880/10) 362880/10)
(num-test (magnitude -362880/1234) 362880/1234)
(num-test (magnitude -362880/1234000000) 362880/1234000000)
(num-test (magnitude -362880/2) 362880/2)
(num-test (magnitude -362880/3) 362880/3)
(num-test (magnitude -362880/362880) 362880/362880)
(num-test (magnitude -362880/500029) 362880/500029)
(num-test (magnitude -5.0e-01+0.0e+00i) 5e-1)
(num-test (magnitude -5.0e-01+1.0e+00i) 1.1180339887498948482e0)
(num-test (magnitude -5.0e-01+1.19209289550781250e-07i) 5.0000000000001421085e-1)
(num-test (magnitude -5.0e-01+2.0e+00i) 2.0615528128088302749e0)
(num-test (magnitude -5.0e-01+5.0e-01i) 7.0710678118654752440e-1)
(num-test (magnitude -5.0e-01+8.3886080e+06i) 8.3886080000000149012e6)
(num-test (magnitude -5.0e-01-1.0e+00i) 1.1180339887498948482e0)
(num-test (magnitude -5.0e-01-1.19209289550781250e-07i) 5.0000000000001421085e-1)
(num-test (magnitude -5.0e-01-2.0e+00i) 2.0615528128088302749e0)
(num-test (magnitude -5.0e-01-5.0e-01i) 7.0710678118654752440e-1)
(num-test (magnitude -5.0e-01-8.3886080e+06i) 8.3886080000000149012e6)
(num-test (magnitude -500029) 500029)
(num-test (magnitude -500029/1) 500029/1)
(num-test (magnitude -500029/10) 500029/10)
(num-test (magnitude -500029/1234) 500029/1234)
(num-test (magnitude -500029/1234000000) 500029/1234000000)
(num-test (magnitude -500029/2) 500029/2)
(num-test (magnitude -500029/3) 500029/3)
(num-test (magnitude -500029/362880) 500029/362880)
(num-test (magnitude -500029/500029) 500029/500029)
(num-test (magnitude -8.3886080e+06+0.0e+00i) 8.388608e6)
(num-test (magnitude -8.3886080e+06+1.0e+00i) 8.3886080000000596046e6)
(num-test (magnitude -8.3886080e+06+1.19209289550781250e-07i) 8.3886080e6)
(num-test (magnitude -8.3886080e+06+2.0e+00i) 8.3886080000002384186e6)
(num-test (magnitude -8.3886080e+06+5.0e-01i) 8.3886080000000149012e6)
(num-test (magnitude -8.3886080e+06+8.3886080e+06i) 1.1863283203031444111e7)
(num-test (magnitude -8.3886080e+06-1.0e+00i) 8.3886080000000596046e6)
(num-test (magnitude -8.3886080e+06-1.19209289550781250e-07i) 8.3886080e6)
(num-test (magnitude -8.3886080e+06-2.0e+00i) 8.3886080000002384186e6)
(num-test (magnitude -8.3886080e+06-5.0e-01i) 8.3886080000000149012e6)
(num-test (magnitude -8.3886080e+06-8.3886080e+06i) 1.1863283203031444111e7)
(num-test (magnitude .1e-18-.1e-18i) 1.4142135623731e-19)
(num-test (magnitude .1e200+.1e200i) 1.4142135623731e+199)
(num-test (magnitude 0) 0)
(num-test (magnitude 0.0) 0.0)
(num-test (magnitude 0.0+0.00000001i) 0.00000001)
(num-test (magnitude 0.0+0.00000001i) 0.00000001)
(num-test (magnitude 0.0+1.0i) 1.0)
(num-test (magnitude 0.0+1234.0i) 1234.0)
(num-test (magnitude 0.0+1234000000.0i) 1234000000.0)
(num-test (magnitude 0.0+2.71828182845905i) 2.71828182845905)
(num-test (magnitude 0.0+3.14159265358979i) 3.14159265358979)
(num-test (magnitude 0.0-0.00000001i) 0.00000001)
(num-test (magnitude 0.0-1.0i) 1.0)
(num-test (magnitude 0.0-1234.0i) 1234.0)
(num-test (magnitude 0.0-1234000000.0i) 1234000000.0)
(num-test (magnitude 0.0-2.71828182845905i) 2.71828182845905)
(num-test (magnitude 0.0-3.14159265358979i) 3.14159265358979)
(num-test (magnitude 0.00000001) 0.00000001)
(num-test (magnitude 0.00000001+0.00000001i) 0.00000001414214)
(num-test (magnitude 0.00000001+1.0i) 1.0)
(num-test (magnitude 0.00000001+1234.0i) 1234.0)
(num-test (magnitude 0.00000001+1234000000.0i) 1234000000.0)
(num-test (magnitude 0.00000001+2.71828182845905i) 2.71828182845905)
(num-test (magnitude 0.00000001+3.14159265358979i) pi)
(num-test (magnitude 0.00000001-0.00000001i) 0.00000001414214)
(num-test (magnitude 0.00000001-1.0i) 1.0)
(num-test (magnitude 0.00000001-1234.0i) 1234.0)
(num-test (magnitude 0.00000001-1234000000.0i) 1234000000.0)
(num-test (magnitude 0.00000001-2.71828182845905i) 2.71828182845905)
(num-test (magnitude 0.00000001-3.14159265358979i) pi)
(num-test (magnitude 0.0e+00+0.0e+00i) 0e0)
(num-test (magnitude 0.0e+00+1.0e+00i) 1e0)
(num-test (magnitude 0.0e+00+1.19209289550781250e-07i) 1.1920928955078125e-7)
(num-test (magnitude 0.0e+00+2.0e+00i) 2e0)
(num-test (magnitude 0.0e+00+5.0e-01i) 5e-1)
(num-test (magnitude 0.0e+00+8.3886080e+06i) 8.388608e6)
(num-test (magnitude 0.0e+00-1.0e+00i) 1e0)
(num-test (magnitude 0.0e+00-1.19209289550781250e-07i) 1.1920928955078125e-7)
(num-test (magnitude 0.0e+00-2.0e+00i) 2e0)
(num-test (magnitude 0.0e+00-5.0e-01i) 5e-1)
(num-test (magnitude 0.0e+00-8.3886080e+06i) 8.388608e6)
(num-test (magnitude 0/1) 0/1)
(num-test (magnitude 0/10) 0/10)
(num-test (magnitude 0/1234) 0/1234)
(num-test (magnitude 0/1234000000) 0/1234000000)
(num-test (magnitude 0/2) 0/2)
(num-test (magnitude 0/3) 0/3)
(num-test (magnitude 0/362880) 0/362880)
(num-test (magnitude 0/500029) 0/500029)
(num-test (magnitude 1) 1)
(num-test (magnitude 1.0) 1.0)
(num-test (magnitude 1.0+0.00000001i) 1.0)
(num-test (magnitude 1.0+1.0i) 1.41421356237310)
(num-test (magnitude 1.0+1.0i) 1.41421356237310)
(num-test (magnitude 1.0+1234.0i) 1234.00040518631931)
(num-test (magnitude 1.0+1234000000.0i) 1234000000.0)
(num-test (magnitude 1.0+2.71828182845905i) 2.89638673159001)
(num-test (magnitude 1.0+3.14159265358979i) 3.29690830947562)
(num-test (magnitude 1.0-0.00000001i) 1.0)
(num-test (magnitude 1.0-1.0i) 1.41421356237310)
(num-test (magnitude 1.0-1234.0i) 1234.00040518631931)
(num-test (magnitude 1.0-1234000000.0i) 1234000000.0)
(num-test (magnitude 1.0-2.71828182845905i) 2.89638673159001)
(num-test (magnitude 1.0-3.14159265358979i) 3.29690830947562)
(num-test (magnitude 1.0e+00+0.0e+00i) 1e0)
(num-test (magnitude 1.0e+00+1.0e+00i) 1.4142135623730950488e0)
(num-test (magnitude 1.0e+00+1.19209289550781250e-07i) 1.0000000000000071054e0)
(num-test (magnitude 1.0e+00+2.0e+00i) 2.2360679774997896964e0)
(num-test (magnitude 1.0e+00+5.0e-01i) 1.1180339887498948482e0)
(num-test (magnitude 1.0e+00+8.3886080e+06i) 8.3886080000000596046e6)
(num-test (magnitude 1.0e+00-1.0e+00i) 1.4142135623730950488e0)
(num-test (magnitude 1.0e+00-1.19209289550781250e-07i) 1.0000000000000071054e0)
(num-test (magnitude 1.0e+00-2.0e+00i) 2.2360679774997896964e0)
(num-test (magnitude 1.0e+00-5.0e-01i) 1.1180339887498948482e0)
(num-test (magnitude 1.0e+00-8.3886080e+06i) 8.3886080000000596046e6)
(num-test (magnitude 1.19209289550781250e-07+0.0e+00i) 1.1920928955078125e-7)
(num-test (magnitude 1.19209289550781250e-07+1.0e+00i) 1.0000000000000071054e0)
(num-test (magnitude 1.19209289550781250e-07+1.19209289550781250e-07i) 1.6858739404357612715e-7)
(num-test (magnitude 1.19209289550781250e-07+2.0e+00i) 2.0000000000000035527e0)
(num-test (magnitude 1.19209289550781250e-07+5.0e-01i) 5.0000000000001421085e-1)
(num-test (magnitude 1.19209289550781250e-07+8.3886080e+06i) 8.3886080e6)
(num-test (magnitude 1.19209289550781250e-07-1.0e+00i) 1.0000000000000071054e0)
(num-test (magnitude 1.19209289550781250e-07-1.19209289550781250e-07i) 1.6858739404357612715e-7)
(num-test (magnitude 1.19209289550781250e-07-2.0e+00i) 2.0000000000000035527e0)
(num-test (magnitude 1.19209289550781250e-07-5.0e-01i) 5.0000000000001421085e-1)
(num-test (magnitude 1.19209289550781250e-07-8.3886080e+06i) 8.3886080e6)
(num-test (magnitude 1/1) 1/1)
(num-test (magnitude 1/10) 1/10)
(num-test (magnitude 1/1234) 1/1234)
(num-test (magnitude 1/1234000000) 1/1234000000)
(num-test (magnitude 1/2) 1/2)
(num-test (magnitude 1/3) 1/3)
(num-test (magnitude 1/362880) 1/362880)
(num-test (magnitude 1/500029) 1/500029)
(num-test (magnitude 10) 10)
(num-test (magnitude 10/1) 10/1)
(num-test (magnitude 10/10) 10/10)
(num-test (magnitude 10/1234) 10/1234)
(num-test (magnitude 10/1234000000) 10/1234000000)
(num-test (magnitude 10/2) 10/2)
(num-test (magnitude 10/3) 10/3)
(num-test (magnitude 10/362880) 10/362880)
(num-test (magnitude 10/500029) 10/500029)
(num-test (magnitude 1234) 1234)
(num-test (magnitude 1234.0) 1234.0)
(num-test (magnitude 1234.0+0.00000001i) 1234.0)
(num-test (magnitude 1234.0+1.0i) 1234.00040518631931)
(num-test (magnitude 1234.0+1234.0i) 1745.13953596839929)
(num-test (magnitude 1234.0+1234000000.0i) 1234000000.00061702728271)
(num-test (magnitude 1234.0+2.71828182845905i) 1234.00299394130275)
(num-test (magnitude 1234.0+3.14159265358979i) 1234.00399902285608)
(num-test (magnitude 1234.0-0.00000001i) 1234.0)
(num-test (magnitude 1234.0-1.0i) 1234.00040518631931)
(num-test (magnitude 1234.0-1234.0i) 1745.13953596839929)
(num-test (magnitude 1234.0-1234000000.0i) 1234000000.00061702728271)
(num-test (magnitude 1234.0-2.71828182845905i) 1234.00299394130275)
(num-test (magnitude 1234.0-3.14159265358979i) 1234.00399902285608)
(num-test (magnitude 1234/1) 1234/1)
(num-test (magnitude 1234/10) 1234/10)
(num-test (magnitude 1234/1234) 1234/1234)
(num-test (magnitude 1234/1234000000) 1234/1234000000)
(num-test (magnitude 1234/2) 1234/2)
(num-test (magnitude 1234/3) 1234/3)
(num-test (magnitude 1234/362880) 1234/362880)
(num-test (magnitude 1234/500029) 1234/500029)
(num-test (magnitude 1234000000) 1234000000)
(num-test (magnitude 1234000000.0) 1234000000.0)
(num-test (magnitude 1234000000.0+0.00000001i) 1234000000.0)
(num-test (magnitude 1234000000.0+1.0i) 1234000000.0)
(num-test (magnitude 1234000000.0+1234.0i) 1234000000.00061702728271)
(num-test (magnitude 1234000000.0+1234000000.0i) 1745139535.96839928627014)
(num-test (magnitude 1234000000.0+2.71828182845905i) 1234000000.0)
(num-test (magnitude 1234000000.0-0.00000001i) 1234000000.0)
(num-test (magnitude 1234000000.0-1.0i) 1234000000.0)
(num-test (magnitude 1234000000.0-1234.0i) 1234000000.00061702728271)
(num-test (magnitude 1234000000.0-1234000000.0i) 1745139535.96839928627014)
(num-test (magnitude 1234000000.0-2.71828182845905i) 1234000000.0)
(num-test (magnitude 1234000000.0-3.14159265358979i) 1234000000.0)
(num-test (magnitude 1234000000/1) 1234000000/1)
(num-test (magnitude 1234000000/10) 1234000000/10)
(num-test (magnitude 1234000000/1234) 1234000000/1234)
(num-test (magnitude 1234000000/1234000000) 1234000000/1234000000)
(num-test (magnitude 1234000000/2) 1234000000/2)
(num-test (magnitude 1234000000/3) 1234000000/3)
(num-test (magnitude 1234000000/362880) 1234000000/362880)
(num-test (magnitude 1234000000/500029) 1234000000/500029)
(num-test (magnitude 1e18+1e18i) 1.414213562373095048801688724209698078569E18)
(num-test (magnitude 2) 2)
(num-test (magnitude 2.0e+00+0.0e+00i) 2e0)
(num-test (magnitude 2.0e+00+1.0e+00i) 2.2360679774997896964e0)
(num-test (magnitude 2.0e+00+1.19209289550781250e-07i) 2.0000000000000035527e0)
(num-test (magnitude 2.0e+00+2.0e+00i) 2.8284271247461900976e0)
(num-test (magnitude 2.0e+00+5.0e-01i) 2.0615528128088302749e0)
(num-test (magnitude 2.0e+00+8.3886080e+06i) 8.3886080000002384186e6)
(num-test (magnitude 2.0e+00-1.0e+00i) 2.2360679774997896964e0)
(num-test (magnitude 2.0e+00-1.19209289550781250e-07i) 2.0000000000000035527e0)
(num-test (magnitude 2.0e+00-2.0e+00i) 2.8284271247461900976e0)
(num-test (magnitude 2.0e+00-5.0e-01i) 2.0615528128088302749e0)
(num-test (magnitude 2.0e+00-8.3886080e+06i) 8.3886080000002384186e6)
(num-test (magnitude 2.71828182845905) 2.71828182845905)
(num-test (magnitude 2.71828182845905+0.00000001i) 2.71828182845905)
(num-test (magnitude 2.71828182845905+1.0i) 2.89638673159001)
(num-test (magnitude 2.71828182845905+1234.0i) 1234.00299394130275)
(num-test (magnitude 2.71828182845905+1234000000.0i) 1234000000.0)
(num-test (magnitude 2.71828182845905+2.71828182845905i) 3.84423102815912)
(num-test (magnitude 2.71828182845905+3.14159265358979i) 4.15435440231331)
(num-test (magnitude 2.71828182845905+3.14159265358979i) 4.15435440231331)
(num-test (magnitude 2.71828182845905-0.00000001i) 2.71828182845905)
(num-test (magnitude 2.71828182845905-1.0i) 2.89638673159001)
(num-test (magnitude 2.71828182845905-1234.0i) 1234.00299394130275)
(num-test (magnitude 2.71828182845905-1234000000.0i) 1234000000.0)
(num-test (magnitude 2.71828182845905-2.71828182845905i) 3.84423102815912)
(num-test (magnitude 2.71828182845905-3.14159265358979i) 4.15435440231331)
(num-test (magnitude 2/1) 2/1)
(num-test (magnitude 2/10) 2/10)
(num-test (magnitude 2/1234) 2/1234)
(num-test (magnitude 2/1234000000) 2/1234000000)
(num-test (magnitude 2/2) 2/2)
(num-test (magnitude 2/3) 2/3)
(num-test (magnitude 2/362880) 2/362880)
(num-test (magnitude 2/500029) 2/500029)
(num-test (magnitude 3) 3)
(num-test (magnitude 3.14159265358979+0.00000001i) pi)
(num-test (magnitude 3.14159265358979+1.0i) 3.29690830947562)
(num-test (magnitude 3.14159265358979+1234.0i) 1234.00399902285608)
(num-test (magnitude 3.14159265358979+1234000000.0i) 1234000000.0)
(num-test (magnitude 3.14159265358979+2.71828182845905i) 4.15435440231331)
(num-test (magnitude 3.14159265358979+3.14159265358979i) 4.44288293815837)
(num-test (magnitude 3.14159265358979-0.00000001i) pi)
(num-test (magnitude 3.14159265358979-1.0i) 3.29690830947562)
(num-test (magnitude 3.14159265358979-1234.0i) 1234.00399902285608)
(num-test (magnitude 3.14159265358979-1234000000.0i) 1234000000.0)
(num-test (magnitude 3.14159265358979-2.71828182845905i) 4.15435440231331)
(num-test (magnitude 3.14159265358979-3.14159265358979i) 4.44288293815837)
(num-test (magnitude 3/1) 3/1)
(num-test (magnitude 3/10) 3/10)
(num-test (magnitude 3/1234) 3/1234)
(num-test (magnitude 3/1234000000) 3/1234000000)
(num-test (magnitude 3/2) 3/2)
(num-test (magnitude 3/3) 3/3)
(num-test (magnitude 3/362880) 3/362880)
(num-test (magnitude 3/500029) 3/500029)
(num-test (magnitude 362880) 362880)
(num-test (magnitude 362880/1) 362880/1)
(num-test (magnitude 362880/10) 362880/10)
(num-test (magnitude 362880/1234) 362880/1234)
(num-test (magnitude 362880/1234000000) 362880/1234000000)
(num-test (magnitude 362880/2) 362880/2)
(num-test (magnitude 362880/3) 362880/3)
(num-test (magnitude 362880/362880) 362880/362880)
(num-test (magnitude 362880/500029) 362880/500029)
(num-test (magnitude 5.0e-01+0.0e+00i) 5e-1)
(num-test (magnitude 5.0e-01+1.0e+00i) 1.1180339887498948482e0)
(num-test (magnitude 5.0e-01+1.19209289550781250e-07i) 5.0000000000001421085e-1)
(num-test (magnitude 5.0e-01+2.0e+00i) 2.0615528128088302749e0)
(num-test (magnitude 5.0e-01+5.0e-01i) 7.0710678118654752440e-1)
(num-test (magnitude 5.0e-01+8.3886080e+06i) 8.3886080000000149012e6)
(num-test (magnitude 5.0e-01-1.0e+00i) 1.1180339887498948482e0)
(num-test (magnitude 5.0e-01-1.19209289550781250e-07i) 5.0000000000001421085e-1)
(num-test (magnitude 5.0e-01-2.0e+00i) 2.0615528128088302749e0)
(num-test (magnitude 5.0e-01-5.0e-01i) 7.0710678118654752440e-1)
(num-test (magnitude 5.0e-01-8.3886080e+06i) 8.3886080000000149012e6)
(num-test (magnitude 500029) 500029)
(num-test (magnitude 500029/1) 500029/1)
(num-test (magnitude 500029/10) 500029/10)
(num-test (magnitude 500029/1234) 500029/1234)
(num-test (magnitude 500029/1234000000) 500029/1234000000)
(num-test (magnitude 500029/2) 500029/2)
(num-test (magnitude 500029/3) 500029/3)
(num-test (magnitude 500029/362880) 500029/362880)
(num-test (magnitude 500029/500029) 500029/500029)
(num-test (magnitude 8.3886080e+06+0.0e+00i) 8.388608e6)
(num-test (magnitude 8.3886080e+06+1.0e+00i) 8.3886080000000596046e6)
(num-test (magnitude 8.3886080e+06+1.19209289550781250e-07i) 8.3886080e6)
(num-test (magnitude 8.3886080e+06+2.0e+00i) 8.3886080000002384186e6)
(num-test (magnitude 8.3886080e+06+5.0e-01i) 8.3886080000000149012e6)
(num-test (magnitude 8.3886080e+06+8.3886080e+06i) 1.1863283203031444111e7)
(num-test (magnitude 8.3886080e+06-1.0e+00i) 8.3886080000000596046e6)
(num-test (magnitude 8.3886080e+06-1.19209289550781250e-07i) 8.3886080e6)
(num-test (magnitude 8.3886080e+06-2.0e+00i) 8.3886080000002384186e6)
(num-test (magnitude 8.3886080e+06-5.0e-01i) 8.3886080000000149012e6)
(num-test (magnitude 8.3886080e+06-8.3886080e+06i) 1.1863283203031444111e7)
(num-test (magnitude most-positive-fixnum) most-positive-fixnum)
(num-test (magnitude pi) pi)
(num-test (magnitude -2.225073858507201399999999999999999999996E-308) 2.225073858507201399999999999999999999996E-308)
(num-test (magnitude -9223372036854775808) 9223372036854775808)
(num-test (magnitude 1.110223024625156799999999999999999999997E-16) 1.110223024625156799999999999999999999997E-16)
(num-test (magnitude 9223372036854775807) 9223372036854775807)

(for-each
 (lambda (num-and-val)
   (let ((num (car num-and-val)) (val (cadr num-and-val))) (num-test-1 'magnitude num (magnitude num) val)))
 (vector (list 0 0) (list 1 1) (list 2 2) (list 3 3) (list -1 1) (list -2 2) (list -3 3) (list 9223372036854775807 9223372036854775807) 
	 (list 1/2 1/2) (list 1/3 1/3) (list -1/2 1/2) 
	 (list -1/3 1/3) (list 1/9223372036854775807 1/9223372036854775807) (list 0.0 0.0) 
	 (list 1.0 1.0) (list 2.0 2.0) (list -2.0 2.0) (list 1.000000000000000000000000000000000000002E-309 1.000000000000000000000000000000000000002E-309) 
	 (list 1e+16 1e+16) (list 0+1i 1.0) (list 0+2i 2.0) (list 0-1i 1.0) (list 1+1i 1.4142135623731) 
	 (list 1-1i 1.4142135623731) (list -1+1i 1.4142135623731) (list -1-1i 1.4142135623731) 
	 (list 0.1+0.1i 0.14142135623731) (list 1e+16+1e+16i 1.4142135623731e+16) (list 1e-16+1e-16i 1.4142135623731e-16) 
	 ))
  
(if with-bignums
    (begin
      (num-test (magnitude (make-rectangular (expt 2 63) (expt 2 63))) 1.304381782533278221234957180625250836888E19)
      (num-test (magnitude most-negative-fixnum) 9223372036854775808)
      (num-test (magnitude 1e400+1e400i) 1.414213562373095048801688724209698078569E400)
      (num-test (magnitude .1e400+.1e400i) 1.41421356237309504880168872420969807857E399)
      (num-test (magnitude .001e310+.001e310i) 1.414213562373095048801688724209698078572E307)
      (num-test (magnitude 1e-310+1e-310i) 1.414213562373095048801688724209698078569E-310)
      (num-test (magnitude 1e-400+1e-400i) 1.414213562373095048801688724209698078568E-400)
      (num-test (magnitude -1.797693134862315699999999999999999999998E308) 1.797693134862315699999999999999999999998E308)
      (num-test (magnitude 9223372036854775808.1) 9223372036854775808.1)
      (num-test (magnitude 9223372036854775808) 9223372036854775808) 
      (num-test (magnitude 9223372036854775808/3) 9223372036854775808/3) 
      (num-test (magnitude 9223372036854775808.1+1.0e19i) 1.360406526484765934746566522678055771386E19)
      (num-test (magnitude 1.0e19+9223372036854775808.1i) 1.360406526484765934746566522678055771386E19)
      (num-test (magnitude 14142135623730950488.0168872420969+14142135623730950488.0168872420969i) 1.9999999999999999999999999999999885751772054578776001965575456E19)
      ))

(test (magnitude "hi") 'error)
(test (magnitude 1.0+23.0i 1.0+23.0i) 'error)
(test (magnitude) 'error)

(for-each
 (lambda (arg)
   (test (magnitude arg) 'error))
 (list "hi" '() (integer->char 65) #f #t '(1 2) _ht_ 'a-symbol (cons 1 2) (make-vector 3) abs 
       #<eof> '(1 2 3) #\newline (lambda (a) (+ a 1)) #<unspecified> #<undefined>))