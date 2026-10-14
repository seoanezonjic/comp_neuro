#! /usr/bin/env bash

source ~soft_bio_267/initializes/init_python
mkdir temp

##awk -F '\t' '{if($4 >= 0.5) print "c:" $1 "\t" "g:" $2 "\t" 1}' data/Busquedas_gene_dgidb/compounds.tsv | tail -n +2 > temp/dis_comp_gene.net
awk -F '\t' '{print "c:" $1 "\t" "g:" $2 "\t" $4}' data/Busquedas_gene_dgidb/compounds.tsv | tail -n +2 > temp/dis_comp_gene.net
awk -F "\t" '{print "c:" toupper($1) "\td:" $2 "\t1"}' data/compounds_dgidb_diseases_corrected.txt | tail -n +2 | grep -v 'SIN REGISTROS' >> temp/dis_comp_gene.net
tail -n +2 data/Compounds_dgidb_chemical_source.txt | grep -v 'Sin registros' | awk -F "\t" '{print $2 "\tc:" toupper($1)}' > temp/comp_orig
##cut -f 1,3 data/tablas_concatenadas.txt | grep -v '-' | cut -d ' ' -f 1 | awk '{print $2 "\tc:" toupper($1)}' > temp/comp_orig

#python -m venv myenv --system-site-packages
#source myenv/bin/activate
#pip install -e ~/dev_py/py_report_html
#pip install -e ~/dev_py/NetAnalyzer

LAYERS='gene,g:;comp,c:;dis,d:'
netanalyzer -i temp/dis_comp_gene.net -l $LAYERS -G temp/comp_orig -g temp/dis_comp_gene --graph_options 'method=pyvis,shape=layer,size=10,fontsize=25px,height=2000px,width=2000px' --filter_connected_components 2 -m counts -u "gene,dis;comp" -a temp/gene_dis.net
netanalyzer -i temp/dis_comp_gene.net -l $LAYERS --filter_connected_components 2 -A get_degree
mv node_attributes.txt temp/degree_dis_comp_gene.txt
grep 'g:' temp/gene_dis.net | grep 'd:' > temp/gene_dis_no_auto.net
LAYERS='gene,g:;dis,d:'
netanalyzer -i temp/gene_dis_no_auto.net -l $LAYERS -g temp/gene_dis_no_auto --graph_options 'method=pyvis,group=layer,solver=forceAtlas2Based,fontsize=30px,height=2000px,width=2000px'
netanalyzer -i temp/gene_dis_no_auto.net -l $LAYERS -A get_degree
mv node_attributes.txt temp/degree_gene_dis.txt
sed 's/g://g' temp/gene_dis_no_auto.net | sed 's/d://g' | aggregate_column_data -i - -x 2 -a 1 > temp/disease_gene.txt
exit
source ~soft_bio_267/initializes/init_degenes_hunter
mkdir -p temp/functional
clusters_to_enrichment.R -i temp/disease_gene.txt -w 5 -t 2 -k "SYMBOL" -P 0.01 -o temp/functional -c
