{
  imports = [
    ../../drivers
  ];
  # Enable GPU Drivers
  drivers.amdgpu.enable = true;
  drivers.nvidia.enable = false;
  drivers.intel.enable = false;
}

