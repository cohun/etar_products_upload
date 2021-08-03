import 'package:etar_products_upload/models/counter_model.dart';
import 'package:etar_products_upload/models/inspection_model.dart';
import 'package:etar_products_upload/models/parts_model.dart';
import 'package:etar_products_upload/models/product_model.dart';
import 'package:flutter/foundation.dart';

import 'api_path.dart';
import 'firestore_service.dart';


abstract class Database {

  Stream<List<InspectionModel>> opStartStream(String company, String productId);
  Stream<List<InspectionModel>> inspectionsStream(String company, String productId);
  Stream<List<InspectionModel>> maintenanceStream(String company, String productId);
  Stream<List<InspectionModel>> repairStream(String company, String productId);
  Stream<List<CounterModel>> companyIdStream(company);
  Future<InspectionModel> getEvent(company, nr, event);
  Future<ProductModel> getProduct(company, productId);
  Stream<List<PartModel>> oneDateRepairPartsStream(String company, String nr);
}

class FirestoreDatabase implements Database {
  FirestoreDatabase();


  final _service = FirestoreService.instance;


  Stream<List<InspectionModel>> opStartStream(String company, String productId)
  => _service.orderedOpStreamStream(
    path: APIPath.operationStarts(company),
    builder: (data) => InspectionModel.fromMap(data),
    productId: productId,
  );
  Stream<List<InspectionModel>> inspectionsStream(String company, String productId)
  => _service.orderedOpStreamStream(
    path: APIPath.inspections(company),
    builder: (data) => InspectionModel.fromMap(data),
    productId: productId,
  );
  Stream<List<InspectionModel>> maintenanceStream(String company, String productId)
  => _service.orderedOpStreamStream(
    path: APIPath.maintenances(company),
    builder: (data) => InspectionModel.fromMap(data),
    productId: productId,
  );
  Stream<List<InspectionModel>> repairStream(String company, String productId)
  => _service.orderedOpStreamStream(
    path: APIPath.repairs(company),
    builder: (data) => InspectionModel.fromMap(data),
    productId: productId,
  );

  Stream<List<CounterModel>> companyIdStream(company) => _service.companyIdCounterStream(
    company: company,
    builder: (data) => CounterModel.fromMap(data),
  );
  Future<InspectionModel> getEvent(company, nr, event) =>
      _service.retrieveEventFromNr(company, nr, event);

  Future<ProductModel> getProduct(company, productId)
  => _service.retrieveProductFromId(company, productId);

  Stream<List<PartModel>> oneDateRepairPartsStream(String company, String nr)
  => _service.collectionStream(
    path: APIPath.partsList(company, nr.substring(0,6)),
    builder: (data) => PartModel.fromMap(data),
  );

}
