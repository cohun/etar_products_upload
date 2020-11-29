import 'package:etar_products_upload/src/auth/web_auth_provider.dart';
import 'package:etar_products_upload/src/main_screen.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AuthProvider().initialize();
  runApp(MyApp());
}
