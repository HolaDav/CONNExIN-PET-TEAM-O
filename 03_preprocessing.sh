#!/bin/bash
# Pre-Processing Script: PET data preprocessing pipeline
# Dependencies: FSL, FreeSurfer

# Set paths
BASE_DIR="/home/jovyan/Desktop/dataset"
SUBJECTS=("AD02" "AD33" "AD34")
PREPROC_DIR="$BASE_DIR/derivatives/preprocessed"
SUBJECTS_DIR="/home/jovyan/freesurfer-subjects-dir"

echo "=== Starting Pre-Processing Pipeline ==="

# Load modules
module load fsl
module load freesurfer
export SUBJECTS_DIR="$SUBJECTS_DIR"
mkdir -p "$SUBJECTS_DIR"

# Create output directories
for sub in "${SUBJECTS[@]}"; do
    mkdir -p "$PREPROC_DIR/sub-$sub/pet"
done

# Step 1: Copy PET data to preprocessed directory
for sub in "${SUBJECTS[@]}"; do
    echo "Preprocessing sub-$sub..."
    
    INPUT_PET="$BASE_DIR/sub-$sub/pet/sub-${sub}_trc-PiB5070min_rec_start_pet.nii.gz"
    OUTPUT_STATIC="$PREPROC_DIR/sub-$sub/pet/sub-${sub}_pet_static.nii.gz"
    
    # Copy PET data
    cp "$INPUT_PET" "$OUTPUT_STATIC"
    echo "✓ Copied PET data for sub-$sub"
done

# Step 2: Coregistration using FSL (faster alternative)
for sub in "${SUBJECTS[@]}"; do
    INPUT_PET="$PREPROC_DIR/sub-$sub/pet/sub-${sub}_pet_static.nii.gz"
    T1W_REF="$BASE_DIR/sub-$sub/anat/sub-${sub}_T1w.nii.gz"
    OUTPUT_COREG="$PREPROC_DIR/sub-$sub/pet/sub-${sub}_pet_coregistered.nii.gz"
    MAT_FILE="$PREPROC_DIR/sub-$sub/pet/sub-${sub}_pet2t1.mat"
    
    echo "Coregistering PET to T1w for sub-$sub..."
    
    flirt -in "$INPUT_PET" \
          -ref "$T1W_REF" \
          -out "$OUTPUT_COREG" \
          -omat "$MAT_FILE" \
          -dof 6 \
          -cost mutualinfo
    
    if [ -f "$OUTPUT_COREG" ]; then
        echo "✓ Coregistration completed for sub-$sub"
    else
        echo "✗ Coregistration failed for sub-$sub"
    fi
done

echo "=== Pre-Processing Pipeline Complete ==="
