enum PackageSize { small, medium, large }

String getPackageSize(PackageSize packageType) {
  if (packageType == null) return "NoType";
  return packageType.toString().replaceAll("PackageType.", "");
}

String getPackTypeCapitalized(PackageSize packageType) {
  String packType = getPackageSize(packageType);
  return packType.replaceFirst(
      packType.substring(0, 1), packType.substring(0, 1).toUpperCase());
}
