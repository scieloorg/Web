2 0 mpl,'STATUS=',v2^*/
3 0 mpl,'TYPE=',v3/
880 0 mpl,v880/,
6 0 mpl,if v2^*='doi' and v1<>s('10.1590/',v880) and v999:'http://dx.doi.org/10.1590/' then 'CORRIGE'/ fi