wf_antigen_discovery
Personalized neoantigen discovery from immunopeptidomics data



What does this workflow do?
This pipeline takes a set of non-canonical (neotranscript) DNA sequences and immunopeptidomics mass spectrometry data from a patient sample, and identifies which non-canonical peptides are actually presented on that patient's MHC molecules. In plain terms: it helps discover tumor-specific antigens that could be targeted by the immune system.

The main steps are:
    • Translation: Non-canonical transcript sequences are translated into all possible protein sequences using ORFfinder.
    • Database construction: The translated proteins are combined with a reference human proteome (UniProt) to build a custom search database.
    • Mass spec search: Patient immunopeptidomics data (HLA pulldown + mass spectrometry) is searched against the database using FragPipe/MSFragger.
    • MHC binding prediction: Identified peptides are scored for binding to the patient's specific HLA alleles using NetMHCpan.
    • Postprocessing: Results are filtered, annotated against the HLA Ligand Atlas, and summarized into a final report.

Requirements
    • Linux system (tested on Ubuntu 22.04)
    • Snakemake >= 7
    • Apptainer (Singularity) — for containerized execution
    • At least 150 GB RAM recommended
    • All tool containers are pre-built and located in containers/image/

Input files you need to provide
    • Neotranscript FASTA: DNA sequences of non-canonical transcripts, one per sample.
    • HLA alleles file: A plain text file with the patient's HLA alleles, formatted for NetMHCpan (e.g. HLA-A01:01,HLA-B07:02).
    • Immunopeptidomics data: A directory containing .raw mass spectrometry files from an HLA pulldown experiment.
    • Reference proteome: A reviewed UniProt FASTA with PE tags (path set in config).

Quick start
    1. Clone the repository and navigate to it.
    2. Copy an existing profile folder (e.g. workflow/profiles/mariia) and rename it.
    3. Edit config.yaml in your new profile to set your resource limits and file paths.
    4. Edit todo.py in your new profile to define your sample(s).
    5. Run the workflow: snakemake --profile workflow/profiles/<your_profile>

Output
All results are written to _data/antigene_search/<project_name>/. Key output files:
    • fragpipe_postprocessing/Summary.*.csv — Final table of non-canonical peptides with MHC binding predictions and HLA Ligand Atlas annotation.
    • fragpipe_postprocessing/*.NetMHCpan_out.xls — Raw NetMHCpan binding predictions.
    • fragpipe_workdir.*/*/psm.tsv — FragPipe peptide-spectrum matches.
    • final_msfragger_database.*.fasta — The custom search database used for this run.

Repository structure
wf_antigen_discovery/
├── workflow/
│   ├── Snakefile          # Main workflow
│   ├── utils.py           # Helper functions (e.g. get_size_mb)
│   ├── shell -> ../shell  # Symlink to shell scripts and tools
│   └── profiles/          # Per-user config and sample definitions
│       └── <profile>/
│           ├── config.yaml
│           └── todo.py
├── shell/                 # Python scripts, ORFfinder, FragPipe tools
├── containers/
│   ├── def/               # Apptainer definition files
│   └── image/             # Pre-built .sif container images
└── _data/                 # All outputs (created at runtime)

Contact
For questions, contact the bioinformatics team. For wetlab protocol questions (HLA pulldown, mass spec acquisition), refer to the wetlab SOP document.
