
import 'package:cat_app/providers/order.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:cat_app/widgets/styled_flat_button.dart';
import 'package:cat_app/providers/auth.dart';
import 'package:cat_app/models/order.dart';
import 'package:cat_app/models/ordercomment.dart';
import 'package:cat_app/views/orderdetails.dart';
enum ProcessStatus { 
   unfinished, 
   running, 
   finished
}
Color colorBackground = Color.fromRGBO(166,166,247,1);
Color colorBlue = Color(0xFF102C58);
//Color colorIsOnFire = Color.fromRGBO(97,255,139,1);
Color colorIsOnFire1 = Colors.greenAccent;
Color colorIsOnFire2 = Colors.greenAccent;
// decoration: BoxDecoration(
//                           gradient: LinearGradient(
//                             colors: [Color.fromRGBO(245, 158, 59,1), Color.fromRGBO(212, 41, 11,1)],
//                             begin: Alignment.topLeft,
//                             end: Alignment.bottomRight,
//                           ),
//                         ),
Color colorIsOnFireFont = Colors.white;

class Dashboard extends StatefulWidget {
  
  Dashboard({Key key, this.title}) : super(key: key);

  //HomePage({Key key, this.app, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".
  
  final String title;
  //final FirebaseApp app; 

  @override
  _DashboardState createState() => _DashboardState();
}
class _DashboardState extends State<Dashboard> {
  var top;
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ));
    return Scaffold(
      backgroundColor: Color(0xFFF1F1F1),
      floatingActionButton: _selectedIndex == 0 ? FloatingActionButton(
          onPressed: () {
            Navigator.pushNamed(context, '/neworder');
          },
          child: Icon(Icons.add),
          backgroundColor: colorBlue,
      ) : null,
      bottomNavigationBar: BottomNavigationBar(
        elevation: 16,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text('Home'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            title: Text('Profil'),
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: colorBlue,
        onTap: _onItemTapped,
      ),
      body: generateBody(context, _selectedIndex),
    );
  }

  @override
  void initState() {
    super.initState();
  }

  dynamic reloadOrders(BuildContext context) async {
    List<Order> orders = await Provider.of<OrderProvider>(context, listen: false).getAllOrder();
    List<OrderComment> comment = await Provider.of<OrderProvider>(context, listen: false).getAllComments(orders);
    return {orders,comment};
  }
  Widget generateBody(BuildContext context, int index){
    if(index==0){
      return CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            backgroundColor: colorBlue,
            expandedHeight: MediaQuery.of(context).size.height * 0.25,
            floating: false,
            pinned: true,
            snap: false,
            elevation: 50,
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              title: 
              // Text("Monitoring Car Service",
              //   style: TextStyle(
              //     fontFamily: 'Bebas',
              //   ),
              // ),
              LayoutBuilder(
                builder: (context, constraints) {
                top = constraints.biggest.height;
                return FlexibleSpaceBar(
                  titlePadding: EdgeInsets.only(top: 10),
                  centerTitle: true,
                  title: top < 100 ? Text("Monitoring Car Service") : dropDownTitle(),
                );
              }),
              
              background: Stack(
                children: [
                  SizedBox.expand(
                    child: Image(
                      image: AssetImage("assets/images/header.jpg"),
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                  SizedBox.expand(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Color(0xAA000000),
                      ),
                    ),
                  ),
                ],
              ),
              
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [Container(
                child: _buildList(context),
              )],
            ),
          ),
        ],
      );
    } else return Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Stack(
          alignment: Alignment.center,
          children: [
            StyledFlatButton(
              'Log out',
              onPressed: (){
                Provider.of<AuthProvider>(context, listen: false).logOut();
                //Navigator.pop(context);
              }
            ),
          ],
        ),
      );
  }
  
  Widget _buildList(BuildContext context) {
    return FutureBuilder(
      future : reloadOrders(context),
      builder: (context, snap){
        // if(snap.data == null){
        //   return Container(
        //     width: 10,
        //   );
        // }
        
        List<Order> listorder = snap.data.elementAt(0);
        List<OrderComment> listcomment = snap.data.elementAt(1);
        List<Widget> cardlist = [];
        if(listorder != null){
          cardlist.add(
            Padding(
              padding: EdgeInsets.only(left: 10, right: 10),
              child: Container(
                height: 50,
                alignment: Alignment.bottomLeft,
                child: Text("Car Status",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: colorBlue,
                    fontSize: 20,
                  ),
                ),
              )
            )
          );
          int i=0;
          for(var order in listorder){
            cardlist.add(orderCard(order, listcomment.isEmpty ? null : listcomment[i]));
            i++;
          }
        }
        // return Column(children: [
        //   Container(height: 150, color: Colors.grey),
        //   Container(height: 150, color: Colors.blue),
        //   Container(height: 150, color: Colors.grey),
        //   Container(height: 150, color: Colors.blue),
        // ],);
        return Column(
          children: cardlist,
        );
      }
    );
  }

  Widget orderCard(Order order, OrderComment comment){
    return Padding(
      padding: EdgeInsets.all(5),
      child: GestureDetector(
        onTap: () async {
          await Navigator.of(context).push(MaterialPageRoute(builder: (context) => OrderDetails(order, comment)));
          setState((){});
        },
        child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            elevation: 5,
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: 150,
              padding: EdgeInsets.all(20),
              child: Stack(
                children: [
                  Positioned(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Image(
                        width: 75,
                        height: 75,
                        image: AssetImage("assets/images/car.png"),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 90,
                    child: Container(
                      child: Column(
                        crossAxisAlignment:  CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text("Name: ",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                              Text(order.customerName,
                                style: TextStyle(
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Text("Car Model: ",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                              Text(order.carId + " ",
                                style: TextStyle(
                                  fontSize: 12,
                                ),
                              ),
                              Text('('+ order.carPlateNum + ')',
                                style: TextStyle(
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Text("Order Date: ",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                              Text(order.createdAt.toString(),
                                style: TextStyle(
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Text("Estimated work finish: ",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                              Text(order.createdAt.toString(),
                                style: TextStyle(
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Text("Status: ",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                              Text(order.status,
                                style: TextStyle(
                                  color: Colors.blue,
                                ),
                              ),
                            ],
                          ),
                        ],
                      )
                    )
                  ),
                  Positioned(
                    bottom: 0,
                    height: 30,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        processIndicator("Ketok", ProcessStatus.finished, ProcessStatus.finished),
                        processIndicator("Dempul", ProcessStatus.running, ProcessStatus.unfinished),
                        processIndicator("Epoxy", ProcessStatus.unfinished, ProcessStatus.unfinished),
                        processIndicator("Cat", ProcessStatus.unfinished, ProcessStatus.unfinished),
                        processIndicator("Poles", ProcessStatus.unfinished, ProcessStatus.unfinished),
                        processIndicator("Perakitan", ProcessStatus.unfinished, ProcessStatus.unfinished),
                        processIndicator("Finishing", ProcessStatus.unfinished, ProcessStatus.unfinished),
                      ],
                    ),
                   ),
                ],
              )
            ),
          ),
      )
          
    );
  }
  Widget dropDownTitle(){
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text("Monitoring"),
        Text("Car Service"),
        Text("Developed by Pekerja Sejati",
          style: TextStyle(
            fontSize: 8,
          ),
        ),
      ],
    );
  }
  Widget processIndicator(String processTxt, ProcessStatus currentStatus, nextStatus){
    List<Color> barColor = [Colors.grey, Colors.green, Colors.green];
    return Container(
      width: MediaQuery.of(context).size.width * 0.12,
      //height: 50,
      //color: Colors.grey,
      child: Column(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              Row(
                children: [
                  Container(
                    height: 3,
                    width: MediaQuery.of(context).size.width * 0.06,
                    color: barColor[currentStatus.index],
                  ),
                  Container(
                    height: 3,
                    width: MediaQuery.of(context).size.width * 0.06,
                    color: barColor[nextStatus.index],
                  ),
                ],
              ),
              
              Container(
                width: 10, height:10,
                  decoration: new BoxDecoration(
                    color: colorBlue,
                    shape: BoxShape.circle,
                  ),                     
              ),
            ],
          ),
          SizedBox(
            height: 8,
          ),
          Container(
            alignment: Alignment.bottomCenter,
            width: MediaQuery.of(context).size.width * 0.12,
            child: Text(processTxt,
              style: TextStyle(
                fontSize: 9,
                color: currentStatus == ProcessStatus.running ? Colors.blue :  barColor[nextStatus.index],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
