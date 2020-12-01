import 'package:etar_products_upload/models/product_model.dart';
import 'package:etar_products_upload/src/widgets/empty_content.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ListPage extends StatefulWidget {
  final company;

  const ListPage({Key key, this.company}) : super(key: key);

  @override
  _ListPageState createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  int selectedSort = 2;
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
          prods = products;
          if (products.isNotEmpty) {
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
                });
                onSortColumn(columnIndex, ascending);
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
                });
                onSortColumn(columnIndex, ascending);
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
                  ;
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
                  ;
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
          ],
          rows: prods
              .map(
                (product) => DataRow(
                  cells: [
                    DataCell(
                      Text(product.productGroup),
                    ),
                    DataCell(
                      Text(product.type),
                      onTap: () {
                        // write your code..
                      },
                    ),
                    DataCell(
                      Text(product.length),
                    ),
                    DataCell(
                      Text(product.description),
                    ),
                    DataCell(
                      Text(product.capacity),
                    ),
                    DataCell(
                      Text(product.identifier),
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
