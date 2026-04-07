{
  imports = [
    ../../drivers
  ];
  # Enable GPU Drivers
  drivers.amdgpu.enable = false;
  drivers.nvidia.enable = false;
  drivers.intel.enable = true;
}

