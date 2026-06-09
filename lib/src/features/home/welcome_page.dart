part of '../../../main.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({
    super.key,
    required this.profile,
    required this.shop,
    required this.authService,
    required this.onProfileChanged,
    required this.onShopChanged,
  });

  final User profile;
  final Shop shop;
  final AuthService authService;
  final Future<void> Function() onProfileChanged;
  final Future<void> Function() onShopChanged;

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  var _refreshing = false;

  Future<void> _refreshProfile() async {
    setState(() => _refreshing = true);
    try {
      await widget.onProfileChanged();
      if (mounted) {
        _showToast(context, 'โหลดข้อมูลล่าสุดแล้ว');
      }
    } finally {
      if (mounted) {
        setState(() => _refreshing = false);
      }
    }
  }

  Future<void> _openShopForm() async {
    final saved = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) =>
          _ShopFormDialog(authService: widget.authService, shop: widget.shop),
    );

    if (saved != true) {
      return;
    }
    await widget.onShopChanged();
    if (mounted) {
      _showToast(context, 'อัปเดตข้อมูลร้านแล้ว');
    }
  }

  @override
  Widget build(BuildContext context) {
    final profile = widget.profile;
    final shop = widget.shop;
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Text(
            'ยินดีต้อนรับ, ${profile.fullName}',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 18),
          LayoutBuilder(
            builder: (context, constraints) {
              final profileCard = _ProfileCard(
                profile: profile,
                refreshing: _refreshing,
                onRefresh: _refreshProfile,
              );
              final shopCard = _ShopCard(shop: shop, onEdit: _openShopForm);

              if (constraints.maxWidth < 860) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [profileCard, const SizedBox(height: 14), shopCard],
                );
              }

              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: profileCard),
                  const SizedBox(width: 14),
                  Expanded(child: shopCard),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class ShopSettingsPage extends StatefulWidget {
  const ShopSettingsPage({
    super.key,
    required this.shop,
    required this.authService,
    required this.onShopChanged,
  });

  final Shop shop;
  final AuthService authService;
  final Future<void> Function() onShopChanged;

  @override
  State<ShopSettingsPage> createState() => _ShopSettingsPageState();
}

class _ShopSettingsPageState extends State<ShopSettingsPage> {
  Future<void> _openShopForm() async {
    final saved = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) =>
          _ShopFormDialog(authService: widget.authService, shop: widget.shop),
    );

    if (saved != true) {
      return;
    }
    await widget.onShopChanged();
    if (mounted) {
      _showToast(context, 'อัปเดตข้อมูลร้านแล้ว');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 720),
            child: _ShopCard(shop: widget.shop, onEdit: _openShopForm),
          ),
        ],
      ),
    );
  }
}

class _ProfileCard extends StatelessWidget {
  const _ProfileCard({
    required this.profile,
    required this.refreshing,
    required this.onRefresh,
  });

  final User profile;
  final bool refreshing;
  final VoidCallback onRefresh;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: _surfaceDecoration(),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'โปรไฟล์',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                FilledButton.icon(
                  onPressed: refreshing ? null : onRefresh,
                  icon: refreshing
                      ? const SizedBox.square(
                          dimension: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(SolarIconsOutline.refresh),
                  label: const Text('โหลดข้อมูล'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _ProfileRow(label: 'ชื่อ-นามสกุล', value: profile.fullName),
            _ProfileRow(label: 'ชื่อผู้ใช้', value: profile.username),
            _ProfileRow(label: 'เบอร์โทร', value: _displayText(profile.phone)),
            _ProfileRow(label: 'รหัสผู้ใช้', value: profile.id),
          ],
        ),
      ),
    );
  }
}

class _ShopCard extends StatelessWidget {
  const _ShopCard({required this.shop, required this.onEdit});

  final Shop shop;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: _surfaceDecoration(),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(SolarIconsOutline.shop, color: _primaryColor),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'ข้อมูลร้าน',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                FilledButton.icon(
                  onPressed: onEdit,
                  icon: const Icon(SolarIconsOutline.pen),
                  label: const Text('แก้ไขร้าน'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _ProfileRow(label: 'ชื่อร้าน', value: shop.name),
            _ProfileRow(
              label: 'คำอธิบายเอกสาร',
              value: _displayText(shop.description),
            ),
            _ProfileRow(label: 'เบอร์โทรร้าน', value: _displayText(shop.phone)),
            _ProfileRow(label: 'เลขภาษี', value: _displayText(shop.taxId)),
            _ProfileRow(
              label: 'ที่อยู่ร้าน',
              value: _displayText(shop.address),
            ),
          ],
        ),
      ),
    );
  }
}

class _ShopFormDialog extends StatefulWidget {
  const _ShopFormDialog({required this.authService, required this.shop});

  final AuthService authService;
  final Shop shop;

  @override
  State<_ShopFormDialog> createState() => _ShopFormDialogState();
}

class _ShopFormDialogState extends State<_ShopFormDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _phoneController = TextEditingController();
  final _taxIdController = TextEditingController();
  final _addressController = TextEditingController();

  var _saving = false;

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.shop.name;
    _descriptionController.text = widget.shop.description ?? '';
    _phoneController.text = widget.shop.phone ?? '';
    _taxIdController.text = widget.shop.taxId ?? '';
    _addressController.text = widget.shop.address ?? '';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _phoneController.dispose();
    _taxIdController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    setState(() => _saving = true);
    try {
      await widget.authService.updatePrimaryShop(
        name: _nameController.text,
        description: _descriptionController.text,
        phone: _phoneController.text,
        taxId: _taxIdController.text,
        address: _addressController.text,
      );
      if (mounted) {
        Navigator.pop(context, true);
      }
    } on AuthException catch (error) {
      if (mounted) {
        _showToast(context, error.message, type: _ToastType.warning);
      }
    } catch (_) {
      if (mounted) {
        _showToast(
          context,
          'ไม่สามารถบันทึกข้อมูลร้านได้',
          type: _ToastType.error,
        );
      }
    } finally {
      if (mounted) {
        setState(() => _saving = false);
      }
    }
  }

  String? _required(String? value) {
    if ((value ?? '').trim().isEmpty) {
      return 'จำเป็นต้องกรอก';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: _surfaceColor,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: _cardBorderRadius()),
      title: const Text('แก้ไขข้อมูลร้าน'),
      content: SizedBox(
        width: 460,
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _nameController,
                  textInputAction: TextInputAction.next,
                  validator: _required,
                  decoration: const InputDecoration(
                    labelText: 'ชื่อร้าน',
                    prefixIcon: Icon(SolarIconsOutline.shop),
                  ),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _descriptionController,
                  textInputAction: TextInputAction.next,
                  maxLines: 2,
                  decoration: const InputDecoration(
                    labelText: 'คำอธิบายร้านบนเอกสาร',
                    prefixIcon: Icon(SolarIconsOutline.documentText),
                  ),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _phoneController,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    labelText: 'เบอร์โทรร้าน',
                    prefixIcon: Icon(SolarIconsOutline.phoneCalling),
                  ),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _taxIdController,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    labelText: 'เลขประจำตัวผู้เสียภาษี',
                    prefixIcon: Icon(SolarIconsOutline.documentText),
                  ),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _addressController,
                  textInputAction: TextInputAction.done,
                  onFieldSubmitted: (_) => _save(),
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: 'ที่อยู่ร้าน',
                    prefixIcon: Icon(SolarIconsOutline.mapPoint),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _saving ? null : () => Navigator.pop(context, false),
          child: const Text('ยกเลิก'),
        ),
        FilledButton.icon(
          onPressed: _saving ? null : _save,
          icon: _saving
              ? const SizedBox.square(
                  dimension: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Icon(SolarIconsOutline.diskette),
          label: const Text('บันทึกข้อมูลร้าน'),
        ),
      ],
    );
  }
}

class _ProfileRow extends StatelessWidget {
  const _ProfileRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(label, style: Theme.of(context).textTheme.labelLarge),
          ),
          Expanded(child: SelectableText(value)),
        ],
      ),
    );
  }
}
