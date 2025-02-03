import 'package:flutter/material.dart';


/// Main Color
Color mainColor() => const Color(0xff051B48); // Main Color
Color SecondColor() => const Color(0xffc6191b); // Second Color
Color green91() => const Color(0xff051B48); /// Button
Color blue64() => const Color(0xff0F6C5F);
LinearGradient greenGradint() => LinearGradient(
  colors: [
    mainColor(),
    green91()
  ],
  begin: Alignment.bottomCenter,
  end: Alignment.topCenter
);

// use in drawer background color
Color green63 = const Color(0xff00BA63);

// AppBar
Color drawerUserNameColor = const Color(0xffffffff);



// NAV
Color navBarHomeIconColor = const Color(0xffffffff);
Color navBarIconColor = const Color(0xffffffff); //icons
Color navBarTextColor = const Color(0xffffffff); // icons text


///Keep It
Color keepItTextColor() => const Color(0xff000000);
Color textIconsNav() => const Color(0xffFF0100);

// grey Shade
Color grey33 = const Color(0xff2F3133);
Color grey3A = const Color(0xff1D2D3A);
Color grey5E = const Color(0xff5E5E5E);
Color greyD0 = const Color(0xffABB7D0);
Color greyB2 = const Color(0xffA9AEB2);
Color greyA5 = const Color(0xffA5A5A5);
Color greyCF = const Color(0xffCFCFCF);
Color greyE7 = const Color(0xffE7E7E7);
Color greyF8 = const Color(0xffF8F8F8);
Color greyFA = const Color(0xffFAFAFA);
LinearGradient greyGradint = LinearGradient(
  colors: [
    Colors.black.withOpacity(.8),
    Colors.black.withOpacity(0),
  ],
  begin: Alignment.bottomCenter,
  end: Alignment.topCenter
);



// Semantics
Color red49 = const Color(0xffFF4949);
Color yellow29 = const Color(0xffFFC529);
Color orange50 = const Color(0xffFE7950);



// Semantics
Color green50 = const Color(0xff8FBF50);
Color green4B = const Color(0xff0F6C5F);
Color green9D = const Color(0xff50BF9D);

Color cyan50 = const Color(0xff50BF9D);
Color blueFE = const Color(0xff5090FE);
Color blueA4 = const Color(0xff2849A4);
Color yellow4C = const Color(0xffFFCD4C);




// Shadow
BoxShadow boxShadow(Color color,{int blur=20,int y=8,int x=0}){
  return BoxShadow(
    color: color,
    blurRadius: blur.toDouble(),
    offset: Offset(x.toDouble(), y.toDouble())
  );
}