import 'package:etar_products_upload/constants.dart';
import 'package:etar_products_upload/models/product_model.dart';
import 'package:etar_products_upload/src/widgets/empty_content.dart';
import 'package:etar_products_upload/src/widgets/events_page.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ListPage extends StatefulWidget {
  final company;

  const ListPage({Key key, this.company}) : super(key: key);

  @override
  _ListPageState createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  int selectedSort = 0;
  bool sort = true;
  List<ProductModel> prods = [];

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

  Widget _buildContents(BuildContext context) {
    return StreamBuilder<List<ProductModel>>(
      stream: productsStream(widget.company),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<ProductModel> products = snapshot.data;
          if (products.isNotEmpty) {
            if (prods.length != products.length) {
              prods = products;
            }
            return _buildTable(context);
          }
          return EmptyContent();
        }
        if (snapshot.hasError) {
          return Center(
            child: Text('Hiba történt'),
          );
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  Widget _buildTable(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          sortAscending: sort,
          sortColumnIndex: selectedSort,
          columns: [
            DataColumn(
              label: Text(
                "Termékkör",
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                  color: Colors.deepOrange,
                ),
              ),
              numeric: false,
              onSort: (columnIndex, ascending) {
                setState(() {
                  sort = !sort;
                  selectedSort = columnIndex;
                  onSortColumn(columnIndex, ascending);
                });
              },
            ),
            DataColumn(
              label: Text(
                "Tipus",
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                  color: Colors.deepOrange,
                ),
              ),
              numeric: false,
              onSort: (columnIndex, ascending) {
                setState(() {
                  sort = !sort;
                  selectedSort = columnIndex;
                  onSortColumn(columnIndex, ascending);
                });
              },
            ),
            DataColumn(
              label: Text(
                "Méret",
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                  color: Colors.deepOrange,
                ),
              ),
              numeric: false,
              onSort: (columnIndex, ascending) {
                setState(() {
                  sort = !sort;
                  selectedSort = columnIndex;
                });
                onSortColumn(columnIndex, ascending);
              },
            ),
            DataColumn(
              label: Text(
                "Megnevezés",
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                  color: Colors.deepOrange,
                ),
              ),
              numeric: false,
              onSort: (columnIndex, ascending) {
                setState(() {
                  sort = !sort;
                  selectedSort = columnIndex;
                });
                onSortColumn(columnIndex, ascending);
              },
            ),
            DataColumn(
              label: Text(
                "Teherbírás",
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                  color: Colors.deepOrange,
                ),
              ),
              numeric: false,
              onSort: (columnIndex, ascending) {
                setState(() {
                  sort = !sort;
                  selectedSort = columnIndex;
                });
                onSortColumn(columnIndex, ascending);
              },
            ),
            DataColumn(
              label: Text(
                "Gyáriszám",
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                  color: Colors.deepOrange,
                ),
              ),
              numeric: false,
              onSort: (columnIndex, ascending) {
                setState(() {
                  sort = !sort;
                  selectedSort = columnIndex;
                });
                onSortColumn(columnIndex, ascending);
              },
            ),
            DataColumn(
              label: Text(
                "Gyártó",
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                  color: lightBlue,
                ),
              ),
              numeric: false,
              onSort: (columnIndex, ascending) {
                setState(() {
                  sort = !sort;
                  selectedSort = columnIndex;
                });
                onSortColumn(columnIndex, ascending);
              },
            ),
            DataColumn(
              label: Text(
                "Gyártási év",
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                  color: lightBlue,
                ),
              ),
              numeric: false,
              onSort: (columnIndex, ascending) {
                setState(() {
                  sort = !sort;
                  selectedSort = columnIndex;
                });
                onSortColumn(columnIndex, ascending);
              },
            ),
            DataColumn(
              label: Text(
                "Extra jelölés",
                style: TextStyle(fontStyle: FontStyle.italic, color: lightBlue),
              ),
              numeric: false,
              onSort: (columnIndex, ascending) {
                setState(() {
                  sort = !sort;
                  selectedSort = columnIndex;
                });
                onSortColumn(columnIndex, ascending);
              },
            ),
          ],
          rows: prods
              .map(
                (product) =>
                DataRow(
                  cells: [
                    DataCell(
                      Text(
                          product.productGroup != null
                              ? product.productGroup
                              : ''),
                    ),
                    DataCell(
                      Text(product.type != null ? product.type : ''),
                      onTap: () {
                        print(product.type);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => EventsPage(
                                company: widget.company,
                                productID: product.identifier,
                              )),
                        );
                        // write your code..
                      },
                    ),
                    DataCell(
                      Text(product.length != null ? product.length : ''),
                    ),
                    DataCell(
                      Text(product.description != null
                          ? product.description
                          : ''),
                    ),
                    DataCell(
                      Text(product.capacity != null ? product.capacity : ''),
                    ),
                    DataCell(
                      Text(
                          product.identifier != null ? product.identifier : ''),
                    ),
                    DataCell(
                      Text(product.manufacturer != null ?
                      product.manufacturer : ''),
                    ),
                    DataCell(
                      Text(product.productionDate != null ?
                      product.productionDate : ''),
                    ),
                    DataCell(
                      Text(product.extraNr != null ?
                      product.extraNr : ''),
                    ),
                  ],
                ),
          )
              .toList(),
        ),
      ),
    );
  }

  onSortColumn(int columnIndex, bool ascending) {
    switch (columnIndex) {
      case 0:
        if (ascending) {
          prods.sort((a, b) => a.productGroup.compareTo(b.productGroup));
        } else {
          prods.sort((a, b) => b.productGroup.compareTo(a.productGroup));
        }
        break;
      case 1:
        if (ascending) {
          prods.sort((a, b) => a.type.compareTo(b.type));
        } else {
          prods.sort((a, b) => b.type.compareTo(a.type));
        }
        break;
      case 2:
        if (ascending) {
          prods.sort((a, b) => a.length.compareTo(b.length));
        } else {
          prods.sort((a, b) => b.length.compareTo(a.length));
        }
        break;
      case 3:
        if (ascending) {
          prods.sort((a, b) => a.description.compareTo(b.description));
        } else {
          prods.sort((a, b) => b.description.compareTo(a.description));
        }
        break;
      case 4:
        if (ascending) {
          prods.sort((a, b) => a.capacity.compareTo(b.capacity));
        } else {
          prods.sort((a, b) => b.capacity.compareTo(a.capacity));
        }
        break;
      case 5:
        if (ascending) {
          prods.sort((a, b) => a.identifier.compareTo(b.identifier));
        } else {
          prods.sort((a, b) => b.identifier.compareTo(a.identifier));
        }
        break;
      case 6:
        if (ascending) {
          prods.sort((a, b) => a.manufacturer.compareTo(b.manufacturer));
        } else {
          prods.sort((a, b) => b.manufacturer.compareTo(a.manufacturer));
        }
        break;
      case 7:
        if (ascending) {
          prods.sort((a, b) => a.productionDate.compareTo(b.productionDate));
        } else {
          prods.sort((a, b) => b.productionDate.compareTo(a.productionDate));
        }
        break;
      case 8:
        if (ascending) {
          prods.sort((a, b) => a.extraNr.compareTo(b.extraNr));
        } else {
          prods.sort((a, b) => b.extraNr.compareTo(a.extraNr));
        }
        break;
      default:
        if (ascending) {
          prods.sort((a, b) => a.description.compareTo(b.description));
        } else {
          prods.sort((a, b) => b.description.compareTo(a.description));
        }
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return _buildContents(context);
  }
}
