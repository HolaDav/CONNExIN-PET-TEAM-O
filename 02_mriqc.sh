#!/bin/bash
# MRIQC Script: Automated quality control for T1w images
# Dependencies: MRIQC module, FSL

# Set paths
BASE_DIR="/home/jovyan/Desktop/dataset"
SUBJECTS=("AD02" "AD33" "AD34")
OUTPUT_DIR="$BASE_DIR/derivatives/mriqc"

echo "=== Starting MRIQC Pipeline ==="

# Load MRIQC module
module load mriqc/24.0.2

# Create output directory
mkdir -p "$OUTPUT_DIR"

# Process each subject
for sub in "${SUBJECTS[@]}"; do
    echo "Processing sub-$sub with MRIQC..."
    
    mriqc "$BASE_DIR" "$OUTPUT_DIR" participant \
          --participant_label "$sub" \
          --no-sub \
          -m T1w \
          --n_proc 2 \
          --mem_gb 8
    
    if [ $? -eq 0 ]; then
        echo "✓ sub-$sub MRIQC completed successfully"
    else
        echo "✗ sub-$sub MRIQC failed"
    fi
done

# Run group-level analysis
echo "Running group-level MRIQC..."
mriqc "$BASE_DIR" "$OUTPUT_DIR" group --no-sub -m T1w

echo "=== MRIQC Pipeline Complete ==="
echo "Results available in: $OUTPUT_DIR"
