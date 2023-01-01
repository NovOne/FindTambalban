/* FILE NAME: flutter-table-example.dart */ 
import 'package:flutter/material.dart';

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
      title: 'Contoh Tabel Flutter',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Contoh Tabel Flutter'),
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
   final invoices = {
        'customer': 'David Thomas',
        'address': '123 Fake St\r\nBermuda Triangle',
        'items':[0,1,2]
      };

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
      Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Table(
              /*border: TableBorder(
                verticalInside: BorderSide(width:2, color: Colors.blue,style: BorderStyle.solid),
                top: BorderSide(width:2, color: Colors.blue,style: BorderStyle.solid),
                bottom: BorderSide(width:2, color: Colors.blue,style: BorderStyle.solid),
                right: BorderSide(width:2, color: Colors.blue,style: BorderStyle.solid),
                left: BorderSide(width:2, color: Colors.blue,style: BorderStyle.solid)
              ),*/
              border: TableBorder.symmetric(
                inside: BorderSide(width:2, color: Colors.blue,style: BorderStyle.solid),
                outside: BorderSide(width:2, color: Colors.red,style: BorderStyle.solid)
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
                // The remaining rows contain each item from the invoice, and uses the
                // map operator (the ...) to include these items in the list
                ...invoice[0].items!.map(
    // Each new line item for the invoice should be rendered on a new TableRow
                    (e) => TableRow(
                      children: [
                        // We can use an Expanded widget, and use the flex parameter to specify
                        // how wide this particular widget should be. With a flex parameter of
                        // 2, the description widget will be 66% of the available width.
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
            )
          ]
        )
      )
    );
  }
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

