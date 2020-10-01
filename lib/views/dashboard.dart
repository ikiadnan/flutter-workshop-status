
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
enum ProcessStatus { 
   unfinished, 
   running, 
   finished
}
Color colorBackground = Color.fromRGBO(166,166,247,1);
Color colorBlue = Color(0xFF092F5C);
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
 

  Color colorBlue1 = Color.fromRGBO(70, 192, 226,1);
  Color colorBlue2 = Color.fromRGBO(71, 63, 194,1);
  Color colorOrange1 = Color.fromRGBO(245, 158, 59,1);
  Color colorOrange2 = Color.fromRGBO(212, 14, 11,1);

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
      backgroundColor: Colors.grey[200],
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            leading: IconButton(
              icon: Icon(Icons.menu),
              onPressed: (){},
            ),
            backgroundColor: Color.fromRGBO(71, 140, 194,1),
            expandedHeight: MediaQuery.of(context).size.height * 0.25,
            floating: false,
            pinned: true,
            snap: false,
            elevation: 50,
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              title: Text("Monitoring Cars"),
              background: Image(
                image: AssetImage("assets/images/header.jpg"),
                fit: BoxFit.fitWidth,
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(_buildList()),
          )
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
  }

  List _buildList(){
    List<Widget> listItems = List();
      listItems.add(
        Container(
          padding: EdgeInsets.all(10),
          child: Text("Car Status",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: colorBlue,
              fontSize: 20,
            ),
          ),
        )
      );
      for (int i = 0; i < 10; i++) {
        listItems.add(
          Padding(
            padding: EdgeInsets.all(5),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              elevation: 5,
              child: Container(
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
                                Text("Faziri Nur Kholis",
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
                                Text("Toyota Alphard G ",
                                  style: TextStyle(
                                    fontSize: 12,
                                  ),
                                ),
                                Text("AB 46 US",
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
                                Text("3 October 2020",
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
                                Text("20 October 2020",
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
                                Text("Dempul",
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
          ),
        );
      }
    return listItems;
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
