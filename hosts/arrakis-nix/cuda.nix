{
  pkgs,
  system,
  lib,
  ...
}: {
  environment.systemPackages = with pkgs;
    [
      btop-cuda # nvitop
      nvidia_oc # gwe
      nvtopPackages.nvidia
      nvidia-vaapi-driver
    ]
    ++ (with cudaPackages; [
      cudatoolkit
      cuda_cudart
      cuda_cccl
      cuda_opencl
      cuda_nvcc
      cuda_gdb

      # libnvjitlink
      # cuda_sandbox_dev
      cudnn
      cudnn-frontend

      saxpy

      cuda_sanitizer_api
      cuda_profiler_api
      # cuda_nvrtc
      # cuda_cupti
      cuda_nsight
      nsight_compute
      nsight_systems
      # cuda_nvvp
      # cuda_nvprune
      # cuda_nvprof

      libcusparse
      cusparselt
      libcublas
      libcurand
      libcusolver
      cutensor

      libcufile
      # cuda_nvdisasm
      # cuda_cuobjdump
    ]);
}
