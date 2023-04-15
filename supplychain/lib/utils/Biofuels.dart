class Biofuels {
  static late List<Biofuel> biofuelsList = [
    Biofuel('Biogas', -50, 50),
    Biofuel('BioDiesel', 0, 16),
    Biofuel('BioEthanol', 10, 25),
    Biofuel('BioHydrogen', -20, 50),
    Biofuel('BioButanol', 10, 25),
  ];
}

class Biofuel {
  String name;
  double minTemp;
  double maxTemp;
  Biofuel(this.name, this.minTemp, this.maxTemp);
}
