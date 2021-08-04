import 'package:etar_products_upload/models/inspection_model.dart';
import 'package:etar_products_upload/models/parts_model.dart';
import 'package:etar_products_upload/models/product_model.dart';
import 'package:etar_products_upload/src/services/database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:universal_html/html.dart' as html;
import 'package:sn_progress_dialog/sn_progress_dialog.dart';

class StartPdf extends StatefulWidget {
  final String company;
  final Database database;
  final String productId;
  final String what;
  final String whatEnglish;
  final String nr;
  final Color color;

  const StartPdf({Key key,
    this.company,
    this.database,
    this.productId,
    this.what,
    this.nr,
    this.whatEnglish,
    this.color})
      : super(key: key);

  @override
  _StartPdfState createState() => _StartPdfState();
}

class _StartPdfState extends State<StartPdf> {
  String _address;
  List<PartModel> partsList = [];
  List<List<String>> partTable = [];

  ProductModel _product;
  String type;
  String length;
  String description;
  String site;
  String person;
  String capacity;
  String manufacturer;

  InspectionModel _event;
  String nr;
  String doer;
  String comment;
  String result;
  String date;
  String nextDate;
  String eventType;

  final pdf = pw.Document();

  Future<pw.PageTheme> _myPageTheme() async {
    return pw.PageTheme(
      pageFormat: PdfPageFormat.a4,
      margin: pw.EdgeInsets.all(32),
      theme: pw.ThemeData.withFont(
        base: pw.Font.ttf(
            await rootBundle.load('assets/fonts/OpenSans-Regular.ttf')),
        bold: pw.Font.ttf(
            await rootBundle.load('assets/fonts/OpenSans-Bold.ttf')),
      ),
    );
  }

  String fullPath = '';

  writeOnPdf() async {
    final pw.PageTheme pageTheme = await _myPageTheme();

    final _logo = pw.MemoryImage(
      (await rootBundle.load('assets/Logo.png')).buffer.asUint8List(),
    );
    final _etar = pw.MemoryImage(
      (await rootBundle.load('assets/ETAR1@2x.png')).buffer.asUint8List(),
    );

    pdf.addPage(
      pw.Page(
        pageTheme: pageTheme,
        build: (pw.Context context) =>
            pw.Row(
              children: <pw.Widget>[
                pw.Expanded(
                  child: pw.Container(
                    padding: const pw.EdgeInsets.only(left: 30, bottom: 20),
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: <pw.Widget>[
                        //******FIRST ROW************************************
                        pw.Row(
                          crossAxisAlignment: pw.CrossAxisAlignment.center,
                          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                          children: [
                            //****************LOGO***************************
                            pw.Column(
                              crossAxisAlignment: pw.CrossAxisAlignment.start,
                              children: [
                                pw.Container(
                                  height: 32,
                                  child: _logo != null
                                      ? pw.Image(_logo)
                                      : pw.PdfLogo(),
                                ),
                                pw.Text('Emelőgép Szakszolgálat'),
                                pw.Text('1119 Budapest'),
                                pw.Text('Kelenvölgyi htsr. 5'),
                              ],
                            ),
                            //*********************************************
                            pw.Column(
                              children: [
                                pw.Container(
                                  height: 32,
                                  child: _etar != null
                                      ? pw.Image(_etar)
                                      : pw.PdfLogo(),
                                ),
                                widget.whatEnglish == 'operationEnd' ?
                                pw.Text('${widget.what}',
                                  textScaleFactor: 1.3,
                                  style: pw.Theme
                                      .of(context)
                                      .defaultTextStyle
                                      .copyWith(
                                      fontWeight: pw.FontWeight.bold),)
                                    : pw.Text(
                                  '${eventType}i',
                                  textScaleFactor: 1.5,
                                  style: pw.Theme
                                      .of(context)
                                      .defaultTextStyle
                                      .copyWith(fontWeight: pw.FontWeight.bold),
                                ),
                                pw.Text(
                                  'Jegyzőkönyv',
                                  textScaleFactor: 1.5,
                                  style: pw.Theme
                                      .of(context)
                                      .defaultTextStyle
                                      .copyWith(fontWeight: pw.FontWeight.bold),
                                ),
                              ],
                            ),
                            pw.Column(
                              children: [
                                pw.Text('Sorszám:',
                                    textScaleFactor: 1.2,
                                    style: pw.Theme
                                        .of(context)
                                        .defaultTextStyle
                                        .copyWith(
                                        fontWeight: pw.FontWeight.bold,
                                        color: PdfColor(.4, .3, .2))),
                                pw.Text('$nr',
                                    textScaleFactor: 1.2,
                                    style: pw.Theme
                                        .of(context)
                                        .defaultTextStyle
                                        .copyWith(
                                        fontWeight: pw.FontWeight.bold,
                                        color: PdfColor(.4, .3, .2))),
                              ],
                            ),
                          ],
                        ),
                        //****************************************************
                        pw.Container(
                          alignment: pw.Alignment.centerRight,
                          margin: const pw.EdgeInsets.only(
                              bottom: 3.0 * PdfPageFormat.mm),
                          padding: const pw.EdgeInsets.only(
                              bottom: 3.0 * PdfPageFormat.mm),


                          decoration: const pw.BoxDecoration(
                              border: pw.Border(
                                  bottom: pw.BorderSide(
                                      width: 0.5,
                                      color: PdfColors.grey))),
                          child: pw.Container(
                            height: 0,
                          ),
                        ),
                        //****************************************************
                        widget.whatEnglish == 'inspections'
                            ? pw.Text(
                          'Igazolás emelőgépek időszakos vizsgálatának elvégzéséről'
                              ' EBSZ 7.2.1 pontja szerinti. '
                              'Vizsgálatok az MSZ 9721-1 szabványsorozatban megadottak szerint történtek.',
                          textScaleFactor: 0.8,
                        )
                            : widget.whatEnglish == 'operationStart'
                            ? pw.Text(
                          'Első üzembehelyezést megelőző üzemszerű alkalmasság- és '
                              'működőképesség ellenőrzésének dokumentálása MSZ 6726-1:2011 szerint.',
                          textScaleFactor: 0.8,
                        )
                            : widget.whatEnglish == 'repairs'
                            ? pw.Text(
                          'Nyilatkozat az emelőgép biztonságos, üzemkész állapotának helyreállításáról',
                          textScaleFactor: 0.8,
                        )
                            : widget.whatEnglish == 'maintenances'
                            ? pw.Text(
                          'Igazolás az emelőgép használati utasítása előírásai szerinti ellenőrzések, '
                              'beállítások, kenések elvégzéséről',
                          textScaleFactor: 0.8,
                        )
                            : widget.whatEnglish == 'operationEnd'
                            ? pw.Text(
                          'Nevezett emelőgép használatból történő kivonása megtörtént, az itt megadott '
                              'időpont után használata tilos',
                          textScaleFactor: 0.8,
                        )
                            : pw.Container(height: 0),
                        _buildUserTable(context),
                        _buildProductTable(context),
                        _buildEventTable(context),
                        _buildDoerTable(context),
                        widget.whatEnglish == 'repairs'
                            ? _buildParts(context)
                            : pw.Container(height: 0),
                      ],
                    ),
                  ),
                ),
              ]
              ,
            )
        ,
      )
      ,
    );

  }

  //***************************************************************************
  pw.Widget _buildUserTable(pw.Context context) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Padding(padding: const pw.EdgeInsets.only(top: 10)),
        pw.Text('Üzemeltető:',
            textScaleFactor: 1.2,
            style: pw.Theme
                .of(context)
                .defaultTextStyle
                .copyWith(
                fontWeight: pw.FontWeight.bold, color: PdfColor(.4, .3, .2))),
        pw.Padding(padding: const pw.EdgeInsets.only(top: 10)),
        pw.Table.fromTextArray(
          context: context,
          data: <List<String>>[
            <String>['Cégnév:', 'Cím:'],
            <String>['${widget.company}', '$_address'],
          ],
        ),
        pw.Table.fromTextArray(
          context: context,
          data: <List<String>>[
            <String>['Üzemeltetés helyszíne:', 'Felhasználó neve:'],
            <String>['$site', '$person'],
          ],
        ),
      ],
    );
  }

  pw.Widget _buildProductTable(pw.Context context) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Padding(padding: const pw.EdgeInsets.only(top: 10)),
        pw.Text('Termék:',
            textScaleFactor: 1.2,
            style: pw.Theme
                .of(context)
                .defaultTextStyle
                .copyWith(
                fontWeight: pw.FontWeight.bold, color: PdfColor(.4, .3, .2))),
        pw.Padding(padding: const pw.EdgeInsets.only(top: 10)),
        pw.Table.fromTextArray(
          context: context,
          data: <List<String>>[
            <String>['Típus:', 'Hossz:', 'Megnevezés:'],
            <String>['$type', '$length', '$description'],
          ],
        ),
        pw.Table.fromTextArray(
          context: context,
          data: <List<String>>[
            <String>['Gyáriszám:', 'Teherbírás:', 'Gyártó:'],
            <String>['${widget.productId}', '$capacity', '$manufacturer'],
          ],
        ),
      ],
    );
  }

  pw.Widget _buildEventTable(pw.Context context) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Padding(padding: const pw.EdgeInsets.only(top: 10)),
        pw.Text('$eventType eredménye:',
            textScaleFactor: 1.2,
            style: pw.Theme
                .of(context)
                .defaultTextStyle
                .copyWith(
                fontWeight: pw.FontWeight.bold, color: PdfColor(.4, .3, .2))),
        pw.Padding(padding: const pw.EdgeInsets.only(top: 10)),
        pw.Table.fromTextArray(
          context: context,
          data: <List<String>>[
            <String>['$result'],
          ],
        ),
        pw.Padding(padding: const pw.EdgeInsets.only(top: 30)),
        pw.Table.fromTextArray(
          context: context,
          data: <List<String>>[
            <String>['${widget.what} időpontja:', 'Következő időpont:'],
            <String>['$date', '$nextDate'],
          ],
        ),
        pw.Table.fromTextArray(
          context: context,
          data: <List<String>>[
            <String>['Megjegyzés:'],
            <String>['$comment'],
          ],
        ),
      ],
    );
  }

  pw.Widget _buildDoerTable(pw.Context context) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Padding(padding: const pw.EdgeInsets.only(top: 10)),
        pw.Text('Az elvégzett munka szakszerűségét igazolja:',
            textScaleFactor: 1.2,
            style: pw.Theme
                .of(context)
                .defaultTextStyle
                .copyWith(
                fontWeight: pw.FontWeight.bold, color: PdfColor(.4, .3, .2))),
        pw.Padding(padding: const pw.EdgeInsets.only(top: 10)),
        pw.Table.fromTextArray(
          context: context,
          data: <List<String>>[
            <String>['$doer'],
          ],
        ),
        pw.Text('Időpecsét: ${DateTime.now()}'),
        pw.Padding(padding: const pw.EdgeInsets.only(top: 10)),
        pw.Text(
          'ETAR® adatkezelési rendszer, az egyedi sorszám kiosztással biztosítja a jegyzőkönyv hitelességét,'
              ' aláírás nélkül.',
          style: pw.TextStyle(),
        ),
      ],
    );
  }

  pw.Widget _buildParts(pw.Context context) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Padding(padding: const pw.EdgeInsets.only(top: 10)),
        pw.Text('Felhasznált anyagok:',
            textScaleFactor: 1.2,
            style: pw.Theme
                .of(context)
                .defaultTextStyle
                .copyWith(
                fontWeight: pw.FontWeight.bold, color: PdfColor(.4, .3, .2))),
        pw.Padding(padding: const pw.EdgeInsets.only(top: 10)),
        pw.Container(
          width: 580,
          child: pw.Text('$partTable'),
        ),
      ],
    );
  }

  //***************************************************************************

  Future savePdf() async {

    final bytes = await pdf.save();
    final blob = html.Blob([bytes], 'application/pdf');
    final url = html.Url.createObjectUrlFromBlob(blob);
    final anchor = html.AnchorElement()
      ..href = url
      ..style.display = 'none'
      ..download = 'cert.pdf';
    html.document.body?.children.add(anchor);
    anchor.click();
    html.document.body?.children.remove(anchor);
    html.Url.revokeObjectUrl(url);
  }

  @override
  void initState() {
    super.initState();
    getData();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text('PDF'),
        backgroundColor: widget.color,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    title: Center(child: Text('Üzemeltető')),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Cégnév: '),
                            Text(
                              '${widget.company}',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Cím: '),
                            Text(
                              '$_address',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Hely: '),
                            Text(
                              '$site',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Személy: '),
                            Text(
                              '$person',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
            child: Card(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    title: Center(child: Text('Termék')),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Megnevezés: '),
                            Text(
                              '$description',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Típus: '),
                            Text(
                              '$type',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Hossz: '),
                            Text(
                              '$length',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Teherbírás: '),
                            Text(
                              '$capacity',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Gyártó: '),
                            Text(
                              '$manufacturer',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Gyáriszám: '),
                            Text(
                              '${widget.productId}',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
            child: Card(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    title: Center(child: Text('${widget.what}')),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Sorszám: '),
                            Text(
                              '${widget.nr}',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Elvégzés időpontja: '),
                            Text(
                              '$date',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Következő időpont: '),
                            Text(
                              '$nextDate',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Munkát végezte: '),
                            Text(
                              '$doer',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Eredmény: '),
                            Text(
                              '$result',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          //**********************************************************
          widget.whatEnglish == 'repairs'
              ? Padding(
            padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
            child: Card(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SingleChildScrollView(
                    child: ListTile(
                      title:
                      Center(child: Text('Felhasznált alkatrészek')),
                      subtitle: create(),
                    ),
                  ),
                ],
              ),
            ),
          )
              : Container(
            height: 0,
          ),
          //**********************************************************
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: widget.color,
        onPressed: () async {
          ProgressDialog pd = ProgressDialog(context: context);
          pd.show(max: 100, msg: 'Jegyzőkönyv készül...');
            await writeOnPdf();
            await savePdf();

            final bytes = await pdf.save();
            final blob = html.Blob([bytes], 'application/pdf');
            final url = html.Url.createObjectUrlFromBlob(blob);
            html.window.open(url, '_blank');
          pd.close();
            html.Url.revokeObjectUrl(url);

     },
        child: Icon(
          Icons.picture_as_pdf_rounded,
          color: Color(0xffffc108),
        ),
      ),
    );
  }

  //************************************************************************
  Future<void> getAddress() async {
    final counters =
    await widget.database
        .companyIdStream(widget.company)
        .first;
    final allAddress = counters.map((e) => e.address).toList();
    setState(() {
      _address = allAddress[0];
    });
  }

  getData() async {
    if(widget.nr != '') {
      widget.whatEnglish == 'operationEnd' ?
      setEvent() :
      await retrieveEvent();
    }
    await retrieveProduct();
    await getAddress();
  }

  //************************************************************************
  setEvent() {
    doer = widget.nr;
    nr = DateTime.now().millisecondsSinceEpoch
        .toString()
        .substring(2, 8) +
        '/${DateTime.now().year}';
    date = DateTime.now().toIso8601String().substring(0, 10);
    eventType = 'Eljárás';
    result = 'Leselejtezve';
    comment = '';
    nextDate = 'nincs';
  }


  //**********************************************************************

  Future<void> retrieveEvent() async {
    var _nr = widget.nr.substring(0, 6);
    try {
      await widget.database
          .getEvent(widget.company, _nr, widget.whatEnglish)
          .then((value) => _event = value);
      setState(() {
        if (_event != null) {
          nr = _event.nr;
          date = _event.date;
          nextDate = _event.nextDate;
          result = _event.result;
          doer = _event.doer;
          comment = _event.comment;
          eventType = _event.type;
        } else {
          print('null is the result');
        }
      });
    } on PlatformException {
      AlertDialog(
        title: Text('Művelet sikertelen'),);
    }
  }

  Future<void> retrieveProduct() async {
    try {
      await widget.database
          .getProduct(widget.company, widget.productId)
          .then((value) => _product = value);
      setState(() {
        if (_product != null) {
          type = _product.type;
          description = _product.description;
          length = _product.length;
          capacity = _product.capacity;
          manufacturer = _product.manufacturer;
          site = _product.site;
          person = _product.person;
        } else {
          print('null is the result');
        }
      });
    } on PlatformException {
      AlertDialog(
        title: Text('Művelet sikertelen'),);
    }
  }

  //******************************************************************
  Widget create({BuildContext context}) {
    return StreamBuilder<List<PartModel>>(
      stream:
      widget.database.oneDateRepairPartsStream(widget.company, widget.nr),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<PartModel> parts = snapshot.data;

          if (parts.isNotEmpty) {
            partsList = [];
            partTable = [];
            for (var part in parts) {
              partsList.add(part);
              partTable.add([part.pieces, part.unit, part.type]);
            }

            return partList(context);
          } else {
            partsList = [];
            return Center(
              child: Text(
                'Nem volt alkatrészfelhasználás!',
                style: TextStyle(color: Colors.red, fontSize: 14),
              ),
            );
          }
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

  Widget partList(BuildContext context) {
    return Container(
      height: MediaQuery
          .of(context)
          .size
          .height * 0.2,
      child: ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: partsList.length,
        itemBuilder: (BuildContext context, int index) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                      '${partsList[index].pieces}  ${partsList[index].unit}  '),
                  Text(
                    '${partsList[index].type}  ',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
