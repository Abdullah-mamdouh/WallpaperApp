import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wallpaper/pages/home.dart';
import 'package:wallpaper/provider/ProviderHelper.dart';
import 'package:wallpaper/provider/theme_provider.dart';
import 'package:wallpaper/splashScreen.dart';

Future<void> main() async {
  WidgetsFlutterBinding w = await WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences pref = await SharedPreferences.getInstance();
  //List photo = pref.getStringList('favo_Photos');
 // print(photo.toString());
  
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
              //themeMode: Provider.of<ThemeProvider>(context).themeMode,
              theme: MyThemes.lightTheme,
              darkTheme: MyThemes.darkTheme,
        home: SplashScreen(),
      ),
      providers: [
        ChangeNotifierProvider(create: (_) => ProviderHelper()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
    );

  }
}
