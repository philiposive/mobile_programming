import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, //this hides the debug banner
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var myFontSize = 30.0;
  var isChecked = false;
  late TextEditingController login;
  late TextEditingController password;
  var fileToShow = "images/question_mark.png";
  var labelToShow = "question mark";

  @override
  void initState() {
    super.initState();
    login = TextEditingController();
    password = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    login.dispose();
    password.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(

      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child:

        Padding(padding: EdgeInsets.fromLTRB(5, 10, 5, 10),

        child:

        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[

            Text("BROWSE CATEGORIES", style: TextStyle(fontSize: 30.0, color: Colors.black),),

            SizedBox(height: 10),

            Row(mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text("Not sure about exactly which recipe you're looking for? Do a search, or dive into our most popular categories.", style: TextStyle(fontSize: 15.0, color: Colors.black),
            ),
          ],
            ),

            SizedBox(height: 10),

            Text("BY MEAT", style: TextStyle(fontSize: 25.0, color: Colors.black),),

            SizedBox(height: 5),

            Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [

                Stack(
                    alignment: AlignmentDirectional.center,
                    children: [
                      CircleAvatar(
                          backgroundImage: AssetImage('images/beef.jpg'),
                          radius:50),
                      Text("Beef", style: TextStyle(fontSize: 20.0, color: Colors.white),)
                  ],
                ),

                Stack(
                    alignment: AlignmentDirectional.center,
                    children: [
                      CircleAvatar(
                          backgroundImage: AssetImage('images/chicken.jpg'),
                          radius:50),
                      Text("Chicken", style: TextStyle(fontSize: 20.0, color: Colors.white),)
                  ],
                ),

                Stack(
                    alignment: AlignmentDirectional.center,
                    children: [
                      CircleAvatar(
                          backgroundImage: AssetImage('images/pork.jpg'),
                          radius:50),
                      Text("Pork", style: TextStyle(fontSize: 20.0, color: Colors.white),)
                  ],
                ),

                Stack(
                    alignment: AlignmentDirectional.center,
                    children: [
                      CircleAvatar(
                          backgroundImage: AssetImage('images/seafood.jpg'),
                          radius:50),
                      Text("Seafood", style: TextStyle(fontSize: 20.0, color: Colors.white),)
                  ],
                ),
              ],
            ),

            SizedBox(height: 10),

            Text("BY COURSE", style: TextStyle(fontSize: 25.0, color: Colors.black),),

            SizedBox(height: 5),

            Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [

                Stack(
                    alignment: AlignmentDirectional.bottomCenter,
                    children: [
                      CircleAvatar(
                          backgroundImage: AssetImage('images/main.jpg'),
                          radius:50),
                      Text("Main Dishes", style: TextStyle(fontSize: 20.0, color: Colors.black),)
                  ],
                ),

                Stack(
                    alignment: AlignmentDirectional.bottomCenter,
                    children: [
                      CircleAvatar(
                          backgroundImage: AssetImage('images/salad.jpg'),
                          radius:50),
                      Text("Salad Recipes", style: TextStyle(fontSize: 20.0, color: Colors.black),)
                  ],
                ),

                Stack(
                    alignment: AlignmentDirectional.bottomCenter,
                    children: [
                      CircleAvatar(
                          backgroundImage: AssetImage('images/side.jpg'),
                          radius:50),
                      Text("Side Dishes", style: TextStyle(fontSize: 20.0, color: Colors.black),)
                  ],
                ),

                Stack(
                    alignment: AlignmentDirectional.bottomCenter,
                    children: [
                      CircleAvatar(
                          backgroundImage: AssetImage('images/pot.jpg'),
                          radius:50),
                      Text("Crockpot", style: TextStyle(fontSize: 20.0, color: Colors.black),)
                  ],
                ),
              ],
            ),

            SizedBox(height: 10),

            Text("BY DESSERT", style: TextStyle(fontSize: 25.0, color: Colors.black),),

            SizedBox(height: 5),

            Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [

                Stack(
                    alignment: AlignmentDirectional.bottomCenter,
                    children: [
                      CircleAvatar(
                          backgroundImage: AssetImage('images/icecream.jpg'),
                          radius:50),
                      Text("Ice Cream", style: TextStyle(fontSize: 20.0, color: Colors.black),)
                  ],
                ),

                Stack(
                    alignment: AlignmentDirectional.bottomCenter,
                    children: [
                      CircleAvatar(
                          backgroundImage: AssetImage('images/brownie.jpg'),
                          radius:50),
                      Text("Brownies", style: TextStyle(fontSize: 20.0, color: Colors.black),)
                  ],
                ),

                Stack(
                    alignment: AlignmentDirectional.bottomCenter,
                    children: [
                      CircleAvatar(
                          backgroundImage: AssetImage('images/pie.jpg'),
                          radius:50),
                      Text("Pies", style: TextStyle(fontSize: 20.0, color: Colors.black),)
                  ],
                ),

                Stack(
                    alignment: AlignmentDirectional.bottomCenter,
                    children: [
                      CircleAvatar(
                          backgroundImage: AssetImage('images/cookie.jpg'),
                          radius:50),
                      Text("Cookies", style: TextStyle(fontSize: 20.0, color: Colors.black),)
                  ],
                ),
              ],
            ),

    ])
            //Padding(padding: EdgeInsets.fromLTRB(0, 50, 0, 0),
            
            //child:Text('You have typed: ${_controller.value.text}', style:TextStyle(fontSize:myFontSize))),

            //Semantics(child:Image.asset("images/algonquin.jpg", height:100, width:100),
            //    label:'Algonquin College Logo'),
        ),
      )
    );
  }

  void setNewValue(double num){

    setState(() {
      myFontSize = num;
    });

  }

  void buttonClicked(){

  }

}