/* FILE NAME: make-pdf.dart */
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart'; // pdf: ^3.6.0
import 'preview-pdf.dart';
import 'package:flutter/widgets.dart' as dw;
import 'package:pdf/widgets.dart' as pw; // pdf: ^3.6.0
import 'dart:io';
import 'package:file_saver/file_saver.dart';
import 'dart:typed_data';
// import 'package:path_provider/path_provider.dart';
void main() async {
  runApp(MyApp());
}

class Invoice {
  final String? customer;
  final String? address;
  final List<LineItem>? items;
  final String? name;
  Invoice({this.customer, this.address, this.items, this.name});
  double totalCost() {
    return items!.fold(0, (previousValue, element) => previousValue + element.cost);
  }
}

class LineItem {
  final String description;
  final double cost;

  LineItem(this.description, this.cost);
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Buat File PDF',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Buat PDF'),
          backgroundColor: Colors.green[700],
        ),
        body: HomePage()
      )
    );
  }
}
class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // var items = [0,12,1];
   /* final invoices = {
        'customer': 'David Thomas',
        'address': '123 Fake St\r\nBermuda Triangle',
        'items':[0,1,2]
      };
  */

  @override
  Widget build(BuildContext context) {
    final invoice = [
      Invoice(
          customer: 'David Thomas',
          address: '123 Fake St\r\nBermuda Triangle',
          items: [
            LineItem(
              'Technical Engagement',
              120,
            ),
            LineItem('Deployment Assistance', 200),
            LineItem('Develop Software Solution', 3020.45),
            LineItem('Produce Documentation', 840.50),
          ],
          name: 'Create and deploy software package'),
    ];

    print(invoice[0].items![2]);
    return (
      dw.Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Table(
              border: TableBorder.all(
                color: Colors.black
              ),
              children: [
                // The first row just contains a phrase 'INVOICE FOR PAYMENT'
                TableRow(
                  children: [
                    Padding(
                      child: Text(
                        'INVOICE FOR PAYMENT',
                        textAlign: TextAlign.center,
                      ),
                      padding: EdgeInsets.all(20),
                    ),
                    Padding(
                      child: Text(
                        'INVOICE FOR PAYMENT',
                        textAlign: TextAlign.center,
                      ),
                      padding: EdgeInsets.all(20),
                    )
                  ],
                ),
                ...invoice[0].items!.map(
    // Each new line item for the invoice should be rendered on a new TableRow
                    (e) => TableRow(
                      children: [
                        TableCell(
                          verticalAlignment: TableCellVerticalAlignment.middle,
                          child: PaddedText2(e.description)
                        ),
                        // Again, with a flex parameter of 1, the cost widget will be 33% of the
                        // available width.
                        TableCell(
                          verticalAlignment: TableCellVerticalAlignment.middle,
                          child: PaddedText2("\$${e.cost}")
                        ),
                      ],
                    ),
                ),
                TableRow(
                  children: [
                    PaddedText('TAX', align: TextAlign.right),
                    PaddedText('\$${(invoice[0].totalCost() * 0.1).toStringAsFixed(2)}'),
                  ],
                ),
                // Show the total 
                TableRow(
                  children: [
                    PaddedText('TOTAL', align: TextAlign.right),
                    PaddedText("\$${invoice[0].totalCost()}"),
                  ],
                )
              ]
              ),
            Padding(
              child: Text(
                "THANK YOU FOR YOUR BUSINESS!"
              ),
              padding: EdgeInsets.all(20),
            ),
            ElevatedButton(
              child: Text('Cetak PDF'),
              onPressed: () => Navigator.push(context,
                MaterialPageRoute(builder: (context) => PreviewPDF(invoice: invoice[0]))
              )
            ),
            ElevatedButton(
              child: Text('Unduh PDF'),
              onPressed: () async {
                final Uint8List dataPDF = await simpanPDF(invoice[0]);

                MimeType type = MimeType.PDF;
                await FileSaver.instance.saveAs("File", dataPDF, "pdf", type);
              }
                /* {
                 Directory tempDir = await getTemporaryDirectory();
                Directory appDocDir = await getApplicationDocumentsDirectory();
                Future<Directory?> _externalDocumentsDirectory = getExternalStorageDirectory();
              

                final Uint8List pdf = pw.Document();
                pdf.addPage(
                  pw.Page(
                    pageFormat: PdfPageFormat.legal,
                    build: (context) {
                      return pw.Center(
                        child: pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.center,
                          mainAxisAlignment: pw.MainAxisAlignment.center,
                          children: [
                            pw.Table(
                              border: pw.TableBorder.symmetric(
                                inside: pw.BorderSide(width:2, color: PdfColors.blue, style: pw.BorderStyle.solid),
                                outside: pw.BorderSide(width:2, color: PdfColors.red,style: pw.BorderStyle.solid)
                              ),
                              children: [
                                // The first row just contains a phrase 'INVOICE FOR PAYMENT'
                                pw.TableRow(
                                  children: [
                                    pw.Padding(
                                      child: pw.Text(
                                        'INVOICE FOR PAYMENT',
                                        textAlign: pw.TextAlign.center,
                                      ),
                                      padding: pw.EdgeInsets.all(20),
                                    ),
                                    pw.Padding(
                                      child: pw.Text(
                                        'INVOICE FOR PAYMENT',
                                        textAlign: pw.TextAlign.center,
                                      ),
                                      padding: pw.EdgeInsets.all(20),
                                    )
                                  ],
                                ),
                                // The remaining rows contain each item from the invoice, and uses the
                                // map operator (the ...) to include these items in the list
                                ...invoice[0].items!.map(
                                    (e) => pw.TableRow(
                                      verticalAlignment: pw.TableCellVerticalAlignment.middle,
                                      children: [
                                        pw.Text(e.description),
                                        pw.Text("\$${e.cost}"),
                                      ],
                                    ),
                                ),
                                pw.TableRow(
                                  children: [
                                    pw.Text('TAX'),
                                    pw.Text('\$${(invoice[0].totalCost() * 0.1).toStringAsFixed(2)}'),
                                  ],
                                ),
                                pw.TableRow(
                                  children: [
                                    pw.Text('TOTAL'),
                                    pw.Text("\$${invoice[0].totalCost()}"),
                                  ],
                                )
                              ]
                              ),
                            pw.Padding(
                              child: pw.Text(
                                "THANK YOU FOR YOUR BUSINESS!"
                              ),
                              padding: pw.EdgeInsets.all(20),
                            ),
                          ]
                        )
                      );
                    }
                )
                );

                /* print ('Alamat Direktori: ' + _externalDocumentsDirectory.toString());
                print ('Temporary Directory: ' + tempDir.path);
                print ('Direktori Dokumen Aplikasi: ' + appDocDir.path);
                */
                // File file = File(appDocDir.path + '/BuatPDF.pdf');
                File file = File('/storage/emulated/0/Download/BuatPDF3.pdf');
                try {
                  await file.writeAsBytes(await pdf.save());
                  print('Pembuatan File PDF Sukses');
                }
                catch (e) {
                  print('Eksespsi kesalahan: ' + e.toString());
                }
              } */
            )
          ]
        )
      )
    );
  }
}

Future<Uint8List> simpanPDF(Invoice invoice) async {
  final pdf = pw.Document();
  pdf.addPage(
    pw.Page(
      pageFormat: PdfPageFormat.legal,
      build: (context) {
        return pw.Center(
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.center,
            mainAxisAlignment: pw.MainAxisAlignment.center,
            children: [
              pw.Table(
                border: pw.TableBorder.symmetric(
                  inside: pw.BorderSide(width:2, color: PdfColors.blue, style: pw.BorderStyle.solid),
                  outside: pw.BorderSide(width:2, color: PdfColors.red,style: pw.BorderStyle.solid)
                ),
                children: [
                  // The first row just contains a phrase 'INVOICE FOR PAYMENT'
                  pw.TableRow(
                    children: [
                      pw.Padding(
                        child: pw.Text(
                          'INVOICE FOR PAYMENT',
                          textAlign: pw.TextAlign.center,
                        ),
                        padding: pw.EdgeInsets.all(20),
                      ),
                      pw.Padding(
                        child: pw.Text(
                          'INVOICE FOR PAYMENT',
                          textAlign: pw.TextAlign.center,
                        ),
                        padding: pw.EdgeInsets.all(20),
                      )
                    ],
                  ),
                  // The remaining rows contain each item from the invoice, and uses the
                  // map operator (the ...) to include these items in the list
                  ...invoice.items!.map(
                      (e) => pw.TableRow(
                        verticalAlignment: pw.TableCellVerticalAlignment.middle,
                        children: [
                          pw.Text(e.description),
                          pw.Text("\$${e.cost}"),
                        ],
                      ),
                  ),
                  pw.TableRow(
                    children: [
                      pw.Text('TAX'),
                      pw.Text('\$${(invoice.totalCost() * 0.1).toStringAsFixed(2)}'),
                    ],
                  ),
                  pw.TableRow(
                    children: [
                      pw.Text('TOTAL'),
                      pw.Text("\$${invoice.totalCost()}"),
                    ],
                  )
                ]
                ),
              pw.Padding(
                child: pw.Text(
                  "THANK YOU FOR YOUR BUSINESS!"
                ),
                padding: pw.EdgeInsets.all(20),
              ),
            ]
          )
        );
      }
  )
  );

  /* print ('Alamat Direktori: ' + _externalDocumentsDirectory.toString());
  print ('Temporary Directory: ' + tempDir.path);
  print ('Direktori Dokumen Aplikasi: ' + appDocDir.path);

  File file = File(appDocDir.path + '/BuatPDF.pdf');
  File file = File('/storage/emulated/0/Download/BuatPDF3.pdf');
  try {
    await file.writeAsBytes(await pdf.save());
    print('Pembuatan File PDF Sukses');
  }
  catch (e) {
    print('Eksespsi kesalahan: ' + e.toString());
  } */
  return await pdf.save();
}

Widget PaddedText(
  final String text, {
  final TextAlign align = TextAlign.left,
}) => Padding(
    padding: EdgeInsets.all(10),
    child: Container(
      decoration: BoxDecoration(
        border: Border.all()
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            text,
            textAlign: align,
          ),
        ],
      )
    )   
);

Widget PaddedText2(
  final String text, {
  final TextAlign align = TextAlign.left,
}) => Padding(
  padding: EdgeInsets.all(10),
    child: Text(text, textAlign: align,
  )
);