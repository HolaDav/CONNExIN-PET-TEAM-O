#!/bin/bash
# Data Structure Script: DICOM to BIDS conversion and validation
# Dependencies: dcm2niix, BIDS validator (web/docker)

# Set paths
BASE_DIR="/home/jovyan/Desktop/dataset"
SUBJECTS=("AD02" "AD33" "AD34")

echo "=== Starting Data Structure Pipeline ==="

# Create BIDS directory structure
for sub in "${SUBJECTS[@]}"; do
    echo "Creating structure for sub-$sub"
    mkdir -p "$BASE_DIR/sub-$sub/anat"
    mkdir -p "$BASE_DIR/sub-$sub/pet"
done

# Create BIDS metadata files
echo "Creating BIDS metadata files..."

# dataset_description.json
cat > "$BASE_DIR/dataset_description.json" << EOF
{
    "Name": "Amyloid PET Dementia Study",
    "BIDSVersion": "1.8.0",
    "License": "CC0",
    "Authors": ["David Oladeji"],
    "Acknowledgements": "CONNExIN Bootcamp"
}
EOF

# participants.tsv
cat > "$BASE_DIR/participants.tsv" << EOF
participant_id	age	sex	group
sub-AD02		
sub-AD33		
sub-AD34		
EOF

echo "BIDS structure created. Please validate at: https://bids-standard.github.io/bids-validator/"
echo "=== Data Structure Pipeline Complete ==="
