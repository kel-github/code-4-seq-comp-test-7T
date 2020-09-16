# Comparing 7T fMRI Sequences when imaging the basal ganglia during a visual cueing task

***

[Kelly Garner](mailto:getkellygarner@gmail.com?subject=[GitHub]%20seq%20comp%207T)
2020
(c) CC BY-NC 4.0 https://creativecommons.org/licenses/by-nc/4.0/

Code developed to compare 7T fMRI Sequences for STRIAVISE WP1

***

## Singularity Recipe

All analyses were performed in the environment built by using the following recipe:

```
docker run --rm kaczmarj/neurodocker:0.4.0 generate singularity \
     --base debian:stretch --pkg-manager apt \
     --afni version=latest \
     --fsl version=5.0.10 \
     --spm12 version=r7219 \
     --ants version=2.2.0 \
     --miniconda create_env=neuro \
          conda_install="python=3.6 traits jupyter" \
          pip_install="nipype pybids numpy scipy matplotlib ipython pandas scikit-learn joblib nibabel nilearn" > Singularity
```

Once written, the following modifications were required:

The generated Singularity file contained references to removal of a tmp directory (a) which the remote builder may not like, or b) refer to outdated packages.
- open the 'Singularity' file in a text editor 
- to fix a)  replace all /tmp/* with nothing (or remove the line of code that it is mentioned in, in conjunction with 'rm', when it is the only directory entered into the 'rm' command)
- to fix b) search for 'http://mirrors.kernel.org/debian/pool/main/libp/libpng' and change the version number on this line to one available at the same webpage

SPM requires an extra package to work. To load this package open the Singularity recipe file in a text editor and add: [TBC]



