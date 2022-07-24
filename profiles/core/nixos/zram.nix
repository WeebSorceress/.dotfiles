{ ... }:
{
  zramSwap = {
    enable = true;
    priority = 10;
    algorithm = "zstd";
    memoryPercent = 50;
  };
}
