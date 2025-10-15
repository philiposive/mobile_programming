import 'package:flutter/material.dart';
import 'DataRepository.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfilePage extends StatefulWidget //is an entire page
    {
  @override   //abstract from parent:
  State<ProfilePage> createState()  => ProfilePageState();
}

//declare what the state of the class is: setState()
class ProfilePageState extends State<ProfilePage> {

  late TextEditingController _phone;
  late TextEditingController _email;

  void initState() {
    super.initState();

    _phone = TextEditingController();
    _email = TextEditingController();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Profile Page")),

        body: Center(child:
          Column(mainAxisAlignment: MainAxisAlignment.center,
            children: [

              Text("Welcome back, ${DataRepository.login}"),

              Padding(child:
              TextField(
                //controller: login,
                  decoration:
                  InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'First Name')),
                  padding: EdgeInsets.fromLTRB(25, 0, 25, 0)),

              SizedBox(height: 20),

              Padding(child:
              TextField(
                //controller: login,
                  decoration:
                  InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Last Name')),
                  padding: EdgeInsets.fromLTRB(25, 0, 25, 0)),

              SizedBox(height: 20),

              Padding(
                  padding: EdgeInsets.fromLTRB(25, 0, 25, 0),
                  child:
                Row(children: [
                Flexible(child:
                TextField(
                    controller: _phone,
                    decoration:
                    InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Phone Number')),
                    ),

                ElevatedButton(
                    onPressed: () async {

                      var itCan = await canLaunch("tel: ${_phone.value.text}");

                      if(itCan)

                        launch("tel: ${_phone.value.text}");

                      else

                        showDialog(context: context,
                            builder: (context) => AlertDialog(
                              title: Text("The URL is not supported on this device")
                            ));

                    },
                    child: IconButton(onPressed: () {}, icon: Icon(Icons.phone))
                ),

                ElevatedButton(
                    onPressed: () {},
                    child: IconButton(onPressed: () {}, icon: Icon(Icons.sms))
                ),

              ])),

              SizedBox(height: 20),

              Padding(
                  padding: EdgeInsets.fromLTRB(25, 0, 25, 0),
                  child:
                Row(children: [
                Flexible(child:
                TextField(
                  //controller: login,
                    decoration:
                    InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Email Address')),
                    ),

                ElevatedButton(
                    onPressed: () {},
                    child: IconButton(onPressed: () {}, icon: Icon(Icons.email)))
              ]))
            ])
        )
    );
  }
}