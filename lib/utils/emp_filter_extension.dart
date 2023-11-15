enum DomainFilterEnums {
  none,
  businessDevelopment,
  finance,
  iT,
  management,
  marketing,
  sales,
  uIDesigning,
}

enum GenderFilterEnums {
  none,
  agender,
  bigender,
  female,
  genderFluid,
  genderQueer,
  male,
  nonBinary,
  polyGender,
}

enum AvailabilityFilterEnums {
  none,
  available,
  unavailable,
}

extension StringToDomainFilterEnumsExt on String {
  DomainFilterEnums get getDomainFilterEnumfromString {
    switch (toUpperCase()) {
      case "BUSINESS DEVELOPMENT":
        return DomainFilterEnums.businessDevelopment;
      case "FINANCE":
        return DomainFilterEnums.finance;
      case "IT":
        return DomainFilterEnums.iT;
      case "MANAGEMENT":
        return DomainFilterEnums.management;
      case "MARKETING":
        return DomainFilterEnums.marketing;
      case "SALES":
        return DomainFilterEnums.sales;
      case "UI DESIGNING":
        return DomainFilterEnums.uIDesigning;

      default:
        return DomainFilterEnums.none;
    }
  }
}

extension StringToGenderFilterEnumExt on String {
  GenderFilterEnums get getGenderFilterEnumfromString {
    switch (toUpperCase()) {
      case "AGENDER":
        return GenderFilterEnums.agender;
      case "BIGENDER":
        return GenderFilterEnums.bigender;
      case "FEMALE":
        return GenderFilterEnums.female;
      case "GENDERFLUID":
        return GenderFilterEnums.genderFluid;
      case "GENDERQUEER":
        return GenderFilterEnums.genderQueer;
      case "MALE":
        return GenderFilterEnums.male;
      case "NON-BINARY":
        return GenderFilterEnums.nonBinary;
      case "POLYGENDER":
        return GenderFilterEnums.polyGender;

      default:
        return GenderFilterEnums.none;
    }
  }
}

extension BoolToAvailabilitEnumExt on bool {
  AvailabilityFilterEnums get getAvailbilityEnumFromBool {
    switch (this) {
      case true:
        return AvailabilityFilterEnums.available;
      case false:
        return AvailabilityFilterEnums.unavailable;
    }
  }
}
