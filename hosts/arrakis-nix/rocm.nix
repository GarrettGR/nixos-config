{
  pkgs,
  system,
  lib,
  ...
}: {
  hardware.amdgpu = {
    overdrive.enable = true;
    opencl.enable = true;
  };

  environment.systemPackages = with pkgs;
    [
      btop-rocm
      nvtopPackages.amd
      amdgpu_top
      adaptivecppWithRocm
    ]
    ++ (with rocmPackages; [
      amdsmi
      rocminfo
      rccl
      hipcc
      # hipfort
      rocblas
      # hipblas
      hipblaslt
      migraphx

      roctracer
      rocprofiler
      rocthrust
      rocsparse
      # hipsparse

      hsakmt
      rocgdb
      hipify
      tensile
      rocwmma
      hiprand # rocrand
      rocprim
      rocmlir
    ]);
}
