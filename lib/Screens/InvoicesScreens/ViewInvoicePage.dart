import 'package:arjunagym/Models/GymPlanModel.dart';
import 'package:arjunagym/Models/MemberModel.dart';
import 'package:arjunagym/Provider/GymPlanProvider.dart';
import 'package:arjunagym/Screens/CustomBottomNavigationBar.dart';
import 'package:arjunagym/Screens/DashBoard.dart';
import 'package:arjunagym/Models/InvoiceModel.dart';
import 'package:arjunagym/Resources/PdfApi.dart';
import 'package:arjunagym/Screens/InvoicesScreens/PdfInvoicePage.dart';
import 'package:arjunagym/Widgets/UniversalVariables.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ViewInvoicePage extends StatefulWidget {
  final MemberModel member;
  const ViewInvoicePage({super.key, required this.member});

  @override
  State<ViewInvoicePage> createState() => _ViewInvoicePageState();
}

class _ViewInvoicePageState extends State<ViewInvoicePage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }
  @override
  Widget build(BuildContext context) {
    final plans = Provider.of<GymPlanProvider>(context, listen: false).plans;
    final plan = GymPlanModel.findById(plans, widget.member.planId);
    final planName = plan?.name ?? 'Unknown Plan';
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Invoice',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: UniversalVariables.appThemeColor,
        iconTheme: IconThemeData(
          color: Colors.white, //change your color here
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () async{
                final date = DateTime.now();
                final dueDate = DateTime.now();
                final invoice = Invoice(
                    owner: Owner(
                        name:'Arjuna Fitness Gym',
                        address: 'Opposite Hajare PetrolPump,Chimur-442903',
                        mobileNumber: '9404102064'
                    ),
                    customer: Customer(
                        name: widget.member.name,
                        address: widget.member.address,
                        mobileNumber : widget.member.mobileNumber,
                        dateOfAdmission: widget.member.dateOfAdmission,
                        expiryDate: widget.member.expiryDate,
                        gender: widget.member.gender
                    ),
                    info: InvoiceInfo(
                        todayDate: date,
                        invoiceDate: dueDate,
                        invoiceNumber:'${DateTime.now()}',
                        transactionType: 'Cash'

                    ),
                    items:[
                      InvoiceItem(
                          description: plan?.name ?? 'Unknown Plan',
                          fees: '${plan!.fee}',
                          applied: 1,
                          total: '${plan.fee}',
                          months:'${plan.months}'
                      ),
                    ]
                );
                final pdfFile = await PdfInvoiceApi.generate(invoice);
                PdfApi.openFile(pdfFile);
              },
              child: Text('Generate Invoice'),
            ),
            SizedBox(height: 30,),
            ElevatedButton(
              onPressed: (){
                Navigator.of(context)
                    .pushNamedAndRemoveUntil('/home', (Route<dynamic> route) => false);
              },
              child: Text('Back to Homepage'),
            ),
          ],
        ),
      ),
    );
  }
}
