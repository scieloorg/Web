2 0 mpl,if v706='h' then ,'hd=',v3/, fi,
1 0 mpl,if v706='i' then ,'is'/, fi,
2 0 if v706='p' then 'P',v3/, if ref(mfn-1,v706)<>'p' then 'A',v3/ fi fi /* para retirada dos reg p da base artigo */
2 0 if v706='p' and p(v888) then 'RP',v3/, fi /* para retirada dos reg p da base artigo */
