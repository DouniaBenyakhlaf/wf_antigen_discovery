#!/usr/bin/env python3

import math
import os
import shutil
import subprocess
import yaml
import pandas as pd

# =====================================================================
# CONFIG
# =====================================================================

csv_in = (
    "/mnt/beegfs/home/dbenyakh/persistent/"
    "wf_antigen_discovery/_data/immunopep_data/"
    "raw_files_cluster_241218_form.csv"
)

n_chunks = 10

chunk_dir = (
    "/mnt/beegfs/home/dbenyakh/persistent/"
    "wf_antigen_discovery/csv_chunks"
)

local_output = (
    "/mnt/beegfs/home/dbenyakh/persistent/"
    "wf_antigen_discovery/_data/antigene_search"
)

archive_dir = (
    "/data/users/dbenyakh/NeoAg/immunopep/orfs_herv-h"
)

PROFILE_CONFIG = (
    "/mnt/beegfs/home/dbenyakh/persistent/"
    "wf_antigen_discovery/workflow/profiles/dounia/config.yaml"
)

# =====================================================================
# FUNCTIONS
# =====================================================================

def update_csv_data_info(csv_path):
    with open(PROFILE_CONFIG, "r") as f:
        cfg = yaml.safe_load(f)

    cfg["config"]["csv_data_info"] = csv_path

    with open(PROFILE_CONFIG, "w") as f:
        yaml.safe_dump(
            cfg,
            f,
            sort_keys=False,
            default_flow_style=False
        )

# =====================================================================
# PREPARE CHUNKS
# =====================================================================

os.makedirs(chunk_dir, exist_ok=True)

df = pd.read_csv(csv_in)

files = sorted(df["file"].unique())

chunk_size = math.ceil(len(files) / n_chunks)

chunks = []

print(f"{len(files)} groups detected")
print(f"{n_chunks} chunks")
print(f"~{chunk_size} groups per chunk")

for i in range(n_chunks):

    start = i * chunk_size
    end = min((i + 1) * chunk_size, len(files))

    chunk_files = files[start:end]

    chunk_df = df[df["file"].isin(chunk_files)]

    outfile = os.path.join(
        chunk_dir,
        f"chunk_{i+1:02d}.csv"
    )

    chunk_df.to_csv(outfile, index=False)

    chunks.append(
    {
        "csv": outfile,
        "projects": chunk_files
    }
)

    print(
        f"Chunk {i+1:02d}: "
        f"{len(chunk_files)} groups "
        f"({len(chunk_df)} rows)"
    )

# =====================================================================
# RUN CHUNKS
# =====================================================================

for i, chunk in enumerate(chunks[1:], start=2):
    csv = chunk["csv"]
    projects = chunk["projects"]
    print("\n" + "=" * 80)
    print(f"START CHUNK {i}/{len(chunks)}")
    print(csv)
    print("=" * 80)

    update_csv_data_info(csv)

    # try:
    #     subprocess.run(
    #         [
    #             "snakemake",
    #             "--snakefile",
    #             "workflow/Snakefile",
    #             "--profile",
    #             "workflow/profiles/dounia",
    #         ],
    #         check=True,
    #     )
    # except subprocess.CalledProcessError as e:
    #     print(
    #         f"\nWARNING: Snakemake finished with errors "
    #         f"(return code {e.returncode}). "
    #         f"Continuing archive step.\n"
    #     )

    # subprocess.run(
    #         [
    #             "snakemake",
    #             "--snakefile",
    #             "workflow/Snakefile",
    #             "--profile",
    #             "workflow/profiles/dounia",
    #         ],
    #         check=True,
    #     )

    # command to keep
    # subprocess.run(
    #     [
    #         "snakemake",
    #         "--snakefile",
    #         "workflow/Snakefile",
    #         "--profile",
    #         "workflow/profiles/dounia",
    #         "--rerun-triggers",
    #         "mtime",
    #     ],
    #     check=True,
    # )

    print("\nSync results...\n")

    chunk_archive_dir = os.path.join(
        archive_dir,
        f"chunk_{i:02d}"
    )

    os.makedirs(chunk_archive_dir, exist_ok=True)

    print(
        f"\nArchiving chunk {i}/{len(chunks)} "
        f"to {chunk_archive_dir}\n"
    
    )

    print(f"\nSync results to {chunk_archive_dir}\n")

    for project in projects:

        project_dir = os.path.join(
            local_output,
            project
        )

        if os.path.exists(project_dir):

            print(
                f"Archiving {project_dir} "
                f"to {chunk_archive_dir}"
            )

            subprocess.run(
                [
                    "rsync",
                    "-avP",
                    project_dir,
                    chunk_archive_dir,
                ],
                check=True,
            )

    with open(
        os.path.join(
            chunk_archive_dir,
            "TRANSFER_COMPLETE"
        ),
        "w"
    ):
        pass

    print("\nRemoving local outputs from current chunk...\n")

    for project in projects:

        project_dir = os.path.join(
            local_output,
            project
        )

        if os.path.exists(project_dir):
            print(f"Removing {project_dir}")
            shutil.rmtree(project_dir)
    
    print("\nChunk finished.\n")
    break

print("\nALL CHUNKS FINISHED\n")