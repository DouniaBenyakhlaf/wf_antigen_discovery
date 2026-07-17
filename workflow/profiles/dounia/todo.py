import pandas as pd
import shutil
import os

# Functions
def copy_file(src, dir_path):
    if pd.isna(src):
        return
    src = str(src)
    if os.path.exists(src):
        shutil.copy(src, os.path.join(dir_path, os.path.basename(src)))
    else:
        print(f"Fichier introuvable : {src}")

# Lire la table avec les chemins vers les datas.
csv_data_info = "/mnt/beegfs/home/dbenyakh/persistent/wf_antigen_discovery/_data/immunopep_data/raw_files_cluster_241218_form_exemple.csv" # 3 groupes
immuno_data = pd.read_csv(csv_data_info, sep=",")

# colonnes HLA 
hla_cols = ["HLA_A1", "HLA_A2", "HLA_B1", "HLA_B2", "HLA_C1", "HLA_C2"]

# Dossier parent
base_dir = "/mnt/beegfs/home/dbenyakh/stagein/immunopep_data"
raw_data_dir = "/mnt/beegfs/home/dbenyakh/persistent/wf_antigen_discovery/_data/immunopep_data"

for file_name, group in immuno_data.groupby("file"):
    # Chemin du dossier : => plus tard changer le dossier parent vers le cluster curie où on stocke toutes les données
    dir_path = os.path.join(base_dir, file_name)
    # Si la pipeline a deja ete lance sur ce fichier alors ne pas relancer
    if os.path.exists(dir_path) :
        continue
    # creer le dossier 
    os.makedirs(dir_path)
    # copier les raw files du groupe (colonne Directory) dans raw_data_dir``
    raw_data = group["Directory"]
    # copier chaque Directory dans group (chaque row) dans le directory dir_path
    raw_data.apply(copy_file, args=(dir_path,))
    # creer un fichier HLA
    hla_data = group[hla_cols].drop_duplicates()
    hla_path = os.path.join(dir_path, "hlas.txt")
    hla_data.to_csv(hla_path, sep=",", index=False, header=False)
    creer un objet antigen search et l'append à SEARCHES
    SEARCHES.append(AntigeneSearch(project=file_name, 
                               input_fasta="/mnt/beegfs/home/dbenyakh/persistent/wf_antigen_discovery/example/example_MLANA.fasta", # ICI GARDER CA ?
                               hla_txt=os.path.join(dir_path,"hlas.txt"), 
                               immunopeptidomics_data=dir_path))