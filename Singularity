# Generated by Neurodocker version 0.4.0
# Timestamp: 2020-04-15 03:21:15 UTC
# 
# Thank you for using Neurodocker. If you discover any issues
# or ways to improve this software, please submit an issue or
# pull request on our GitHub repository:
# 
#     https://github.com/kaczmarj/neurodocker

Bootstrap: docker
From: debian:stretch

%post
export ND_ENTRYPOINT="/neurodocker/startup.sh"
apt-get update -qq
apt-get install -y -q --no-install-recommends \
    apt-utils \
    bzip2 \
    ca-certificates \
    curl \
    locales \
    unzip
apt-get clean
rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen
dpkg-reconfigure --frontend=noninteractive locales
update-locale LANG="en_US.UTF-8"
chmod 777 /opt && chmod a+s /opt
mkdir -p /neurodocker
if [ ! -f "$ND_ENTRYPOINT" ]; then
  echo '#!/usr/bin/env bash' >> "$ND_ENTRYPOINT"
  echo 'set -e' >> "$ND_ENTRYPOINT"
  echo 'if [ -n "$1" ]; then "$@"; else /usr/bin/env bash; fi' >> "$ND_ENTRYPOINT";
fi
chmod -R 777 /neurodocker && chmod a+s /neurodocker

apt-get update -qq
apt-get install -y -q --no-install-recommends \
    ed \
    gsl-bin \
    libglib2.0-0 \
    libglu1-mesa-dev \
    libglw1-mesa \
    libgomp1 \
    libjpeg62 \
    libxm4 \
    netpbm \
    tcsh \
    xfonts-base \
    xvfb
apt-get clean
rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
curl -sSL --retry 5 -o /tmp/toinstall.deb http://mirrors.kernel.org/debian/pool/main/libx/libxp/libxp6_1.0.2-2_amd64.deb
dpkg -i /tmp/toinstall.deb
rm /tmp/toinstall.deb
curl -sSL --retry 5 -o /tmp/toinstall.deb http://mirrors.kernel.org/debian/pool/main/libp/libpng/libpng12-0_1.2.49-1%2Bdeb7u2_amd64.deb
dpkg -i /tmp/toinstall.deb
rm /tmp/toinstall.deb
apt-get install -f
apt-get clean
rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
gsl2_path="$(find / -name 'libgsl.so.19' || printf '')"
if [ -n "$gsl2_path" ]; then
  ln -sfv "$gsl2_path" "$(dirname $gsl2_path)/libgsl.so.0";
fi
ldconfig
echo "Downloading AFNI ..."
mkdir -p /opt/afni-latest
curl -fsSL --retry 5 https://afni.nimh.nih.gov/pub/dist/tgz/linux_openmp_64.tgz \
| tar -xz -C /opt/afni-latest --strip-components 1

apt-get update -qq
apt-get install -y -q --no-install-recommends \
    bc \
    dc \
    file \
    libfontconfig1 \
    libfreetype6 \
    libgl1-mesa-dev \
    libglu1-mesa-dev \
    libgomp1 \
    libice6 \
    libmng1 \
    libxcursor1 \
    libxft2 \
    libxinerama1 \
    libxrandr2 \
    libxrender1 \
    libxt6 \
    wget
apt-get clean
rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
echo "Downloading FSL ..."
mkdir -p /opt/fsl-5.0.10
curl -fsSL --retry 5 https://fsl.fmrib.ox.ac.uk/fsldownloads/fsl-5.0.10-centos6_64.tar.gz \
| tar -xz -C /opt/fsl-5.0.10 --strip-components 1
sed -i '$iecho Some packages in this Docker container are non-free' $ND_ENTRYPOINT
sed -i '$iecho If you are considering commercial use of this container, please consult the relevant license:' $ND_ENTRYPOINT
sed -i '$iecho https://fsl.fmrib.ox.ac.uk/fsl/fslwiki/Licence' $ND_ENTRYPOINT
sed -i '$isource $FSLDIR/etc/fslconf/fsl.sh' $ND_ENTRYPOINT
echo "Installing FSL conda environment ..."
bash /opt/fsl-5.0.10/etc/fslconf/fslpython_install.sh -f /opt/fsl-5.0.10


apt-get update -qq
apt-get install -y -q --no-install-recommends \
    bc \
    libxext6 \
    libxpm-dev \
    libxt6
apt-get clean
rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
echo "Downloading MATLAB Compiler Runtime ..."
curl -fsSL --retry 5 -o /tmp/MCRInstaller.bin https://dl.dropbox.com/s/zz6me0c3v4yq5fd/MCR_R2010a_glnxa64_installer.bin
chmod +x /tmp/MCRInstaller.bin
/tmp/MCRInstaller.bin -silent -P installLocation="/opt/matlabmcr-2010a"
rm -rf /tmp/*
echo "Downloading standalone SPM ..."
curl -fsSL --retry 5 -o /tmp/spm12.zip http://www.fil.ion.ucl.ac.uk/spm/download/restricted/utopia/previous/spm12_r7219_R2010a.zip
unzip -q /tmp/spm12.zip -d /tmp
mkdir -p /opt/spm12-r7219
mv /tmp/spm12/* /opt/spm12-r7219/
chmod -R 777 /opt/spm12-r7219
rm -rf /tmp/*
/opt/spm12-r7219/run_spm12.sh /opt/matlabmcr-2010a/v713 quit
sed -i '$iexport SPMMCRCMD=\"/opt/spm12-r7219/run_spm12.sh /opt/matlabmcr-2010a/v713 script\"' $ND_ENTRYPOINT

echo "Downloading ANTs ..."
mkdir -p /opt/ants-2.2.0
curl -fsSL --retry 5 https://dl.dropbox.com/s/2f4sui1z6lcgyek/ANTs-Linux-centos5_x86_64-v2.2.0-0740f91.tar.gz \
| tar -xz -C /opt/ants-2.2.0 --strip-components 1

export PATH="/opt/miniconda-latest/bin:$PATH"
echo "Downloading Miniconda installer ..."
conda_installer="/tmp/miniconda.sh"
curl -fsSL --retry 5 -o "$conda_installer" https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh
bash "$conda_installer" -b -p /opt/miniconda-latest
rm -f "$conda_installer"
conda update -yq -nbase conda
conda config --system --prepend channels conda-forge
conda config --system --set auto_update_conda false
conda config --system --set show_channel_urls true
sync && conda clean -tipsy && sync
conda create -y -q --name neuro
conda install -y -q --name neuro \
    python=3.6 \
    traits \
    jupyter
sync && conda clean -tipsy && sync
bash -c "source activate neuro
  pip install  --no-cache-dir \
      nipype \
      pybids \
      numpy \
      scipy \
      matplotlib \
      ipython \
      pandas \
      scikit-learn \
      joblib \
      nibabel \
      nilearn"
rm -rf ~/.cache/pip/*
sync


echo '{
\n  "pkg_manager": "apt",
\n  "instructions": [
\n    [
\n      "base",
\n      "debian:stretch"
\n    ],
\n    [
\n      "_header",
\n      {
\n        "version": "generic",
\n        "method": "custom"
\n      }
\n    ],
\n    [
\n      "afni",
\n      {
\n        "version": "latest"
\n      }
\n    ],
\n    [
\n      "fsl",
\n      {
\n        "version": "5.0.10"
\n      }
\n    ],
\n    [
\n      "spm12",
\n      {
\n        "version": "r7219"
\n      }
\n    ],
\n    [
\n      "ants",
\n      {
\n        "version": "2.2.0"
\n      }
\n    ],
\n    [
\n      "miniconda",
\n      {
\n        "create_env": "neuro",
\n        "conda_install": [
\n          "python=3.6",
\n          "traits",
\n          "jupyter"
\n        ],
\n        "pip_install": [
\n          "nipype",
\n          "pybids",
\n          "numpy",
\n          "scipy",
\n          "matplotlib",
\n          "ipython",
\n          "pandas",
\n          "scikit-learn",
\n          "joblib",
\n          "nibabel",
\n          "nilearn"
\n        ]
\n      }
\n    ]
\n  ]
\n}' > /neurodocker/neurodocker_specs.json

%environment
export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"
export ND_ENTRYPOINT="/neurodocker/startup.sh"
export PATH="/opt/miniconda-latest/bin:$PATH"
export AFNI_PLUGINPATH="/opt/afni-latest"
export FSLDIR="/opt/fsl-5.0.10"
export FORCE_SPMMCR="1"
export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:/usr/lib/x86_64-linux-gnu:/opt/matlabmcr-2010a/v713/runtime/glnxa64:/opt/matlabmcr-2010a/v713/bin/glnxa64:/opt/matlabmcr-2010a/v713/sys/os/glnxa64:/opt/matlabmcr-2010a/v713/extern/bin/glnxa64"
export MATLABCMD="/opt/matlabmcr-2010a/v713/toolbox/matlab"
export ANTSPATH="/opt/ants-2.2.0"
export CONDA_DIR="/opt/miniconda-latest"

%runscript
/neurodocker/startup.sh "$@"