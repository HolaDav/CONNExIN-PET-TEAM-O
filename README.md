# CONNExIN-PET-TEAM-O - Amyloid PET Dementia Analysis Pipeline
Repository for CONNExIN PET TEAM 2025 (O)

## Project Overview
This repository contains a reproducible pipeline for analyzing amyloid PET data in dementia research. The pipeline processes Pittsburgh Compound B (PiB) PET imaging data alongside T1w structural MRI to quantify amyloid deposition across different stages of Alzheimer's disease.

### Research Question: Do amyloid levels differ in participants at different stages of Alzheimer's disease?

## Pipeline Overview
Raw DICOM → BIDS Conversion → Quality Control → Preprocessing → Statistical Analysis

## Scripts
### 1. 01_data_structure.sh
- Purpose: Converts DICOM data to BIDS format and creates required metadata
- Dependencies: dcm2niix, web-based BIDS validator
- Input: DICOM files organized by subject/session
- Output: BIDS-compliant dataset structure

### 2. 02_mriqc.sh
- Purpose: Performs automated quality control on T1w structural images
- Dependencies: MRIQC v24.0.2+, FSL
- Input: BIDS-formatted T1w images
- Output: Quality metrics (SNR, CNR, FBER, CJV, EFC) and HTML reports

### 3. 03_preprocessing.sh
- Purpose: Preprocesses PET data including coregistration to structural MRI
- Dependencies: FSL v6.0.7+, FreeSurfer v7.4.1+
- Input: BIDS-formatted PET and T1w images
- Output: Coregistered PET data in T1w space

### 4. 04_analysis.sh
- Purpose: Quantifies amyloid burden (SUVR) and performs statistical analysis
- Dependencies: FSL, Python 3.8+ with pandas, scipy, statsmodels
- Input: Preprocessed PET data, group assignments
- Output: SUVR values, ANOVA results, group comparisons

## Quick Start
### Prerequisites

bash
#Load required modules (Neurodesk environment)
module load mriqc/24.0.2
module load fsl/6.0.7
module load freesurfer

### Setup

bash
#Clone repository
git clone https://github.com/your-username/amyloid-pet-pipeline.git
cd amyloid-pet-pipeline

#Make scripts executable
chmod +x *.sh

# Set up subject list (edit as needed)
echo "AD02" > sub_list
echo "AD33" >> sub_list  
echo "AD34" >> sub_list


### Run Full Pipeline

bash
# Execute in sequence
./01_data_structure.sh
./02_mriqc.sh
./03_preprocessing.sh
./04_analysis.sh
File Structure
text
amyloid-pet-pipeline/
├── 01_data_structure.sh          # BIDS conversion script
├── 02_mriqc.sh                   # Quality control script  
├── 03_preprocessing.sh           # PET preprocessing script
├── 04_analysis.sh                # Statistical analysis script
├── sub_list                      # Subject identifiers
└── README.md                     # This file

dataset/                          # Created by pipeline
├── sub-AD02/
│   ├── anat/sub-AD02_T1w.nii.gz
│   └── pet/sub-AD02_pet.nii.gz
├── derivatives/
│   ├── mriqc/                   # QC results
│   ├── preprocessed/            # Processed data
│   └── analysis/                # Analysis outputs
└── dataset_description.json     # BIDS metadata
Configuration
Subject List Format
Edit sub_list to include your subject identifiers:

text
AD02
AD33
AD34
Path Configuration
Update these variables in each script if needed:

bash
BASE_DIR="/home/jovyan/Desktop/dataset"  #Main data directory
SUBJECTS_DIR="/home/jovyan/freesurfer-subjects-dir"  #FreeSurfer output


## Expected Outputs
### Quality Control Metrics
- Individual subject JSON files with SNR, CNR, FBER, CJV, EFC
- Group-level HTML reports
- Visual quality assessment images

## Preprocessed Data
- Coregistered PET images in T1w space
Transformation matrices for spatial normalization
Quality-checked data ready for analysis

## Analysis Results
- SUVR values for each subject and ROI
- ANOVA results comparing groups (Control vs MCI vs AD)
- Post-hoc test results for significant findings

## Troubleshooting
### Common Issues
- MRIQC module not found: module avail mriqc to see available versions
- FreeSurfer license: Ensure valid license file is available
- Memory errors: Reduce --mem_gb parameter in MRIQC script
- BIDS validation: Use web validator at bids-standard.github.io/bids-validator

### Log Files
- Check these directories for detailed logs:
- dataset/derivatives/mriqc/logs/ - MRIQC processing logs
- freesurfer-subjects-dir/sub-*/scripts/ - FreeSurfer processing logs

### CRediT Statement
- Authors: David Oladeji
- Contributions: Protocol design, implementation, validation, documentation, analysis
- Supervision: Udunna Anazodo, Kesavi Kanagasabai, Abdalla Mohamed, Ethan Draper

### License
- This project is licensed under the MIT License - see the LICENSE file for details.

### References
- Esteban et al. (2017). MRIQC: Advancing the automatic prediction of image quality in MRI from unseen sites. PLOS ONE
- Nørgaard et al. (2019). PET PVC methodologies: The impact of preprocessing steps. EJNMMI Physics
- BIDS Specification v1.8.0

Support
For questions or issues, please open an issue on GitHub or contact the development team.
