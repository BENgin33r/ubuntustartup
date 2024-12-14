#sn23 setup
# Update and upgrade the system
sudo apt update && sudo apt upgrade -y
sudo apt install -y git python3 python3-pip python-is-python3 git-lfs

# Clone the NicheImage repository
git clone https://github.com/NicheTensor/NicheImage
cd NicheImage

# Create and activate a new virtual environment
python -m venv main_env
source main_env/bin/activate

# Install the package in editable mode
pip install -e .

# Uninstall uvloop
pip uninstall uvloop -y

# Update submodules
git submodule update --init --recursive

# Run the download script
. generation_models/custom_pipelines/scripts/download_antelopev2.sh

python -m venv vllm
source vllm/bin/activate
pip install vllm==0.6.4
