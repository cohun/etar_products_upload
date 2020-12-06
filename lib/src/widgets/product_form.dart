import 'package:etar_products_upload/models/product_model.dart';
import 'package:flutter/material.dart';
import 'package:dropdown_formfield/dropdown_formfield.dart';
import 'package:etar_products_upload/src/widgets/data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';

class ProductForm extends StatefulWidget {
  const ProductForm({Key key, this.company}) : super(key: key);
  final company;

  @override
  _ProductFormState createState() => _ProductFormState();
}

class _ProductFormState extends State<ProductForm> {
  String _productGroup;
  String _description;
  String _type;
  String _length;
  String _identifier;
  String _capacity;
  String _manufacturer;
  String _extraNr;
  String _productionDate;
  final formKey = new GlobalKey<FormState>();
  final nameHolder = TextEditingController();

  @override
  void initState() {
    super.initState();
    _productGroup = '';
    _description = '';
    _type = '';
    _length = '';
    _identifier = '';
    _capacity = '';
    _manufacturer = "";
    _extraNr = '';
    _productionDate = '';
  }

  Stream<List<T>> collectionStream<T>({
    @required String path,
    @required T builder(Map<String, dynamic> data),
  }) {
    final reference = FirebaseFirestore.instance.collection(path);
    final snapshots = reference.snapshots();
    return snapshots.map((snapshot) => snapshot.docs
        .map(
          (snapshot) => builder(snapshot.data()),
        )
        .toList());
  }

  Stream<List<ProductModel>> productsStream(String company) => collectionStream(
        path: '/companies/$company/products',
        builder: (data) => ProductModel.fromMap(data),
      );

  //*************************************************************–
  bool _validateAndSaveForm() {
    final form = formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  Future<void> _saveForm() async {
    if (_validateAndSaveForm()) {
      try {
        final products = await productsStream(widget.company).first;
        final allIdentifier = products.map((e) => e.identifier).toList();
        if (allIdentifier.contains(_identifier)) {
          _showMyDialog(
            title: 'Dupla bevitel',
            content: 'Ez a gyáriszám már létezik',
            defaultActionText: 'OK',
          );
        } else {
          final product = ProductModel(
            productGroup: _productGroup,
            type: _type,
            length: _length,
            description: _description,
            identifier: nameHolder.text,
            company: widget.company,
            manufacturer: _manufacturer,
            extraNr: _extraNr,
            productionDate: _productionDate,
            capacity: _capacity,
            site: "Nincs kiadva helyszínre",
            person: "Nincs kiadva felhasználónak",
            nfc: 'üres',
          );
          await setProduct(widget.company, product);
          nameHolder.clear();
        }
      } on PlatformException catch (e) {
        _showMyDialog(
          title: 'Művelet sikertelen',
          content: e.toString(),
          defaultActionText: 'Kilép',
        );
      }
    }
  }

  Future<void> setProduct(company, ProductModel productModel) async => setData(
        path: 'companies/$company/products/$_identifier',
        data: productModel.toMap(),
      );

  Future<void> setData({String path, Map<String, dynamic> data}) async {
    final reference = FirebaseFirestore.instance.doc(path);
    print('$path: $data');
    await reference.set(data);
  }

  Future<void> _showMyDialog(
      {String title, String content, String defaultActionText}) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(content),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(defaultActionText),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  //**************************************************************

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Form(
        key: formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: 20,
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    child: DropDownFormField(
                      titleText: 'Termékkör',
                      hintText: 'Válassz egyet',
                      value: _productGroup,
                      onSaved: (value) {
                        setState(() {
                          _productGroup = value;
                          _description = Description.description[value];
                        });
                      },
                      onChanged: (value) {
                        setState(() {
                          _productGroup = value;
                          _description = Description.description[value];
                          print(_description);
                        });
                      },
                      dataSource: Data.productGroup,
                      textField: 'value',
                      valueField: 'value',
                    ),
                    width: 150,
                  ),
                  SizedBox(width: 20),
                  ConstrainedBox(
                    constraints: BoxConstraints.tight(const Size(150, 68)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Típus',
                          style: TextStyle(fontSize: 12),
                        ),
                        TextFormField(
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter some text';
                            }
                            return null;
                          },
                          onSaved: (value) => _type = value,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 20),
                  ConstrainedBox(
                    constraints: BoxConstraints.tight(const Size(150, 68)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Hossz',
                          style: TextStyle(fontSize: 12),
                        ),
                        TextFormField(
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter some text';
                            }
                            return null;
                          },
                          onSaved: (value) => _length = value,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 20),
                  ConstrainedBox(
                    constraints: BoxConstraints.tight(const Size(150, 68)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Megnevezés',
                          style: TextStyle(fontSize: 12),
                        ),
                        SizedBox(
                          height: 18,
                        ),
                        Text(
                          _description,
                          style: TextStyle(fontSize: 16),
                        ),
                        Text('____________________')
                      ],
                    ),
                  ),
                  SizedBox(width: 20),
                  ConstrainedBox(
                    constraints: BoxConstraints.tight(const Size(150, 68)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Teherbírás',
                          style: TextStyle(fontSize: 12),
                        ),
                        TextFormField(
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter some text';
                            }
                            return null;
                          },
                          onSaved: (value) => _capacity = value,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 20),
                  ConstrainedBox(
                    constraints: BoxConstraints.tight(const Size(150, 68)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Gyáriszám',
                          style: TextStyle(fontSize: 12),
                        ),
                        TextFormField(
                          controller: nameHolder,
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter some text';
                            }
                            return null;
                          },
                          onSaved: (value) => _identifier = value,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 20),
                  ConstrainedBox(
                    constraints: BoxConstraints.tight(const Size(150, 68)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Gyártó',
                          style: TextStyle(fontSize: 12),
                        ),
                        TextFormField(
                          onSaved: (value) => _manufacturer = value,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 20),
                  ConstrainedBox(
                    constraints: BoxConstraints.tight(const Size(150, 68)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Gyártási év',
                          style: TextStyle(fontSize: 12),
                        ),
                        TextFormField(
                          onSaved: (value) => _productionDate = value,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 20),
                  ConstrainedBox(
                    constraints: BoxConstraints.tight(const Size(150, 68)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Extra jelölés',
                          style: TextStyle(fontSize: 12),
                        ),
                        TextFormField(
                          onSaved: (value) {
                            return _extraNr = value;
                          },
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              padding: EdgeInsets.all(8),
              child: RaisedButton(
                child: Text('Mentés'),
                onPressed: _saveForm,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
