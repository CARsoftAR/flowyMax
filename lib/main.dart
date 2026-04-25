import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'injection_container.dart' as di;
import 'presentation/screens/home_screen.dart';
import 'presentation/bloc/player_bloc.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  // Preservamos el splash nativo inmediatamente
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  
  // Inicializamos servicios y cargamos datos mientras el splash nativo es visible
  await di.init();
  
  // Simulación de carga mínima para que el usuario aprecie el logo nítido
  await Future.delayed(const Duration(seconds: 2));
  
  // Removemos el splash nativo y entramos a la Home
  FlutterNativeSplash.remove();
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<PlayerBloc>(
          create: (context) => di.sl<PlayerBloc>(),
        ),
      ],
      child: MaterialApp(
        title: 'Flowy v2',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          brightness: Brightness.dark,
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFFFF4D00),
            brightness: Brightness.dark,
          ),
          useMaterial3: true,
          textTheme: GoogleFonts.poppinsTextTheme(
            ThemeData.dark().textTheme,
          ),
        ),
        home: const HomeScreen(),
      ),
    );
  }
}
