# Installing IsaacLab

### Install IsaacSim

Create a Python Environment and use pip to install the isaacsim package.

- For Isaac Sim 5.X, the required Python version is 3.11.
- For Isaac Sim 4.X, the required Python version is 3.10.

```bash
# create a virtual environment named env_isaaclab with python3.11
uv venv --python 3.11 env_isaaclab
# activate the virtual environment
source env_isaaclab/bin/activate

# [alternative] Use conda to create environment
conda create -n env_isaaclab python=3.11
conda activate env_isaaclab
```

```bash
# install isaacsim packages
pip install "isaacsim[all,extscache]==5.1.0" --extra-index-url https://pypi.nvidia.com

# install cuda-enabled pytorch according to your system
pip install -U torch==2.7.0 torchvision==0.22.0 --index-url https://download.pytorch.org/whl/cu128
```

To verify the installation, run:

```bash
isaacsim
# note: you can pass the argument "--help" to see all arguments possible.
```



### Install Isaaclab

```bash
# Pull the source code
git clone git@github.com:isaac-sim/IsaacLab.git
cd IsaacLab
# Install dependencies
sudo apt install cmake build-essential

#install the package
./isaaclab.sh -i
```

To verify the installation, run:

```bash
conda activate env_isaaclab
cd IsaacLab
python scripts/tutorials/00_sim/create_empty.py
```



#### Trouble shooting

1. If you have `conda` environment set up, but use `uv` to set the IsaacLab environment, `isaaclab.sh` may not find the correct environment. In `isaaclab.sh`, change the following code in `extract_python_exe`:

   ```bash
   # Original: First look for conda then uv
   extract_python_exe() {
   		if ! [[ -z "${CONDA_PREFIX}" ]]; then
           # use conda python
           local python_exe=${CONDA_PREFIX}/bin/python
       elif ! [[ -z "${VIRTUAL_ENV}" ]]; then
           # use uv virtual environment python
           local python_exe=${VIRTUAL_ENV}/bin/python
       else
           # use kit python
           local python_exe=${ISAACLAB_PATH}/_isaac_sim/python.sh
       ...
   
   # For uv environments
   extract_python_exe() {
       if ! [[ -z "${VIRTUAL_ENV}" ]]; then
           # use uv virtual environment python
           local python_exe=${VIRTUAL_ENV}/bin/python
       elif ! [[ -z "${CONDA_PREFIX}" ]]; then
           # use conda python
           local python_exe=${CONDA_PREFIX}/bin/python
       else
           # use kit python
           local python_exe=${ISAACLAB_PATH}/_isaac_sim/python.sh
   		
   		...
   ```



### Install TacEx

```bash
git lfs install

git clone --recurse-submodules https://github.com/DH-Ng/TacEx
cd TacEx

conda activate env_isaaclab
./tacex.sh -i # Installing TacEx[Core]


```

To verify the installation, run:

```bash
python ./scripts/demos/tactile_sim_approaches/check_taxim_sim.py --debug_vis
python ./scripts/reinforcement_learning/skrl/train.py --task TacEx-Ball-Rolling-Tactile-RGB-v0 --num_envs 512 --enable_cameras
```

When `--debug_vis` is on, you can view the sensor output in the IsaacLab Tab: `Scene Debug Visualization > Observations > sensor_output`



If you need to install the [UIPC](https://spirimirror.github.io/libuipc-doc/) simulation, follow the instructions on the [TacEX repo](https://github.com/DH-Ng/TacEx/blob/main/docs/source/installation/Local-Installation.md)



# Installing IsaacGym and TacSL

For general installation, please just refer to [TacSL](https://github.com/isaac-sim/IsaacGymEnvs/blob/tacsl/isaacgymenvs/tacsl_sensors/install/tacsl_setup.md)

Because IsaacGym is no longer under maintenance, it only supports Python 3.8. This means that the highest Torch version is v2.4.1, which is incompatible with new GPUs, such as the RTX 5090. 

To install IsaacGym on 50s GPUs, an alternative is to build PyTorch from source. Here's a simple tutorial.

1. Get PyTorch from source

   ```bash
   git clone https://github.com/pytorch/pytorch.git
   cd pytorch
   ```

2. Checkout to the version you need 

   ```bash
   git checkout release/2.4.1
   ```

3. Change the following files

   In `cmake/Modules_CUDA_fix/upstream/FindCUDA/select_compute_arch.cmake:226-227`

   ```python
   # Change from
   else()
       message(SEND_ERROR "Unknown CUDA Architecture Name ${arch_name} in CUDA_SELECT_NVCC_ARCH_FLAGS")
     
   # To
   else()
       set(arch_bin 12.0)
       set(arch_ptx 12.0)
   ```

   In `Dockerfile:60`

   ```bash
   # Change from
   TORCH_CUDA_ARCH_LIST="3.5 5.2 6.0 6.1 7.0+PTX 8.0" TORCH_NVCC_FLAGS="-Xfatbin -compress-all" \
   # To
   TORCH_CUDA_ARCH_LIST="3.5 5.2 6.0 6.1 7.0+PTX 8.0 12.0 12.0+PTX" TORCH_NVCC_FLAGS="-Xfatbin -compress-all" \
   ```

4. Ensure the versions of your gcc and g++ are correct. `13.3` is a test to work well.

5. Run the following:

   ```bash
   python setup.py develop
   ```

   If everything works well, you will see a `dist` folder under the `pytorch` folder, with a `.whl` file in it. You can then install by running:
   ```bash
   pip install torch-2.4.1a0+gitxx-cp38-cp38-linux_xxx.whl
   ```

   Then you can successfully install the correct Torch version for IsaacGym and TacSL.

​	
