// preview-pdf.dart 
import 'package:flutter/material.dart';
import 'package:printing/printing.dart'; // printing: ^5.3.0
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'dart:typed_data';
// import 'dart:io';
import 'main.dart';

/* void main() async {
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
      title: 'Contoh Tabel Flutter',
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
*/

/* class PreviewPDF extends StatefulWidget {
  final Invoice invoice;
  PreviewPDF({Key? key, required this.invoice}) : super(key: key);
  
  _PreviewPDFState createState() => _PreviewPDFState();
}*/
  
class PreviewPDF extends StatelessWidget {
  final Invoice invoice;
  PreviewPDF({Key? key, required this.invoice}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title:Text('Preview PDF')),
      body: PdfPreview(
        build: (format) => _generatePdf(format, invoice),
        allowSharing: true,
        allowPrinting: true,
        initialPageFormat: PdfPageFormat.legal,
        pdfFileName: "PDF ku.pdf"
      )    
    );   
  }
}

Future<Uint8List> _generatePdf(PdfPageFormat format, Invoice invoice) async {
  final pdf = pw.Document();

  pdf.addPage(
    pw.Page(
      pageFormat: format,
      build: (context) {
        return pw.Center(
        child: pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.center,
          mainAxisAlignment: pw.MainAxisAlignment.center,
          children: [
            pw.Table(
              border: pw.TableBorder.symmetric(
                inside: pw.BorderSide(width:2, color: PdfColors.red, style: pw.BorderStyle.solid),
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
    // Each new line item for the invoice should be rendered on a new TableRow
                    (e) => pw.TableRow(
                      children: [
                        pw.Text(e.description),
                        pw.Text("\$${e.cost}")
                      ],
                    ),
                ),
                pw.TableRow(
                  children: [
                    pw.Text('TAX'),
                    pw.Text('\$${(invoice.totalCost() * 0.1).toStringAsFixed(2)}'),
                  ],
                ),
                // Show the total 
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
            )          ]
        )
      );
      },
    ),
  );

  return pdf.save();
}

/* Future<Widget> viewPDF(Invoice invoice) async{
  print ('view PDF');
  final pdf = pw.Document();

  pdf.addPage(
    pw.Page(
    build: (context) {
      return pw.Center(
        child: 
          pw.Text('makan')
        );
      }
    )
  );
   final file = File("example.pdf");
  await file.writeAsBytes(await pdf.save());
  return PdfPreview(
    // build: (context) => makePdf(invoice),
    build: (context) => pdf.save(),
    allowSharing: true,
    allowPrinting: true,
    initialPageFormat: PdfPageFormat.a4,
    pdfFileName: "mydoc.pdf"
  );
  
}
*/
/* Future<Uint8List> makePdf(Invoice invoice) async {
  print ('makePDF');
  final pdf = pw.Document();
  
  pdf.addPage(
    pw.Page(
    build: (context) {
      return pw.Center(
        child: 
          pw.Text('makan')
        );
      }
    )
  );
  return pdf.save();
}
*/
/* Widget PaddedText(
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
*/
