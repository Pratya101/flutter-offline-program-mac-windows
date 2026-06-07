part of '../../../main.dart';

class HomeShell extends StatefulWidget {
  const HomeShell({
    super.key,
    required this.database,
    required this.authService,
    required this.profile,
    required this.databasePath,
    required this.onLogout,
    required this.onProfileChanged,
  });

  final AppDatabase database;
  final AuthService authService;
  final User profile;
  final Future<String> databasePath;
  final VoidCallback onLogout;
  final Future<void> Function() onProfileChanged;

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  late final BackupService _backupService;
  var _selectedIndex = 0;
  var _exporting = false;

  @override
  void initState() {
    super.initState();
    _backupService = BackupService(widget.database);
  }

  Future<void> _exportBackup() async {
    setState(() => _exporting = true);
    try {
      final backup = await _backupService.exportZipBackup();
      _showMessage('สร้างไฟล์สำรองข้อมูลแล้ว: ${backup.file.path}');
    } finally {
      if (mounted) {
        setState(() => _exporting = false);
      }
    }
  }

  void _showMessage(String message) {
    if (!mounted) {
      return;
    }
    _showToast(context, message);
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      WelcomePage(
        profile: widget.profile,
        authService: widget.authService,
        onProfileChanged: widget.onProfileChanged,
      ),
      CustomerCrudPage(
        database: widget.database,
        customerService: CustomerService(widget.database),
      ),
      ProductCrudPage(
        database: widget.database,
        productService: ProductService(widget.database),
      ),
      SaleListPage(
        database: widget.database,
        saleService: SaleService(widget.database),
      ),
      TrackingPage(trackingService: TrackingService(widget.database)),
      SalePage(
        database: widget.database,
        saleService: SaleService(widget.database),
      ),
      UserCrudPage(
        database: widget.database,
        authService: widget.authService,
        currentUser: widget.profile,
        onCurrentUserChanged: widget.onProfileChanged,
        onCurrentUserDeleted: widget.onLogout,
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('โปรแกรมออฟไลน์'),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: FilledButton.icon(
              onPressed: _exporting ? null : _exportBackup,
              icon: _exporting
                  ? const SizedBox.square(
                      dimension: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(SolarIconsOutline.archive),
              label: const Text('สำรองข้อมูล'),
            ),
          ),
          const SizedBox(width: 8),
          Center(
            child: Text(
              widget.profile.fullName,
              style: Theme.of(context).textTheme.labelLarge,
            ),
          ),
          IconButton(
            tooltip: 'ออกจากระบบ',
            onPressed: widget.onLogout,
            icon: const Icon(SolarIconsOutline.logout),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Row(
        children: [
          NavigationRail(
            selectedIndex: _selectedIndex,
            onDestinationSelected: (value) {
              setState(() => _selectedIndex = value);
            },
            labelType: NavigationRailLabelType.all,
            destinations: const [
              NavigationRailDestination(
                icon: Icon(SolarIconsOutline.home),
                selectedIcon: Icon(SolarIconsBold.home),
                label: Text('หน้าหลัก'),
              ),
              NavigationRailDestination(
                icon: Icon(SolarIconsOutline.userSpeakRounded),
                selectedIcon: Icon(SolarIconsBold.userSpeakRounded),
                label: Text('ลูกค้า'),
              ),
              NavigationRailDestination(
                icon: Icon(SolarIconsOutline.box),
                selectedIcon: Icon(SolarIconsBold.box),
                label: Text('สินค้า'),
              ),
              NavigationRailDestination(
                icon: Icon(SolarIconsOutline.billList),
                selectedIcon: Icon(SolarIconsBold.cartLarge),
                label: Text('รายการขาย'),
              ),
              NavigationRailDestination(
                icon: Icon(SolarIconsOutline.alarm),
                selectedIcon: Icon(SolarIconsBold.alarm),
                label: Text('ติดตาม'),
              ),
              NavigationRailDestination(
                icon: Icon(SolarIconsOutline.cartLarge),
                selectedIcon: Icon(SolarIconsBold.cartLarge),
                label: Text('ขาย'),
              ),
              NavigationRailDestination(
                icon: Icon(SolarIconsOutline.usersGroupRounded),
                selectedIcon: Icon(SolarIconsBold.usersGroupRounded),
                label: Text('ผู้ใช้'),
              ),
            ],
          ),
          const VerticalDivider(width: 1),
          Expanded(child: pages[_selectedIndex]),
        ],
      ),
      bottomNavigationBar: FutureBuilder<String>(
        future: widget.databasePath,
        builder: (context, snapshot) {
          final path = snapshot.data ?? 'กำลังเตรียมฐานข้อมูลในเครื่อง...';
          return Material(
            color: _softSlateColor,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
              child: Row(
                children: [
                  const Icon(SolarIconsOutline.database, size: 18),
                  const SizedBox(width: 8),
                  Expanded(
                    child: SelectableText(
                      path,
                      maxLines: 1,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
