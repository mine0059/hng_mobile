import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hng_mobile/blocs/switch_bloc/switch_bloc.dart';
import 'package:hng_mobile/screens/home_screen.dart';
import 'package:hng_mobile/screens/quiz_screen.dart';
import 'package:hng_mobile/screens/sql_home_screen.dart';
import 'package:hng_mobile/theme/theme.dart';
import 'package:hng_mobile/utils/contract.dart';
import 'package:hng_mobile/utils/sql_helper.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'screens/product_list_screen.dart';

ShoppingHelper? shoppingHelper;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  shoppingHelper = ShoppingHelper();
  String databasePath = await getDatabasesPath();
  String path = join(databasePath, ShoppingContract.dbName);
  await shoppingHelper!.open(path);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SwitchBloc()..loadTheme(),
      child: BlocBuilder<SwitchBloc, SwitchState>(
        builder: (context, state) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'HNG Mobile',
            // theme: state.switchValue
            //     ? AppThemes.appThemeData[AppTheme.lightTheme]
            //     : AppThemes.appThemeData[AppTheme.darkTheme],
            theme: ThemeData(primarySwatch: Colors.blue),
            // home: const HomeScreen(),
            // home: const QuizScreen(),
            // home: const SqlHomeScreen(),
            home: const ProductListScreen(),
          );
        },
      ),
    );
  }
}
