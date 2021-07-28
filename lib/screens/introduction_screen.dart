
import 'package:flutter_complete_guide/route/custom_route.dart';
import 'package:flutter_complete_guide/screens/tab_screen.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/providers/auth_api.dart';
import 'package:google_fonts/google_fonts.dart';




class Introduction extends StatefulWidget {
  @override
  _IntroductionState createState() => _IntroductionState();
}

class _IntroductionState extends State<Introduction> {
  @override
  Widget build(BuildContext context) {
    var _widdth = MediaQuery.of(context).size.width;
    var _height =
        MediaQuery.of(context).size.height + MediaQuery.of(context).padding.top;
    var _theme = Theme.of(context);
    return Scaffold(
      backgroundColor: Colors.grey.shade900,
      body: Center(
        child: Container(
          width: _widdth * 0.8,
          height: _height * 0.07,
          child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                side: BorderSide(color: Colors.grey.shade800),
                primary: _theme.primaryColor, // background
                onPrimary: Colors.white, // foreground
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CircleAvatar(
                      backgroundImage: AssetImage('assets/embrom.png')),
                  Text('Continue With Google',
                      style: GoogleFonts.nunito(
                          fontSize: 18, fontWeight: FontWeight.w600)),
                  CircleAvatar(
                      backgroundColor: Colors.white,
                      backgroundImage: AssetImage('assets/google.png')),
                ],
              ),
              onPressed: () {
                Provider.of<AuthProvider>(context, listen: false)
                    .signInWithGoogle().then((value) {
                      Navigator.of(context).push(  CustomRoute(builder: (context) => TabsScreen()))
                      ;
                    });
              }),
        ),
      ),
    );
  }
}
