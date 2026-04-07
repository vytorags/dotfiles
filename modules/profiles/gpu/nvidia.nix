{
  imports = [
    ../../drivers
  ];
  # Enable GPU Drivers
  drivers.amdgpu.enable = false;
  drivers.nvidia.enable = true;
  drivers.intel.enable = false;
}

