import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

void main() => runApp(First());

class First extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: new MyApp(),
    );
  }
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  GlobalKey<FormState> _form = GlobalKey<FormState>();
  TextEditingController nameInput;
  TextEditingController phoneInput;
  TextEditingController emailInput;

  String get arg => null;

  String get username => null;

  void initState() {
    nameInput = new TextEditingController();
    phoneInput = new TextEditingController();
    emailInput = new TextEditingController();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          backgroundColor: Colors.red,
          title: Center(child: new Text('RedPositive')),
        ),
        body: Form(
          key: _form,
          child: new Column(children: <Widget>[
            SizedBox(
              height: 15,
            ),
            new ListTile(
              leading: const Icon(Icons.person),
              title: new TextFormField(
                validator: nameValidator,
                controller: nameInput,
                decoration: new InputDecoration(
                  hintText: "Name",
                ),
              ),
            ),
            new ListTile(
              leading: const Icon(Icons.phone),
              title: new TextFormField(
                validator: phoneValidator,
                controller: phoneInput,
                decoration: new InputDecoration(
                  hintText: "Phone",
                ),
              ),
            ),
            new ListTile(
              leading: const Icon(Icons.email),
              title: new TextFormField(
                validator: emailValidator,
                controller: emailInput,
                decoration: new InputDecoration(
                  hintText: "Email",
                ),
              ),
            ),
            SizedBox(height: 15.0),
            new Center(
              child: new RaisedButton(
                  color: Colors.green,
                  onPressed: () async {
                    if (_form.currentState.validate()) {
                      // final smtpServer = gmail(username, arg);
                      // Message msg;
                      // final message = Message()
                      //   ..from = Address(username, 'Your name')
                      //   ..recipients.add('vamshi777reddy@gmail.com')
                      //   // ..ccRecipients.addAll(['${emailInput.text}'])
                      //   // ..bccRecipients.add(Address(''))
                      //   ..subject = 'Mail from the ${nameInput.text}'
                      //   ..text =
                      //       'This mail is from user who ordered this product'
                      //   ..html =
                      //       "<h1 style='color:blue;'>Contact Details</h1>\n<p>Hey!  \n<h3 >Name :- ${nameInput.text}\n </h3><h3> Mobile NO:-  ${phoneInput.text} \n </h3><h3>Email ID:- ${emailInput.text} \n </h3>  </p>";

                      // try {
                      //   final sendReport = await send(message, smtpServer);
                      //   print('Message sent: ' + sendReport.toString());
                      // } on MailerException catch (e) {
                      //   print('Message not sent.');
                      //   for (var p in e.problems) {
                      //     print('Problem: ${p.code}: ${p.msg}');
                      //   }
                      //   print('Message not sent.');
                      // }
                      // msg = Message()
                      //   ..from = Address(username, 'Your name')
                      //   ..recipients.add('vamshi777reddy@gmail.com')
                      //   // ..ccRecipients.addAll(['${emailInput.text}'])
                      //   // ..bccRecipients.add(Address(''))
                      //   ..subject = 'Mail from the ${nameInput.text}'
                      //   ..text =
                      //       'This mail is from user who ordered this product'
                      //   ..html =
                      //       "<h1 style='color:blue;'>Contact Details</h1>\n<p>Hey!  \n<h3 >Name :- ${nameInput.text}\n </h3><h3> Mobile NO:-  ${phoneInput.text} \n </h3><h3>Email ID:- ${emailInput.text} \n </h3>  </p>";

                      _launchURL('info@redpositive.com', 'Redpositive Task',
                          '''${nameInput.text},${phoneInput.text},${emailInput.text}''');
                      await Firestore.instance
                          .collection('positive')
                          .document(nameInput.text)
                          .setData({
                            "name": nameInput.text,
                            "email": emailInput.text,
                            "mobile": phoneInput.text,
                          })
                          .then((result) => {
                                Navigator.pop(context),
                                nameInput.clear(),
                                phoneInput.clear(),
                                emailInput.clear(),
                              })
                          .catchError((err) =>
                              Text("Please check the details properly"));
                    }
                  },
                  child: new Text('Submit')),
            ),
          ]),
        ));
  }

  _launchURL(String toMailId, String subject, String body) async {
    var url = 'mailto:$toMailId?subject=$subject&body=$body';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}

String nameValidator(String value) {
  if (value.length < 6) {
    return "please fill this field with atleast 6 characters";
  } else {
    return null;
  }
}

String phoneValidator(String value) {
  if (value.length != 10) {
    return 'Phone Number must be of 10 digits';
  } else {
    return null;
  }
}

String emailValidator(String value) {
  //need to write the efficient validator here
  Pattern pattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  RegExp regex = new RegExp(pattern);
  if (!regex.hasMatch(value)) {
    return 'Email format is invalid';
  } else {
    return null;
  }
}
