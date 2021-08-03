class APIPath {
  static String operationStart(String company, String nr) =>
      'companies/$company/operationStart/$nr';
  static String operationStarts(String company) => '/companies/$company/operationStart';
  static String inspection(String company, String nr) =>
      'companies/$company/inspections/$nr';
  static String inspections(String company) => '/companies/$company/inspections';
  static String maintenance(String company, String nr) =>
      'companies/$company/maintenances/$nr';
  static String maintenances(String company) => '/companies/$company/maintenances';
  static String repair(String company, String nr) =>
      'companies/$company/repairs/$nr';
  static String repairs(String company) => '/companies/$company/repairs';
  static String parts(String company, String nr, int id) =>
      'companies/$company/repairs/$nr/parts/$id';
  static String partsList(String company, String nr) =>
      'companies/$company/repairs/$nr/parts';
}