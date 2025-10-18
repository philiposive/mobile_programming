import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'DataRepository.dart';
import 'main.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';

class ProfilePage extends StatefulWidget //is an entire page
    {

  @override   //abstract from parent:
  State<ProfilePage> createState()  => ProfilePageState();

}

//declare what the state of the class is: setState()
class ProfilePageState extends State<ProfilePage> {

  late TextEditingController _fname;
  late TextEditingController _lname;
  late TextEditingController _phone;
  late TextEditingController _email;

  void initState() {

    super.initState();
    _fname = TextEditingController();
    _lname = TextEditingController();
    _phone = TextEditingController();
    _email = TextEditingController();

    var prefs = EncryptedSharedPreferences();

    _fname.addListener(() async {
        //set the repository and save

        await prefs.setString("MySavedFirstName", _fname.value.text);
        //await prefs.setString("MySavedLastName", _lname.value.text);
        //await prefs.setString("MySavedPhoneNumber", _phone.value.text);
        //await prefs.setString("MySavedEmail", _email.value.text);

      });

    _lname.addListener(() async {
        //set the repository and save

        //await prefs.setString("MySavedFirstName", _fname.value.text);
        await prefs.setString("MySavedLastName", _lname.value.text);
        //await prefs.setString("MySavedPhoneNumber", _phone.value.text);
        //await prefs.setString("MySavedEmail", _email.value.text);

      });

      _phone.addListener(() async {
        //set the repository and save

        //await prefs.setString("MySavedFirstName", _fname.value.text);
        //await prefs.setString("MySavedLastName", _lname.value.text);
        await prefs.setString("MySavedPhoneNumber", _phone.value.text);
        //await prefs.setString("MySavedEmail", _email.value.text);

      });

      _email.addListener(() async {
        //set the repository and save

        //await prefs.setString("MySavedFirstName", _fname.value.text);
        //await prefs.setString("MySavedLastName", _lname.value.text);
        //await prefs.setString("MySavedPhoneNumber", _phone.value.text);
        await prefs.setString("MySavedEmail", _email.value.text);

      });

    Future.delayed(Duration.zero, () async {
      //start loading from disk, not async/but (await) before moving on

      var fname = await prefs.getString("MySavedFirstName");
      var lname = await prefs.getString("MySavedLastName");
      var phone = await prefs.getString("MySavedPhoneNumber");
      var email = await prefs.getString("MySavedEmail");
      //use the same variable as in setString()

      //put back onto the page:
      //if (fname != null)
        _fname.text = fname;
      //if (lname != null)
        _lname.text = lname;
      //if (phone != null)
        _phone.text = phone;
      //if (email != null)
        _email.text = email;

  });

  }

  @override
  void dispose() {

    super.dispose();
    _fname.dispose();
    _lname.dispose();
    _phone.dispose();
    _email.dispose();

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
                  controller: _fname,
                  decoration:
                  InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'First Name')),
                  padding: EdgeInsets.fromLTRB(25, 0, 25, 0)),

              SizedBox(height: 20),

              Padding(child:
              TextField(
                  controller: _lname,
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
                    onPressed: () {},
                    child: IconButton(onPressed: () async {

                      var itCan = await canLaunch("tel://${_phone.value.text}");

                      if(itCan) {
                        launch("tel://${_phone.value.text}");
                      }

                      else {

                        showDialog(context: context,
                            builder: (context) => AlertDialog(
                                title: Text("The URL is not supported on this device")
                            ));

                    }}, icon: Icon(Icons.phone))
                ),

                ElevatedButton(
                    onPressed: () {},
                    child: IconButton(onPressed: () async {

                      var itCan = await canLaunch("sms://${_phone.value.text}");

                      if(itCan) {
                        launch("sms://${_phone.value.text}");
                      }

                      else {

                        showDialog(context: context,
                            builder: (context) => AlertDialog(
                                title: Text("The URL is not supported on this device")
                            ));

                    }}, icon: Icon(Icons.sms))
                ),

              ])),

              SizedBox(height: 20),

              Padding(
                  padding: EdgeInsets.fromLTRB(25, 0, 25, 0),
                  child:
                Row(children: [
                Flexible(child:
                TextField(
                    controller: _email,
                    decoration:
                    InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Email Address')),
                    ),

                ElevatedButton(
                    onPressed: () {},
                    child: IconButton(onPressed: () async {

                      var URI = Uri.parse("mailto://${_email.value.text}");

                      var itCan = await canLaunchUrl(URI);

                      if(itCan) {
                        launchUrl(URI);
                      }

                      else {

                        showDialog(context: context,
                            builder: (context) => AlertDialog(
                                title: Text("The URL is not supported on this device")
                            ));

                    }}, icon: Icon(Icons.email)))
              ]))
            ])
        )
    );
  }

}