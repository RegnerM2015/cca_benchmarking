#!/bin/bash

# Download scATAC-seq data from Foster et al. 2022 Cancer Cell paper
docker run regnerm/scbreast_2023:1.1.2 \
           mkdir source_data &&
           wget -P ./source_data/ https://ftp.ncbi.nlm.nih.gov/geo/samples/GSM6543nnn/GSM6543828/suppl/GSM6543828%5FHBr%5F15%5FA%2Etar%2Egz &&
           wget -P ./source_data/ https://ftp.ncbi.nlm.nih.gov/geo/samples/GSM6543nnn/GSM6543829/suppl/GSM6543829%5FHBr%5F15%5FB%2Etar%2Egz &&
           wget -P ./source_data/ https://ftp.ncbi.nlm.nih.gov/geo/samples/GSM6543nnn/GSM6543830/suppl/GSM6543830%5FHBr%5F15%5FC%2Etar%2Egz

# Download scRNA-seq data from Wu et al. 2021 Nature Genetics paper
docker run regnerm/scbreast_2023:1.1.2 \
           wget -P ./source_data/ https://ftp.ncbi.nlm.nih.gov/geo/series/GSE176nnn/GSE176078/suppl/GSE176078%5FWu%5Fetal%5F2021%5FBRCA%5FscRNASeq%2Etar%2Egz -O - | tar -xzf - -C ./source_data &&
           # Rename files to conform to Seurat's Read10x() function
           mv ./source_data/Wu_etal_2021_BRCA_scRNASeq/count_matrix_sparse.mtx ./source_data/Wu_etal_2021_BRCA_scRNASeq/matrix.mtx &&
           mv ./source_data/Wu_etal_2021_BRCA_scRNASeq/count_matrix_genes.tsv ./source_data/Wu_etal_2021_BRCA_scRNASeq/features.tsv &&
           mv ./source_data/Wu_etal_2021_BRCA_scRNASeq/count_matrix_barcodes.tsv ./source_data/Wu_etal_2021_BRCA_scRNASeq/barcodes.tsv &&
           # Gzip to conform to Seurat's Read10x() function
           gzip ./source_data/Wu_etal_2021_BRCA_scRNASeq/matrix.mtx &&
           gzip ./source_data/Wu_etal_2021_BRCA_scRNASeq/features.tsv &&
           gzip ./source_data/Wu_etal_2021_BRCA_scRNASeq/barcodes.tsv
