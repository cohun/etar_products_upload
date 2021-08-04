import 'package:etar_products_upload/models/inspection_model.dart';
import 'package:etar_products_upload/src/services/database.dart';
import 'package:etar_products_upload/src/widgets/start_pdf.dart';
import 'package:flutter/material.dart';

class EventsPage extends StatefulWidget {
  final String company;
  final String productID;

  const EventsPage({Key key, this.company, this.productID}) : super(key: key);

  @override
  _EventsPageState createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> {
  final Database database = FirestoreDatabase();

  Widget _buildOpStarts(BuildContext context) {
    final _company = widget.company;
    return StreamBuilder<List<InspectionModel>>(
        stream: database.opStartStream(_company, widget.productID),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final List<InspectionModel> _opStarts = snapshot.data;
            if (_opStarts.isNotEmpty) {
              double height = _opStarts.length * 80.0;
              return buildOpStartList(
                  context: context, items: _opStarts, height: height);
            }
            return Container(
              height: 0,
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Text('Hiba történt'),
            );
          }
          return Container(
            height: 0,
          );
        });
  }

  Widget _buildInspections(BuildContext context) {
    final _company = widget.company;
    return StreamBuilder<List<InspectionModel>>(
        stream: database.inspectionsStream(_company, widget.productID),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final List<InspectionModel> _inspections = snapshot.data;
            if (_inspections.isNotEmpty) {
              double height = _inspections.length * 80.0;
              return buildInspectionList(
                  context: context, items: _inspections, height: height);
            }
            return Container(
              height: 0,
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Text('Hiba történt'),
            );
          }
          return Container(
            height: 0,
          );
        });
  }

  Widget _buildMaintenances(BuildContext context) {
    final _company = widget.company;
    return StreamBuilder<List<InspectionModel>>(
        stream: database.maintenanceStream(_company, widget.productID),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final List<InspectionModel> _maintenances = snapshot.data;
            if (_maintenances.isNotEmpty) {
              double height = _maintenances.length * 80.0;
              return buildMaintenanceList(
                  context: context, items: _maintenances, height: height);
            }
            return Container(
              height: 0,
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Text('Hiba történt'),
            );
          }
          return Container(
            height: 0,
          );
        });
  }

  Widget _buildRepairs(BuildContext context) {
    final _company = widget.company;
    return StreamBuilder<List<InspectionModel>>(
        stream: database.repairStream(_company, widget.productID),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final List<InspectionModel> _repairs = snapshot.data;
            if (_repairs.isNotEmpty) {
              double height = _repairs.length * 80.0;
              return buildRepairList(
                  context: context, items: _repairs, height: height);
            }
            return Container(
              height: 0,
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Text('Hiba történt'),
            );
          }
          return Container(
            height: 0,
          );
        });
  }

  Widget buildOpStartList(
      {BuildContext context, List<InspectionModel> items, double height}) {
    return Container(
      height: height,
      child: ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) => Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                color: Color(0xff02569b),
                border: Border.all()),
            child: InkWell(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    '${items[index].date}',
                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.assignment,
                          color: Colors.white,
                        ),
                        onPressed: null,
                      ),
                      Text('srsz: ${items[index].nr}', style: TextStyle(color: Colors.white),),
                    ],
                  )
                ],
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => StartPdf(
                    database: database,
                    company: widget.company,
                    what: items[index].type,
                    whatEnglish: 'operationStart',
                    productId: widget.productID,
                    nr: items[index].nr,
                    color: Color(0xff02569b),
                          )),
                );
              },
            ),
          ),
        ),
        primary: false,
      ),
    );
  }

  Widget buildInspectionList(
      {BuildContext context, List<InspectionModel> items, double height}) {
    return Container(
      height: height,
      child: ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) => Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                color: items[index].result == 'Megfelelt'
                    ? Colors.teal[800]
                    : items[index].result == 'Nem felelt meg'
                        ? Colors.red
                        : Colors.indigoAccent,
                border: Border.all()),
            child: InkWell(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    '${items[index].date}',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.assignment,
                          color: Colors.white,
                        ),
                        onPressed: null,
                      ),
                      Column(
                        children: [
                          Text(
                            '${items[index].type}',
                            style: TextStyle(color: Colors.white, fontSize: 9),
                          ),
                          Text(
                            'srsz: ${items[index].nr}',
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => StartPdf(
                            database: database,
                            company: widget.company,
                            what: items[index].type,
                            whatEnglish: 'inspections',
                            productId: widget.productID,
                            nr: items[index].nr,
                            color: Colors.teal[800],
                          )),
                );
              },
            ),
          ),
        ),
        primary: false,
      ),
    );
  }

  Widget buildMaintenanceList(
      {BuildContext context, List<InspectionModel> items, double height}) {
    return Container(
      height: height,
      child: ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) => Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                color: Colors.brown[800],
                border: Border.all()),
            child: InkWell(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    '${items[index].date}',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.assignment,
                          color: Colors.white,
                        ),
                        onPressed: null,
                      ),
                      Text(
                        'srsz: ${items[index].nr}',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  )
                ],
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => StartPdf(
                            database: database,
                            company: widget.company,
                            what: items[index].type,
                            whatEnglish: 'maintenances',
                            productId: widget.productID,
                            nr: items[index].nr,
                            color: Colors.brown[800],
                          )),
                );
              },
            ),
          ),
        ),
        primary: false,
      ),
    );
  }

  Widget buildRepairList(
      {BuildContext context, List<InspectionModel> items, double height}) {
    return Container(
      height: height,
      child: ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) => Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                color: Color(0xff0B0157),
                border: Border.all()),
            child: InkWell(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    '${items[index].date}',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.assignment,
                          color: Colors.white,
                        ),
                        onPressed: null,
                      ),
                      Text(
                        'srsz: ${items[index].nr}',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  )
                ],
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => StartPdf(
                            database: database,
                            company: widget.company,
                            what: items[index].type,
                            whatEnglish: 'repairs',
                            productId: widget.productID,
                            nr: items[index].nr,
                            color: Colors.grey[800],
                          )),
                );
              },
            ),
          ),
        ),
        primary: false,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[50],
      appBar: AppBar(
        title: Text('Események'),
        elevation: 2.0,
        backgroundColor: Colors.teal[800],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/startup.png',
                        height: 60,
                      ),
                      SizedBox(
                        width: 100,
                      ),
                      Text(
                        'Üzembehelyezés',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
              _buildOpStarts(context),
              //*************************************************************
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/inspection.jpg',
                        height: 60,
                      ),
                      SizedBox(
                        width: 100,
                      ),
                      Text(
                        'Vizsgálatok',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
              _buildInspections(context),
              //***************************************************************
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/maintenance.jpg',
                        height: 60,
                      ),
                      SizedBox(
                        width: 100,
                      ),
                      Text(
                        'Karbantartások',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
              _buildMaintenances(context),
              //***************************************************************
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/service.jpg',
                        height: 60,
                      ),
                      SizedBox(
                        width: 100,
                      ),
                      Text(
                        'Javítások',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
              _buildRepairs(context),
            ],
          ),
        ),
      ),
    );
  }
}
