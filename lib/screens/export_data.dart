import 'package:flutter/material.dart';
import 'package:help_now/services/form_service.dart';
import 'package:intl/intl.dart';

class ExportData extends StatefulWidget {
  @override
  _ExportDataState createState() => _ExportDataState();
}

class _ExportDataState extends State<ExportData> {

  final scaffoldKey = GlobalKey<ScaffoldState>();

  var _formService = FormService();

  DateTime _dateTime = DateTime.now();

  final formKey = GlobalKey<FormState>();

  var _selectedExportType;

  var fromDateController = new TextEditingController();

  var toDateController = new TextEditingController();

  var exportTypeController = new TextEditingController();

  var _exportTypes = [
    DropdownMenuItem(child: Text('Excel',
    style: TextStyle(fontSize: 16),),
      value: 'excel',
    ),
    DropdownMenuItem(child: Text('CSV',
      style: TextStyle(fontSize: 16),),
      value: 'csv',
    ),
  ];

  _selectedDate(BuildContext ctx) async {
    var _pickDate = await showDatePicker(
        context: ctx,
        initialDate: _dateTime,
        firstDate: DateTime(2000),
        lastDate: DateTime.now()
    );
    if(_pickDate != null) {
      setState(() {
        _dateTime = _pickDate;
        fromDateController.text = DateFormat('dd-MM-yyyy').format(_pickDate);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text('Export'),
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(5),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(22),
              child: Card(
                color: Colors.orangeAccent.withOpacity(0.9),
                elevation: 5,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height*0.4,
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                            width: MediaQuery.of(context).size.width/2.5,
                            child: TextFormField(
                              validator: (val) {
                                if (val.length != 0) {
                                  return null;
                                } else {
                                  return 'Enter the date';
                                }
                              },
                              keyboardType: TextInputType.datetime,
                              controller: fromDateController,
                              decoration: InputDecoration(
                                  labelText: 'From Date',
                                  hintText: '${DateFormat('dd-MM-yyyy')
                                      .format(DateTime.now())}',
                                  prefixIcon: InkWell(
                                    onTap: () {
                                      _selectedDate(context);
                                    },
                                    child: Icon(Icons.calendar_today),
                                  )
                              ),
                            )
                        ),
                        Container(
                            width: MediaQuery.of(context).size.width/2.5,
                            child: TextFormField(
                              validator: (val) {
                                if (val.length != 0) {
                                  return null;
                                } else {
                                  return 'Enter the date';
                                }
                              },
                              keyboardType: TextInputType.datetime,
                              controller: fromDateController,
                              decoration: InputDecoration(
                                  labelText: 'To Date',
                                  hintText: '${DateFormat('dd-MM-yyyy')
                                      .format(DateTime.now())}',
                                  prefixIcon: InkWell(
                                    onTap: () {
                                      _selectedDate(context);
                                    },
                                    child: Icon(Icons.calendar_today),
                                  )
                              ),
                            )
                        ),
                        SizedBox(height: 10,),
                        Container(
                          width: MediaQuery.of(context).size.width/2.5,
                          child: DropdownButtonFormField(
                              validator: (val) {
                                if(val == null) {
                                  return 'Enter an export type';
                                } else {
                                  return null;
                                }
                              },
                              value: _selectedExportType,
                              items: _exportTypes,
                              hint: Text('Export as'),
                              onChanged: (value) {
                                setState(() {
                                  _selectedExportType = value;
                                });
                              }
                          ),
                        ),
                        Spacer(),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ElevatedButton(
                              onPressed: () {
                                startExport();
                              },
                              child: Text('Export')
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  startExport() async{
    FocusScope.of(context).unfocus();
    if(formKey.currentState.validate()) {
      if(_selectedExportType == 'csv') {
        await _formService
            .exportCsv(fromDateController.text,toDateController.text);
      }

      Navigator.pop(context);
    }
  }

}
