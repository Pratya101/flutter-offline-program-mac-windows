part of '../../../main.dart';

class HomeShell extends StatefulWidget {
  const HomeShell({
    super.key,
    required this.database,
    required this.authService,
    required this.profile,
    required this.shop,
    required this.databasePath,
    required this.onLogout,
    required this.onProfileChanged,
    required this.onShopChanged,
  });

  final AppDatabase database;
  final AuthService authService;
  final User profile;
  final Shop shop;
  final Future<String> databasePath;
  final VoidCallback onLogout;
  final Future<void> Function() onProfileChanged;
  final Future<void> Function() onShopChanged;

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  late final BackupService _backupService;
  var _selectedIndex = 0;
  var _exporting = false;
  String? _saleDetailToOpenId;

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

  void _openCreatedSaleDetail(Sale sale) {
    setState(() {
      _saleDetailToOpenId = sale.id;
      _selectedIndex = 1;
    });
  }

  String get _currentReceiverName {
    final fullName = widget.profile.fullName.trim();
    return fullName.isEmpty ? widget.profile.username : fullName;
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      SalePage(
        database: widget.database,
        saleService: SaleService(widget.database),
        receiverName: _currentReceiverName,
        onSaleCreated: _openCreatedSaleDetail,
      ),
      SaleListPage(
        database: widget.database,
        saleService: SaleService(widget.database),
        receiverName: _currentReceiverName,
        initialSaleId: _saleDetailToOpenId,
      ),
      TrackingPage(trackingService: TrackingService(widget.database)),
      ProductCrudPage(
        database: widget.database,
        productService: ProductService(widget.database),
      ),
      CustomerCrudPage(
        database: widget.database,
        customerService: CustomerService(widget.database),
      ),
      UserCrudPage(
        database: widget.database,
        authService: widget.authService,
        currentUser: widget.profile,
        onCurrentUserChanged: widget.onProfileChanged,
        onCurrentUserDeleted: widget.onLogout,
      ),
    ];
    final selectedIndex = _selectedIndex < pages.length ? _selectedIndex : 0;

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 68,
        titleSpacing: 12,
        title: Row(
          children: [
            const Text('SoftSale Offline'),
            const SizedBox(width: 16),
            Expanded(
              child: _ShellTopMenuBar(
                destinations: _shellMenuDestinations,
                selectedIndex: selectedIndex,
                onDestinationSelected: (value) {
                  setState(() => _selectedIndex = value);
                },
              ),
            ),
            const SizedBox(width: 10),
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
            _ShellAccountSummary(profile: widget.profile, shop: widget.shop),
            const SizedBox(width: 6),
            IconButton(
              tooltip: 'ออกจากระบบ',
              onPressed: widget.onLogout,
              icon: const Icon(SolarIconsOutline.logout),
            ),
            const SizedBox(width: 8),
          ],
        ),
      ),
      body: pages[selectedIndex],
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

const _shellMenuDestinations = [
  _ShellMenuDestination(
    label: 'ขาย',
    icon: SolarIconsOutline.cartLarge,
    selectedIcon: SolarIconsBold.cartLarge,
  ),
  _ShellMenuDestination(
    label: 'รายการขาย',
    icon: SolarIconsOutline.billList,
    selectedIcon: SolarIconsBold.billList,
  ),
  _ShellMenuDestination(
    label: 'ติดตาม',
    icon: SolarIconsOutline.alarm,
    selectedIcon: SolarIconsBold.alarm,
  ),
  _ShellMenuDestination(
    label: 'สินค้า',
    icon: SolarIconsOutline.box,
    selectedIcon: SolarIconsBold.box,
  ),
  _ShellMenuDestination(
    label: 'ลูกค้า',
    icon: SolarIconsOutline.userSpeakRounded,
    selectedIcon: SolarIconsBold.userSpeakRounded,
  ),
  _ShellMenuDestination(
    label: 'ผู้ใช้งาน',
    icon: SolarIconsOutline.usersGroupRounded,
    selectedIcon: SolarIconsBold.usersGroupRounded,
  ),
];

class _ShellMenuDestination {
  const _ShellMenuDestination({
    required this.label,
    required this.icon,
    required this.selectedIcon,
  });

  final String label;
  final IconData icon;
  final IconData selectedIcon;
}

class _ShellTopMenuBar extends StatelessWidget {
  const _ShellTopMenuBar({
    required this.destinations,
    required this.selectedIndex,
    required this.onDestinationSelected,
  });

  final List<_ShellMenuDestination> destinations;
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 46,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: _surfaceColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _surfaceBorderColor),
      ),
      clipBehavior: Clip.hardEdge,
      child: Row(
        children: [
          for (var index = 0; index < destinations.length; index++) ...[
            Expanded(
              child: _ShellTopMenuItem(
                destination: destinations[index],
                selected: index == selectedIndex,
                onPressed: () => onDestinationSelected(index),
              ),
            ),
            if (index != destinations.length - 1) const SizedBox(width: 4),
          ],
        ],
      ),
    );
  }
}

class _ShellTopMenuItem extends StatelessWidget {
  const _ShellTopMenuItem({
    required this.destination,
    required this.selected,
    required this.onPressed,
  });

  final _ShellMenuDestination destination;
  final bool selected;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final foregroundColor = selected ? _surfaceColor : const Color(0xFF334155);
    final backgroundColor = selected ? _primaryColor : Colors.transparent;
    final icon = selected ? destination.selectedIcon : destination.icon;

    return Semantics(
      button: true,
      selected: selected,
      label: destination.label,
      child: Tooltip(
        message: destination.label,
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          child: InkWell(
            key: ValueKey('shell-menu-${destination.label}'),
            borderRadius: BorderRadius.circular(10),
            hoverColor: _softMintColor.withValues(alpha: 0.75),
            onTap: onPressed,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 160),
              curve: Curves.easeOutCubic,
              constraints: const BoxConstraints(minHeight: 38),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: selected ? _primaryPressedColor : Colors.transparent,
                ),
                boxShadow: selected
                    ? const [
                        BoxShadow(
                          color: Color(0x240F766E),
                          blurRadius: 16,
                          spreadRadius: -4,
                          offset: Offset(0, 8),
                        ),
                      ]
                    : null,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(icon, size: 18, color: foregroundColor),
                  const SizedBox(width: 6),
                  Flexible(
                    child: Text(
                      destination.label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: foregroundColor,
                        fontWeight: selected
                            ? FontWeight.w800
                            : FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ShellAccountSummary extends StatelessWidget {
  const _ShellAccountSummary({required this.profile, required this.shop});

  final User profile;
  final Shop shop;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 260),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(SolarIconsOutline.shop, size: 18),
          const SizedBox(width: 8),
          Flexible(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  shop.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(
                    context,
                  ).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w700),
                ),
                Text(
                  profile.fullName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
