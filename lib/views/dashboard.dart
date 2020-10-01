
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Color colorBackground = Color.fromRGBO(166,166,247,1);
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
              color: Colors.blue,
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
              //key: Key(nodes.elementAt(i).name),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              elevation: 5,
              child: Container(
                height: 150,
                padding: EdgeInsets.all(10),
                child: Stack(
                  children: [
                    Positioned(
                      child: Image(
                        width: 75,
                        height: 75,
                        image: AssetImage("assets/images/header.jpg"),
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
                                Text("Dempul"),
                              ],
                            ),
                          ],
                        )
                      )
                    ),
                    Positioned(
                      bottom: 20,
                      height: 20,
                      child: Row(
                        children: [
                          Container(
                            height: 3,
                            width: MediaQuery.of(context).size.width * 0.1,
                            color: Colors.grey,
                          ),
                          Container(
                            height: 3,
                            width: MediaQuery.of(context).size.width * 0.1,
                            color: Colors.grey,
                          ),
                          Container(
                            height: 3,
                            width: MediaQuery.of(context).size.width * 0.1,
                            color: Colors.grey,
                          ),
                          Container(
                            height: 3,
                            width: MediaQuery.of(context).size.width * 0.1,
                            color: Colors.grey,
                          ),
                          Container(
                            height: 3,
                            width: MediaQuery.of(context).size.width * 0.1,
                            color: Colors.grey,
                          ),
                          Container(
                            height: 3,
                            width: MediaQuery.of(context).size.width * 0.1,
                            color: Colors.grey,
                          ),
                          Container(
                            height: 3,
                            width: MediaQuery.of(context).size.width * 0.1,
                            color: Colors.grey,
                          ),
                          Container(
                            height: 3,
                            width: MediaQuery.of(context).size.width * 0.1,
                            color: Colors.grey,
                          ),
                          Container(
                            height: 3,
                            width: MediaQuery.of(context).size.width * 0.1,
                            color: Colors.grey,
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      bottom: 20,
                      height: 20,
                      child: Row(
                        children: [
                          Container(
                            alignment: Alignment.centerRight,
                            height: 10,
                            width: MediaQuery.of(context).size.width * 0.1 + 5,
                            child: Container(
                              width: 10, height:10,
                              decoration: new BoxDecoration(
                                color: Colors.blue,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                          Container(
                            alignment: Alignment.centerRight,
                            height: 10,
                            width: MediaQuery.of(context).size.width * 0.1,
                            child: Container(
                              width: 10, height:10,
                              decoration: new BoxDecoration(
                                color: Colors.blue,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                          Container(
                            alignment: Alignment.centerRight,
                            height: 10,
                            width: MediaQuery.of(context).size.width * 0.1,
                            child: Container(
                              width: 10, height:10,
                              decoration: new BoxDecoration(
                                color: Colors.blue,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                          Container(
                            alignment: Alignment.centerRight,
                            height: 10,
                            width: MediaQuery.of(context).size.width * 0.1,
                            child: Container(
                              width: 10, height:10,
                              decoration: new BoxDecoration(
                                color: Colors.blue,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                          Container(
                            alignment: Alignment.centerRight,
                            height: 10,
                            width: MediaQuery.of(context).size.width * 0.1,
                            child: Container(
                              width: 10, height:10,
                              decoration: new BoxDecoration(
                                color: Colors.blue,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                          Container(
                            alignment: Alignment.centerRight,
                            height: 10,
                            width: MediaQuery.of(context).size.width * 0.1,
                            child: Container(
                              width: 10, height:10,
                              decoration: new BoxDecoration(
                                color: Colors.blue,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                          Container(
                            alignment: Alignment.centerRight,
                            height: 10,
                            width: MediaQuery.of(context).size.width * 0.1,
                            child: Container(
                              width: 10, height:10,
                              decoration: new BoxDecoration(
                                color: Colors.blue,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                          Container(
                            alignment: Alignment.centerRight,
                            height: 10,
                            width: MediaQuery.of(context).size.width * 0.1,
                            child: Container(
                              width: 10, height:10,
                              decoration: new BoxDecoration(
                                color: Colors.blue,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      height: 20,
                      child: Row(
                        children: [
                          Container(
                            alignment: Alignment.centerRight,
                            height: 20,
                            width: MediaQuery.of(context).size.width * 0.1 + 5,
                            child: Text("Ketok",
                              style: TextStyle(
                                fontSize: 8,
                              ),
                            ),
                          ),
                          Container(
                            alignment: Alignment.centerRight,
                            height: 20,
                            width: MediaQuery.of(context).size.width * 0.1 + 5,
                            child: Text("Dempul",
                              style: TextStyle(
                                fontSize: 8,
                              ),
                            ),
                          ),
                          Container(
                            alignment: Alignment.centerRight,
                            height: 20,
                            width: MediaQuery.of(context).size.width * 0.1 + 5,
                            child: Text("Epoxy",
                              style: TextStyle(
                                fontSize: 8,
                              ),
                            ),
                          ),
                          Container(
                            alignment: Alignment.centerRight,
                            height: 20,
                            width: MediaQuery.of(context).size.width * 0.1 + 5,
                            child: Text("Cat",
                              style: TextStyle(
                                fontSize: 8,
                              ),
                            ),
                          ),
                          Container(
                            alignment: Alignment.centerRight,
                            height: 20,
                            width: MediaQuery.of(context).size.width * 0.1 + 5,
                            child: Text("Poles",
                              style: TextStyle(
                                fontSize: 8,
                              ),
                            ),
                          ),
                          Container(
                            alignment: Alignment.centerRight,
                            height: 20,
                            width: MediaQuery.of(context).size.width * 0.1 + 5,
                            child: Text("Perakitan",
                              style: TextStyle(
                                fontSize: 8,
                              ),
                            ),
                          ),
                          Container(
                            alignment: Alignment.centerRight,
                            height: 20,
                            width: MediaQuery.of(context).size.width * 0.1 + 5,
                            child: Text("Finishing",
                              style: TextStyle(
                                fontSize: 8,
                              ),
                            ),
                          ),
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
}
