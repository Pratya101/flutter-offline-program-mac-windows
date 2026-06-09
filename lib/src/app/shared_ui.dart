part of '../../main.dart';

const _appBackgroundColor = Color(0xFFF5F7FA);
const _surfaceColor = Color(0xFFFFFFFF);
const _surfaceBorderColor = Color(0xFFD9E2EC);
const _primaryColor = Color(0xFF0F766E);
const _primaryPressedColor = Color(0xFF0B5F59);
const _softMintColor = Color(0xFFE6F4F1);
const _softSlateColor = Color(0xFFEFF3F7);
const _cardRadius = 14.0;

BorderRadius _cardBorderRadius() => BorderRadius.circular(_cardRadius);

BoxDecoration _surfaceDecoration() {
  return BoxDecoration(
    color: _surfaceColor,
    borderRadius: _cardBorderRadius(),
    border: Border.all(color: _surfaceBorderColor),
    boxShadow: const [
      BoxShadow(
        color: Color(0x120F172A),
        blurRadius: 28,
        spreadRadius: -4,
        offset: Offset(0, 16),
      ),
      BoxShadow(
        color: Color(0x080F172A),
        blurRadius: 8,
        spreadRadius: -2,
        offset: Offset(0, 4),
      ),
    ],
  );
}

OverlayEntry? _activeToastEntry;
Timer? _activeToastTimer;

enum _ToastType { success, warning, error }

class _ToastStyle {
  const _ToastStyle({
    required this.label,
    required this.icon,
    required this.backgroundColor,
    required this.borderColor,
    required this.accentColor,
    required this.iconBackgroundColor,
    required this.titleColor,
    required this.messageColor,
    required this.shadowColor,
  });

  final String label;
  final IconData icon;
  final Color backgroundColor;
  final Color borderColor;
  final Color accentColor;
  final Color iconBackgroundColor;
  final Color titleColor;
  final Color messageColor;
  final Color shadowColor;
}

_ToastStyle _toastStyleFor(_ToastType type) {
  return switch (type) {
    _ToastType.success => const _ToastStyle(
      label: 'สำเร็จ',
      icon: SolarIconsOutline.checkCircle,
      backgroundColor: Color(0xFFECFDF5),
      borderColor: Color(0xFF86EFAC),
      accentColor: Color(0xFF16A34A),
      iconBackgroundColor: Color(0xFFD1FAE5),
      titleColor: Color(0xFF065F46),
      messageColor: Color(0xFF064E3B),
      shadowColor: Color(0x3016A34A),
    ),
    _ToastType.warning => const _ToastStyle(
      label: 'แจ้งเตือน',
      icon: SolarIconsOutline.dangerTriangle,
      backgroundColor: Color(0xFFFFFBEB),
      borderColor: Color(0xFFF59E0B),
      accentColor: Color(0xFFD97706),
      iconBackgroundColor: Color(0xFFFEF3C7),
      titleColor: Color(0xFF92400E),
      messageColor: Color(0xFF78350F),
      shadowColor: Color(0x30D97706),
    ),
    _ToastType.error => const _ToastStyle(
      label: 'ไม่สำเร็จ',
      icon: SolarIconsOutline.closeCircle,
      backgroundColor: Color(0xFFFEF2F2),
      borderColor: Color(0xFFFCA5A5),
      accentColor: Color(0xFFDC2626),
      iconBackgroundColor: Color(0xFFFEE2E2),
      titleColor: Color(0xFF991B1B),
      messageColor: Color(0xFF7F1D1D),
      shadowColor: Color(0x30DC2626),
    ),
  };
}

void _showToast(
  BuildContext context,
  String message, {
  _ToastType type = _ToastType.success,
}) {
  final style = _toastStyleFor(type);
  final overlay = Overlay.maybeOf(context, rootOverlay: true);
  if (overlay == null) {
    final messenger = ScaffoldMessenger.maybeOf(context);
    messenger?.clearSnackBars();
    messenger?.showSnackBar(
      SnackBar(
        backgroundColor: style.accentColor,
        content: Text(
          message,
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
    );
    return;
  }

  _activeToastTimer?.cancel();
  _activeToastEntry?.remove();

  late final OverlayEntry entry;
  entry = OverlayEntry(
    builder: (context) {
      final media = MediaQuery.of(context);
      final maxWidth = (media.size.width - 48).clamp(0.0, 420.0).toDouble();

      return Positioned(
        top: media.padding.top + 18,
        right: 24,
        child: IgnorePointer(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxWidth),
            child: _ToastMessage(message: message, type: type),
          ),
        ),
      );
    },
  );

  _activeToastEntry = entry;
  overlay.insert(entry);
  _activeToastTimer = Timer(const Duration(seconds: 3), () {
    if (_activeToastEntry == entry) {
      entry.remove();
      _activeToastEntry = null;
    }
  });
}

class _ToastMessage extends StatelessWidget {
  const _ToastMessage({required this.message, required this.type});

  final String message;
  final _ToastType type;

  @override
  Widget build(BuildContext context) {
    final style = _toastStyleFor(type);
    return Material(
      color: Colors.transparent,
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0, end: 1),
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOutCubic,
        builder: (context, value, child) {
          return Opacity(
            opacity: value,
            child: Transform.translate(
              offset: Offset(0, -10 * (1 - value)),
              child: child,
            ),
          );
        },
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: style.backgroundColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: style.borderColor, width: 1.2),
            boxShadow: [
              BoxShadow(
                color: style.shadowColor,
                blurRadius: 22,
                spreadRadius: -8,
                offset: const Offset(0, 14),
              ),
              const BoxShadow(
                color: Color(0x140F172A),
                blurRadius: 10,
                spreadRadius: -6,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: IntrinsicHeight(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(
                    width: 5,
                    child: ColoredBox(color: style.accentColor),
                  ),
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(12, 11, 14, 12),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          DecoratedBox(
                            decoration: BoxDecoration(
                              color: style.iconBackgroundColor,
                              borderRadius: BorderRadius.circular(9),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(6),
                              child: Icon(
                                style.icon,
                                color: style.accentColor,
                                size: 19,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Flexible(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  style.label,
                                  style: Theme.of(context).textTheme.labelMedium
                                      ?.copyWith(
                                        color: style.titleColor,
                                        fontWeight: FontWeight.w800,
                                      ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  message,
                                  style: Theme.of(context).textTheme.bodyMedium
                                      ?.copyWith(
                                        color: style.messageColor,
                                        fontWeight: FontWeight.w700,
                                        height: 1.28,
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ],
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
