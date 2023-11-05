import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:http/http.dart' as http;
import 'package:scanneerrrrrrrrrr/loading.dart';
import 'desc.dart';
import 'dart:convert';
import 'notFound.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool isLoading = false;
  Future<void> details(String barcode) async {
    print(
        "###############################\n###############################\n###############\n##################\n#########################");




    var response;

    void get() async{

      isLoading = true;

      final String title;
      final String price;
      final String link;
      final String desc;
      final String weight;
      final String brand;
      final String serialNo;
      final String mfgDate;
      final String expDate;
      final String sellStatus;



      const url = "https://blockchain-api-pt82.onrender.com/api/products/single";
       response = await http.get(Uri.parse("$url/$barcode"));

      print(
          "***********###############${response.statusCode}########################**********");
      // response.statusCode =200;
      isLoading = false;
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        var x = data["product"];
        if(x==null){
          print("############PRODUCT NOT FOUND#######################");
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=>NotFound(),),);
          print("############PRODUCT NOT FOUND#######################");
        }
        var basicDetails = x["basicDetails"];
        var tracking = x["tracking"];
        var exp = x["expiration"];

        title = basicDetails["productName"].toString();
        price = basicDetails["price"].toString();
        link = basicDetails["productImg"].toString();
        desc = basicDetails["description"].toString();
        brand = basicDetails["brand"].toString();
        weight = basicDetails["weight"].toString();
        serialNo = tracking["serialNumber"].toString();
        mfgDate = exp["manufacturingDate"].toString();
        expDate = exp["expirationDate"].toString();
        sellStatus = x["sellStatus"].toString();

        //   price = "";
        //   link = "";
        // //  desc = " dummy";

        print("###############${data.length}#########################");
        print("###############${data.length}#########################");
        print("$title , $price,$desc,$link");
        print("$title , $price,$desc,$link");
        print("$title , $price,$desc,$link");

        print("############${barcode}########################**********");

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => Desc(
                title: title,
                price: price,
                url: link,
                desc: desc,
                brand: brand,
                mfgDate: mfgDate,
                expDate: expDate,
                sellStatus: sellStatus,
                serialNo: serialNo,
                weight: weight,
            ),
          ),
        );
      } else {
        print(
            "************************something is wrong($barcode)*******************************");
      }
    }

    get();


  }

  Future<void> scanBarcode() async {
    String barcode = await FlutterBarcodeScanner.scanBarcode(
      "#ff6666",
      "Cancel",
      true,
      ScanMode.BARCODE,
    );
    print("%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%");
    print(barcode);
    details(barcode);
    Navigator.push(context, MaterialPageRoute(builder: (_)=>Loading()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Scan Details"),
        centerTitle: true,
        backgroundColor: Color(0xff10b981),
      ),
      body: Center(
        child: GestureDetector(
          child: Container(
            height: 300,
            width: 300,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(25),
              // boxShadow: [
              //   BoxShadow(
              //       blurRadius: 10, color: Colors.teal, offset: Offset(10, 10))
              // ],
            ),
            child: Column(
              children: [
                SizedBox(
                  height: 250,
                  width: 250,
                  child: Image.asset(
                    'assets/scanner.png',
                  ),
                ),
                Text(
                  "Tap to Scan",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontSize: 30,
                  ),
                )
              ],
            ),
          ),
          onTap: scanBarcode,
        ),
      ),
    );
  }
}
