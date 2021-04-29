import 'dart:io';
import 'package:flutter/material.dart';
import 'package:help_now/helpers/drawer_navigation.dart';
import 'package:help_now/models/form_model.dart';
import 'package:help_now/screens/add_record.dart';
import 'package:help_now/screens/export_data.dart';
import 'package:help_now/services/form_service.dart';
import 'package:unicorndial/unicorndial.dart';
import 'package:permission_handler/permission_handler.dart';


class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  List<FormModel> _formList = <FormModel>[];

  var _formService = FormService();

  var _permissionStatus;

  void initState() {
    super.initState();
    getAllForms();

        () async {
      _permissionStatus = await Permission.storage.status;

      if (_permissionStatus != PermissionStatus.granted) {
        PermissionStatus permissionStatus= await Permission.storage.request();
        setState(() {
          _permissionStatus = permissionStatus;
        });
      }
    } ();

  }

  getAllForms() async {
    _formList = <FormModel>[];
    var forms = await _formService.readForms();

    forms.forEach((form) {
      setState(() {
        var modelForm = FormModel();
        modelForm.name = form['name'];
        modelForm.phone = form['phone'];
        modelForm.productType = form['productType'];
        modelForm.amount = form['amount'];
        modelForm.amountType = form['amountType'];
        modelForm.date = form['date'];
        modelForm.imageLoc = form['imageLoc'];
        _formList.add(modelForm);
      });
    });
  }

  @override
  Widget build(BuildContext context) {

    final floatingButtons = <UnicornButton>[];
    floatingButtons.add(UnicornButton(
        labelShadowColor: Colors.orangeAccent,
        hasLabel: true,
        labelText: 'Add',
      currentButton: FloatingActionButton(
        heroTag: 'add',
        mini: true,
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddRecord()));
        },
      ),
      )
    );
    floatingButtons.add(UnicornButton(
      labelShadowColor: Colors.orangeAccent,
      hasLabel: true,
      labelText: 'Export',
      currentButton: FloatingActionButton(
        heroTag: 'export',
        mini: true,
        child: Icon(Icons.share),
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ExportData())
          );
        },
      ),
    )
    );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('HelpNow'),
        actions: [
          Container(
            padding: const EdgeInsets.all(12),
            child: InkWell(
              child: Icon(Icons.refresh_outlined, size: 32,),
              onTap: () {
                setState(() {
                  getAllForms();
                });
              },),
          )
        ],
      ),
      drawer: DrawerNavigation(),
      floatingActionButton: UnicornDialer(
        parentButtonBackground: Colors.orange,
        orientation: UnicornOrientation.VERTICAL,
        parentButton: Icon(Icons.expand_less_outlined),
        childButtons: floatingButtons,
      ),
      body: _formList.length == 0 ?
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(
                  child: Image.asset(
                      'assets/empty_page.png',
                      height: MediaQuery.of(context).size.height*0.2,
                      width: MediaQuery.of(context).size.width*0.6,
                  ),
                ),
                Center(
                  child: Text('There\'s nothing here!',
                    style: TextStyle(fontSize: 20),),
                ),
              ],
            )

          : ListView.builder(
        padding: EdgeInsets.all(8),
        itemBuilder: (context, index) {
          return Card(
            elevation: 5,
            child: ListTile(
              leading:  Image.file(File(_formList[index].imageLoc),
              ),
              onLongPress: () {
                _deleteFormDialog(context, _formList[index].phone);
              },
              title: Text('${_formList[index].name} - ${_formList[index].phone}'),
              subtitle: Text(_formList[index].date),
              trailing: Text(
                '₹ ${_formList[index].amount}',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold
                ),
              ),
            )
          );
        },
        itemCount: _formList.length,
      )
    );
  }

  _deleteFormDialog(BuildContext context, formId) {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (param) {
          return AlertDialog(
            content: Container(
                height: MediaQuery.of(context).size.height*0.1,
                width: MediaQuery.of(context).size.width*0.2,
                child: Column(
                  children: [
                    Text('Delete this record?'),
                    Spacer(),
                    Row(
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text('Cancel'),
                        ),
                        Spacer(),
                        TextButton(
                          onPressed: () async{
                            var result = await _formService.deleteForm(formId);
                            Navigator.pop(context);
                            getAllForms();
                            print(result);
                          },
                          child: Text('Delete', style: TextStyle(color: Colors.red),),
                        )
                      ],
                    )
                  ],
                ),
              )
          );
        }
    );
  }
}
