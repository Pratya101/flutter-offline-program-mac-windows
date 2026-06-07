part of '../../../main.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({
    super.key,
    required this.profile,
    required this.authService,
    required this.onProfileChanged,
  });

  final User profile;
  final AuthService authService;
  final Future<void> Function() onProfileChanged;

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
        _showToast(context, 'โหลดโปรไฟล์ล่าสุดแล้ว');
      }
    } finally {
      if (mounted) {
        setState(() => _refreshing = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final profile = widget.profile;
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Text(
            'ยินดีต้อนรับ, ${profile.fullName}',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 18),
          DecoratedBox(
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
                        onPressed: _refreshing ? null : _refreshProfile,
                        icon: _refreshing
                            ? const SizedBox.square(
                                dimension: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : const Icon(SolarIconsOutline.refresh),
                        label: const Text('โหลดโปรไฟล์'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _ProfileRow(label: 'ชื่อ-นามสกุล', value: profile.fullName),
                  _ProfileRow(label: 'ชื่อผู้ใช้', value: profile.username),
                  _ProfileRow(
                    label: 'เบอร์โทร',
                    value: (profile.phone ?? '').isEmpty ? '-' : profile.phone!,
                  ),
                  _ProfileRow(label: 'รหัสผู้ใช้', value: profile.id),
                ],
              ),
            ),
          ),
        ],
      ),
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
