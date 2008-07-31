echo user scielo On6-dfKs > seq.txt
echo ascii >> seq.txt
echo put PubMed\%1%2.xml >> seq.txt
if "@%3"=="@YES" echo cd holdings >> seq.txt
if "@%3"=="@YES" echo put PubMed\journals_%1%2.xml >> seq.txt
echo quit >> seq.txt

ftp -i -n ftp-private.ncbi.nih.gov < seq.txt