import 'package:flutter/material.dart';
import 'DataRepository.dart';

class ProfilePage extends StatefulWidget //is an entire page
    {
  @override   //abstract from parent:
  State<ProfilePage> createState()  => ProfilePageState();
}

//declare what the state of the class is: setState()
class ProfilePageState extends State<ProfilePage> {

  void initState() {
    super.initState();
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
                  padding: EdgeInsets.fromLTRB(50, 0, 50, 0)),

              SizedBox(height: 20),

              Padding(child:
              TextField(
                //controller: login,
                  decoration:
                  InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Last Name')),
                  padding: EdgeInsets.fromLTRB(50, 0, 50, 0)),

              SizedBox(height: 20),

              Row(children: [
                Padding(
                padding: EdgeInsets.fromLTRB(50, 0, 50, 0),
                child:
                Flexible(child:
                TextField(
                  //controller: login,
                    decoration:
                    InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Phone Number')),
                    )),

                ElevatedButton(
                    onPressed: () {},
                    child: IconButton(onPressed: () {}, icon: Icon(Icons.phone))
                ),

                ElevatedButton(
                    onPressed: () {},
                    child: IconButton(onPressed: () {}, icon: Icon(Icons.sms))
                ),

              ]),

              SizedBox(height: 20),

              Row(children: [
                Padding(
                padding: EdgeInsets.fromLTRB(50, 0, 50, 0),
                child:
                Flexible(child:
                TextField(
                  //controller: login,
                    decoration:
                    InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Email Address')),
                    )),

                ElevatedButton(
                    onPressed: () {},
                    child: IconButton(onPressed: () {}, icon: Icon(Icons.email))
                )
              ])
            ])
        ));
  }}