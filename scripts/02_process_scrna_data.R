################################################################################
# Matt Regner and Aatish Thennavan
################################################################################
library(Seurat)
library(tidyverse)
set.seed(1)

# Read in scRNA data
brca.ref <- Read10X(data.dir = "./source_data/Wu_etal_2021_BRCA_scRNASeq",gene.column=1)
meta <- read.csv("./source_data/Wu_etal_2021_BRCA_scRNASeq/metadata.csv")
rownames(meta) <- meta$X
length(which(rownames(meta)==colnames(brca.ref)))
brca.ref <- CreateSeuratObject(brca.ref,meta.data = meta)

# Process data
# Normalizing the data
brca.ref <- NormalizeData(object = brca.ref, normalization.method = "LogNormalize", scale.factor = 10000, verbose=FALSE)

# Find variable features
brca.ref <- FindVariableFeatures(object = brca.ref, selection.method = "vst", nfeatures = 2000,
                                 loess.span = 0.3, clip.max = "auto",
                                 num.bin = 20, binning.method = "equal_width", verbose = FALSE)

# Scaling data
brca.ref <- ScaleData(object = brca.ref, verbose=FALSE)

# Run PCA to reduce dimensions
brca.ref <- RunPCA(object = brca.ref, features = VariableFeatures(object = brca.ref), npcs = 50, verbose=FALSE)

# Run UMAP
brca.ref <- RunUMAP(brca.ref,reduction = "pca", dims = 1:30,seed.use = 1,umap.method = "uwot",
                    n.neighbors = 30L,
                    metric = "cosine",
                    learning.rate = 1,
                    min.dist = 0.3)

# Save scRNA data into derived data
if(dir.exists("derived_data")==TRUE){
  print("Directory derived_data already exists!")
}else{
  dir.create("derived_data")
}
saveRDS(brca.ref,"./derived_data/Processed_Seurat_Object_Wuetal2021.rds")
