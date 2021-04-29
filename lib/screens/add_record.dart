import 'dart:io';
import 'package:flutter/material.dart';
import 'package:help_now/models/form_model.dart';
import 'package:help_now/services/form_service.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class AddRecord extends StatefulWidget {
  @override
  _AddRecordState createState() => _AddRecordState();
}

class _AddRecordState extends State<AddRecord> {

  var isCamera = false;

  DateTime _dateTime = DateTime.now();

  final formKey = GlobalKey<FormState>();

  var _formModel = FormModel();

  var _formService = FormService();

  final picker = ImagePicker();

  File _pickedImage;

  var nameController = new TextEditingController();

  var phoneController = new TextEditingController();

  var dateController = new TextEditingController();

  var _selectedProductType;

  var amountController = new TextEditingController();

  var _selectedAmountType;

  var _productTypes = [
    DropdownMenuItem(child: Text('Product',
      style: TextStyle(fontSize: 16),),
      value: 'product',
    ),
    DropdownMenuItem(child: Text('Service',
      style: TextStyle(fontSize: 16),),
      value: 'service',)
  ];

  var _amountTypes = [
    DropdownMenuItem(child: Text('Cash',
      style: TextStyle(fontSize: 16),),
      value: 'cash',),
    DropdownMenuItem(child: Text('Online',
      style: TextStyle(fontSize: 16),),
      value: 'online',),
    DropdownMenuItem(child: Text('UPI',
      style: TextStyle(fontSize: 16),),
      value: 'upi',)
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
          dateController.text = DateFormat('dd-MM-yyyy').format(_pickDate);
        });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Record'),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(5),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(22),
            child: Card(
              color: Colors.orangeAccent.withOpacity(0.9),
              elevation: 5,
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height*0.6,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width/2.5,
                                child: TextFormField(
                                  validator: (val) {
                                    if(val.length != 0){
                                      return null;
                                    } else {
                                      return 'Enter the name';
                                    }
                                  },
                                  controller: nameController,
                                  keyboardType: TextInputType.text,
                                  textCapitalization: TextCapitalization.words,
                                  decoration: InputDecoration(
                                    labelText: 'Name',
                                  ),
                                ),
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width/3,
                                child: TextFormField(
                                  validator: (val) {
                                    if(val.length != 10) {
                                      return 'Enter valid phone number';
                                    } else {
                                      return null;
                                    }
                                  },
                                  controller: phoneController,
                                  keyboardType: TextInputType.phone,
                                  decoration: InputDecoration(
                                    labelText: 'Phone',
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Spacer(),
                          Column(
                            children: [
                              CircleAvatar(
                                radius: 50,
                                backgroundColor: Colors.blueAccent,
                                backgroundImage: _pickedImage != null ?
                                FileImage(_pickedImage) : null,
                              ),
                              if(_pickedImage == null)
                                Text('No image selected', style: TextStyle(fontSize: 12),)
                            ],
                          )
                        ],
                      ),
                      SizedBox(height: 10,),
                      Container(
                        width: MediaQuery.of(context).size.width/3,
                        child: DropdownButtonFormField(
                          value: _selectedProductType,
                          items: _productTypes,
                          hint: Text('Product Type'),
                          onChanged: (value) {
                            setState(() {
                              _selectedProductType = value;
                            });
                        }
                        ),
                      ),
                      Row(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width/3,
                            child: TextFormField(
                              validator: (val) {
                                if(val.length != 0) {
                                  return null;
                                } else {
                                  return 'Enter the amount';
                                }
                              },
                              controller: amountController,
                              keyboardType: TextInputType.phone,
                              decoration: InputDecoration(
                                labelText: 'Amount',
                              ),
                            ),
                          ),
                          Spacer(),
                          Container(
                            width: MediaQuery.of(context).size.width/3,
                            child: DropdownButtonFormField(
                                value: _selectedAmountType,
                                items: _amountTypes,
                                hint: Text('Payment Type'),
                                onChanged: (value) {
                                  setState(() {
                                    _selectedAmountType = value;
                                  });
                                }
                            ),
                          ),
                        ],
                      ),
                      Row(
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
                                controller: dateController,
                                decoration: InputDecoration(
                                    labelText: 'Date',
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
                          Spacer(),
                          InkWell(
                            onTap: () {
                              _chooseUploadMode(context);
                            },
                            child: Container(
                              width: MediaQuery.of(context).size.width/3,
                              child: Column(
                                children: [
                                  Icon(Icons.file_upload),
                                  Text('Click to upload image'),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),

                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        child: Center(
                          child: ElevatedButton(
                            child: Text('Save'),
                            onPressed: () {
                              saveFunction();
                            },
                          ),
                        )
                     ),

                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _pickImage() async{
    final pickedImageFile = await picker
        .getImage(source: isCamera ? ImageSource.camera : ImageSource.gallery);
    setState(() {
      _pickedImage = File(pickedImageFile.path);
    });
  }

  saveFunction() async{
    FocusScope.of(context).unfocus();
    if(formKey.currentState.validate()) {
      _formModel.name = nameController.text;
      _formModel.phone = phoneController.text;
      _formModel.productType = _selectedProductType.toString();
      _formModel.amountType = _selectedAmountType.toString();
      _formModel.amount = amountController.text;
      _formModel.date = dateController.text;
      _formModel.imageLoc = _pickedImage.path;
      _formService.saveForm(_formModel);
      Navigator.pop(context);
    }
  }

  _chooseUploadMode(BuildContext context) {
    return showDialog(
      barrierDismissible: true,
        context: context,
        builder: (param) {
          return AlertDialog(
            content: Container(
              height: MediaQuery.of(context).size.height*0.1,
              width: MediaQuery.of(context).size.width*0.2,
              child: Column(
                children: [
                  Text('Upload from'),
                  Spacer(),
                  Row(
                    children: [
                      TextButton(onPressed: () {
                        Navigator.pop(context);
                          setState(() {
                            isCamera = true;
                            _pickImage();
                          });
                        },
                          child: Text('Camera')
                      ),
                      Spacer(),
                      TextButton(onPressed: () {
                        Navigator.pop(context);
                        setState(() {
                          isCamera = false;
                          _pickImage();
                        });
                      },
                          child: Text('Gallery')
                      ),
                    ],
                  )
                ],
              ),
            ),
          );
    });
  }
}
