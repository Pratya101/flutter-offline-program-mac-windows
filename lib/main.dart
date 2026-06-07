import 'dart:async';

import 'package:drift/native.dart';
import 'package:flutter/foundation.dart' show ValueListenable;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:solar_icons/solar_icons.dart';

import 'src/database/app_database.dart';
import 'src/database/database_connection.dart';
import 'src/services/auth_service.dart';
import 'src/services/backup_service.dart';
import 'src/services/contract_print_service.dart';
import 'src/services/customer_service.dart';
import 'src/services/product_service.dart';
import 'src/services/sale_service.dart';
import 'src/services/tracking_service.dart';

part 'src/app/shared_ui.dart';
part 'src/app/formatters.dart';
part 'src/features/auth/login_page.dart';
part 'src/features/shell/home_shell.dart';
part 'src/features/home/welcome_page.dart';
part 'src/features/customers/customer_crud_page.dart';
part 'src/features/products/product_crud_page.dart';
part 'src/features/sales/sale_list_page.dart';
part 'src/features/sales/sale_page.dart';
part 'src/features/tracking/tracking_page.dart';
part 'src/features/users/user_crud_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(OfflineProgramApp(database: AppDatabase()));
}

class OfflineProgramApp extends StatefulWidget {
  const OfflineProgramApp({
    super.key,
    required this.database,
    this.databasePath,
  });

  final AppDatabase database;
  final Future<String>? databasePath;

  @override
  State<OfflineProgramApp> createState() => _OfflineProgramAppState();
}

class _OfflineProgramAppState extends State<OfflineProgramApp> {
  late final AuthService _authService;
  User? _profile;

  @override
  void initState() {
    super.initState();
    _authService = AuthService(widget.database);
  }

  @override
  void dispose() {
    widget.database.close();
    super.dispose();
  }

  Future<void> _setProfile(User user) async {
    final profile = await _authService.getProfile(user.id);
    if (mounted) {
      setState(() => _profile = profile);
    }
  }

  Future<void> _refreshProfile() async {
    final profile = _profile;
    if (profile == null) {
      return;
    }
    await _setProfile(profile);
  }

  void _logout() {
    setState(() => _profile = null);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'โปรแกรมออฟไลน์',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: _primaryColor,
          brightness: Brightness.light,
          primary: _primaryColor,
          surface: _surfaceColor,
        ),
        scaffoldBackgroundColor: _appBackgroundColor,
        appBarTheme: const AppBarTheme(
          backgroundColor: _surfaceColor,
          foregroundColor: Color(0xFF0F172A),
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          centerTitle: false,
        ),
        textTheme: GoogleFonts.googleSansTextTheme(ThemeData.light().textTheme),
        primaryTextTheme: GoogleFonts.googleSansTextTheme(
          ThemeData.light().primaryTextTheme,
        ),
        navigationRailTheme: NavigationRailThemeData(
          backgroundColor: _surfaceColor,
          indicatorColor: _softMintColor,
          selectedIconTheme: IconThemeData(color: _primaryColor),
          selectedLabelTextStyle: GoogleFonts.googleSans(
            color: _primaryColor,
            fontWeight: FontWeight.w700,
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: _surfaceBorderColor),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: _primaryColor, width: 1.5),
          ),
          filled: true,
          fillColor: _surfaceColor,
          prefixIconColor: _primaryColor,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 14,
          ),
        ),
        filledButtonTheme: FilledButtonThemeData(
          style:
              FilledButton.styleFrom(
                backgroundColor: _primaryColor,
                foregroundColor: _surfaceColor,
                disabledBackgroundColor: const Color(0xFFB8C7C4),
                disabledForegroundColor: _surfaceColor,
                minimumSize: const Size(0, 44),
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 13,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                textStyle: GoogleFonts.googleSans(fontWeight: FontWeight.w700),
                elevation: 0,
              ).copyWith(
                overlayColor: WidgetStateProperty.resolveWith((states) {
                  if (states.contains(WidgetState.pressed)) {
                    return _primaryPressedColor.withValues(alpha: 0.14);
                  }
                  if (states.contains(WidgetState.hovered)) {
                    return _surfaceColor.withValues(alpha: 0.08);
                  }
                  return null;
                }),
              ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: _primaryColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            textStyle: GoogleFonts.googleSans(fontWeight: FontWeight.w700),
          ),
        ),
        iconButtonTheme: IconButtonThemeData(
          style: IconButton.styleFrom(
            foregroundColor: const Color(0xFF475569),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        cardTheme: CardThemeData(
          color: _surfaceColor,
          surfaceTintColor: Colors.transparent,
          shadowColor: const Color(0x1C0F172A),
          elevation: 8,
          margin: EdgeInsets.zero,
          clipBehavior: Clip.antiAlias,
          shape: RoundedRectangleBorder(
            borderRadius: _cardBorderRadius(),
            side: const BorderSide(color: _surfaceBorderColor),
          ),
        ),
      ),
      home: _profile == null
          ? LoginPage(authService: _authService, onAuthenticated: _setProfile)
          : HomeShell(
              database: widget.database,
              authService: _authService,
              profile: _profile!,
              databasePath: widget.databasePath ?? defaultDatabasePath(),
              onLogout: _logout,
              onProfileChanged: _refreshProfile,
            ),
    );
  }
}

AppDatabase createInMemoryDatabaseForTests() {
  return AppDatabase(NativeDatabase.memory());
}
