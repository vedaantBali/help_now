import 'package:help_now/models/form_model.dart';
import 'package:help_now/repositories/repository.dart';

class FormService{

  Repository _repository;

  FormService() {
    _repository = Repository();
  }

  saveForm(FormModel formModel) async{
    // print(formModel.name);
    // print(formModel.phone);
    // print(formModel.productType);
    // print(formModel.amount);
    // print(formModel.amountType);
    // print(formModel.date);
    
    return await _repository.insertData('forms', formModel.formMap());
  }

  readForms() async {
    return await _repository.readData('forms');
  }

  deleteForm(formId) async{
    return await _repository.deleteData('forms', formId);
  }

  exportCsv(fromDate, toDate) async{
    return await _repository.executeExportCsv('forms', fromDate, toDate);
  }
}