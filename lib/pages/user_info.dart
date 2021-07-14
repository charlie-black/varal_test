import 'dart:convert';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pay/pay.dart';
import 'package:varal_test/Models/products.dart';
import 'package:varal_test/pages/signin.dart';
import 'package:varal_test/pages/success.dart';
import 'package:varal_test/utils/authentication.dart';
import 'package:http/http.dart' as http;


class PaymentScreen extends StatefulWidget {
  const PaymentScreen({Key? key, required User user})
      : _user = user,
        super(key: key);

  final User _user;

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
var _paymentItems = <PaymentItem>[];
  late User _user;
  bool _isSigningOut = false;

  String removeAllHtmlTags(String htmlText) {
    RegExp exp = RegExp(
        r'<[^>]*>|&[^;]+;',
        multiLine: true,
        caseSensitive: true
    );

    return htmlText.replaceAll(exp, '');
  }
  final GlobalKey<ScaffoldState> scaffoldState = GlobalKey();
   List? data;
  int _currentIndex = 0;


  Future<String> getData() async {
    var response = await http.get(
        Uri.parse("https://insurancemoto.herokuapp.com/"),
        headers: {"Accept": "application/json"});

    this.setState(() {
      data = json.decode(response.body);
    });
    //print(data[1]["title"]);

    return "Success!";
  }

  @override
  void initState() {
    _user = widget._user;
    super.initState();
    this.getData();
  }


  Route _routeToSignInScreen() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => SignInScreen(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = Offset(-1.0, 0.0);
        var end = Offset.zero;
        var curve = Curves.ease;

        var tween =
        Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple[50],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.deepPurple,
        title: Text("Varal Test"),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.exit_to_app,
              color: Colors.white,
            ),
            onPressed: ()  async {
              setState(() {
                _isSigningOut = true;
              });
              await Authentication.signOut(context: context);
              setState(() {
                _isSigningOut = false;
              });
              Navigator.of(context)
                  .pushReplacement(_routeToSignInScreen());
            },
          )
        ],
      ),
      body: data == null ?  Column(
                children: <Widget>[

                  SizedBox(height: 200,),
                  Center(child: SpinKitCubeGrid(
                    itemBuilder: (BuildContext context, int index) {
                      return DecoratedBox(
                        decoration: BoxDecoration(
                          color: index.isEven ? Colors.deepPurple : Colors.yellow,
                        ),
                      );
                    },
                  )),
                ],
              ) :

              data!.isNotEmpty
                  ? ListView.builder(


                itemCount: data == null ? 0 : data!.length,
                itemBuilder: (BuildContext context, int index) {


                  return Container(
                    margin: EdgeInsets.all(8.0),
                    child: Card(
                        color:  Color(0xFF414278),
                        child: Container(
                          padding: EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              SizedBox(
                                height: 8.0,
                              ),
                              ExpansionTile(
                                title: Text(
                                  data![index]["name"],
                                  style: TextStyle(
                                    color: Colors.yellow,fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.justify,
                                ),
                                leading: CircleAvatar(backgroundImage: NetworkImage("https://www.nairobibusinessmonthly.com/wp-content/uploads/2020/01/life-insurance-istock_fb.jpg"),),
                                children: <Widget>[

                                  Image.network(
                                    data![index]["image"],
                                    height: 300,
                                    width: 300,
                                  ),

                                  Text(
                                    removeAllHtmlTags("Description:"+data![index]["description"]),
                                    style: TextStyle(
                                      color: Colors.deepPurple[50],fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.justify,
                                  ),

                                  SizedBox(height: 8,),
                                  Text("Price : "+"Ksh "+
                                    data![index]["price"].toString(),
                                    style: TextStyle(
                                      color: Colors.deepPurple[50],fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.justify,
                                  ),
                                  GooglePayButton(//This is the google pay button
                                    width: 300,
                                    paymentConfigurationAsset: 'gpay.json',//getting data from the configuration json with gpay info
                                    paymentItems: _paymentItems = [ //this are the items to be paid
                                      PaymentItem(
                                        label: data![index]["name"],//fetching the item name from the remote db using the rest API
                                        amount: data![index]["price"].toString(),//fetching the selected item price
                                        status: PaymentItemStatus.final_price,
                                      )
                                    ],
                                    style: GooglePayButtonStyle.black,
                                    type: GooglePayButtonType.pay,
                                    margin: const EdgeInsets.only(top: 15.0),
                                    onPaymentResult:(data){ print(data);

                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => SuccessPage()),//once the payment is complete it navigates to the success page
                                      );
                                    },
                                    loadingIndicator: const Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                  ),

                                ],



                              ),



                            ],



                          ),

                        )

                    ),

                  );

                },

              ):Center(child: Column(
                children: <Widget>[
                  SizedBox(height: 200,),
                  Center(
                    child: Image.asset("assets/sad.png",

                      height: 50, width: 50,),
                  ),
                  SizedBox(height: 20,),
                  Text("Sorry, there are no Announcements at the moment",
                    style: TextStyle(
                      color: Colors.deepPurple,
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),),
                ],
              ),),



    );
  }
}