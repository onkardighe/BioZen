class InsurancePolicies {
  static late List<dynamic> allCoverageList = [
    "Earthquakes",
    "Explosion",
    "Fire",
    "Lightning",
    "Any type of natural or man-made calamity",
    "Overturning of the transport vessel",
    "The collision of the vessel which damages the goods contained therein",
    "The derailment of the vessel",
    "The sinking of the vessel",
    "Risks faced while loading and unloading the goods",
    "Risks faced in packing and unpacking of goods",
    "Accidental damages",
    "Malicious damages",
    "Impact damage",
    "Theft",
  ];
}

class InsurancePolicy {
  int price;
  int coverageAmount;
  List<dynamic> coverages;

  InsurancePolicy(this.price, this.coverageAmount, this.coverages);
}
