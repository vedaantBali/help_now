class FormModel {
  String name;
  String phone;
  String productType;
  String amount;
  String amountType;
  String date;
  String imageLoc;

  formMap() {
    var mapping = Map<String, dynamic>();
    mapping['phone'] = phone;
    mapping['name'] = name;
    mapping['productType'] = productType;
    mapping['amount'] = amount;
    mapping['amountType'] = amountType;
    mapping['date'] = date;
    mapping['imageLoc'] = imageLoc;

    return mapping;
  }
}