#!/bin/bash
# ------------------------------------------------------------------------- #
# Efetua o descarte de temporarios em bases-work e reconstroi bases e indices
# ------------------------------------------------------------------------- #
#  Entrada: nenhuma
# Corrente: [RAIZ_SciELO]/proc
# ------------------------------------------------------------------------- #
#   DATA    Responsavel        Comentarios
# 20080515  FBCSantos/FJLopes  Edicao original

# Gera lista de titulos correntes para efetuar limpeza em tudo
# ./toolListaAcronimosTitle.sh c | sort -u > desintoxica.lst

# Gera lista soh para os processados da vez
cut -d " " -f "1" scilista.lst > desintoxica.lst


# Limpa cada item de lista
for i in `cat desintoxica.lst`
do
	./toolDesintoxicaRevistaBasesWork.sh $i
done

# Limpa area de transferencia
rm -rf ../serial/*

# Limpa area de trabalho
rm desintoxica.lst
