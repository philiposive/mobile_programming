import 'package:flutter/material.dart';
import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
  //var fileToShow = "images/question_mark.png";
  var labelToShow = "question mark";

  @override
  void initState() {
    super.initState();
    login = TextEditingController();
    password = TextEditingController();

    //void loadPreferences() async //background thread
    //    {
    Future.delayed(Duration.zero, () async {
      //start loading from disk, not async/but (await) before moving on
      var prefs = EncryptedSharedPreferences();

      var log = await prefs.getString("MySavedLogin");
      var pass = await prefs.getString("MySavedPassword");
      //use the same variable as in setString()

      //put back onto the page:
      if (log.isNotEmpty)
        login.text = log;
      if (pass.isNotEmpty)
        password.text = pass;

      var snackBar = SnackBar(
          content: Text('Previous data has been loaded'),
          action: SnackBarAction(label: "Ok",
              onPressed: () { }
      )
      );

      if (pass.isNotEmpty) ScaffoldMessenger.of(context).showSnackBar(snackBar);
    });
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
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme
            .of(context)
            .colorScheme
            .inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          //
          // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
          // action in the IDE, or press "p" in the console), to see the
          // wireframe for each widget.
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[

            //Padding(padding: EdgeInsets.fromLTRB(0, 50, 0, 0),

            //child:Text('You have typed: ${_controller.value.text}', style:TextStyle(fontSize:myFontSize))),

            //Semantics(child:Image.asset("images/algonquin.jpg", height:100, width:100),
            //    label:'Algonquin College Logo'),

            Padding(child:
            TextField(controller: login,
                decoration:
                InputDecoration(border: OutlineInputBorder(),
                    hintText: 'Login')),
                padding: EdgeInsets.fromLTRB(50, 0, 50, 0)),

            Padding(child:
            TextField(controller: password,
                obscureText: true,
                decoration:
                InputDecoration(border: OutlineInputBorder(),
                    hintText: 'Password')),
                padding: EdgeInsets.fromLTRB(50, 0, 50, 0)),

            //ElevatedButton(onPressed: buttonClicked, child: Text("Click me")),
            ElevatedButton(onPressed: () {
              showDialog<String>(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                        title: Text("Attention"),
                        content: Text(
                            "Would you like to save your username and password?"),
                        actions: [

                          OutlinedButton(onPressed:
                              () async
                          {

                            var prefs = EncryptedSharedPreferences(); //await SharedPreferences.getInstance(); //async, must wait
                            //Key is the variable name        //what the user typed

                            await prefs.setString(
                                "MySavedLogin", login.value.text);
                            await prefs.setString(
                                "MySavedPassword", password.value.text);

                            Navigator.pop(context); //free any memory from this alert dialog (buttons, text, etc.)
                          }, child: Text("Yes")),

                          OutlinedButton(onPressed: () {
                            var prefs = EncryptedSharedPreferences();
                            prefs.clear();

                            Navigator.pop(context);
                          }, child: Text("No")),

                        ]);
                  });

              //setState(() {
              //  var txt = password.value.text;
              //  setState(() {
              //    if(txt == 'QWERTY123') {
              //      fileToShow = "images/light_bulb.png"; labelToShow = "light bulb";
              //    }
              //    else {
              //      fileToShow = "images/stop.png";
              //      labelToShow = "stop sign";
              //    }
              //  });
              //});
            },
                child: Text('Login', style: TextStyle(
                    fontSize: myFontSize, color: Colors.blue))),

            //Semantics(child: Padding(padding: EdgeInsets.fromLTRB(0, 50, 0, 0),
            //    child: Image.asset(fileToShow, height: 300, width: 300)),
            //    label: labelToShow),

          ],
        ),
      ),
    );
  }

  void setNewValue(double num) {
    setState(() {
      myFontSize = num;
    });
  }

  void buttonClicked() {

  }

  //void loadPreferences() async //background thread
  //    {

    //start loading from disk, not async/but (await) before moving on
  //  var prefs = EncryptedSharedPreferences();

  //  var log = await prefs.getString("MySavedLogin");
  //  var pass = await prefs.getString("MySavedPassword");
    //use the same variable as in setString()

    //put back onto the page:
  //  if (log != null)
  //    login.text = log;
  //  if (pass != null)
  //    password.text = pass;
  //}
}