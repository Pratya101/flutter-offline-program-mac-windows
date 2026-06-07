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

void _showToast(BuildContext context, String message) {
  final overlay = Overlay.maybeOf(context, rootOverlay: true);
  if (overlay == null) {
    final messenger = ScaffoldMessenger.maybeOf(context);
    messenger?.clearSnackBars();
    messenger?.showSnackBar(SnackBar(content: Text(message)));
    return;
  }

  _activeToastTimer?.cancel();
  _activeToastEntry?.remove();

  late final OverlayEntry entry;
  entry = OverlayEntry(
    builder: (context) {
      final media = MediaQuery.of(context);
      final maxWidth = (media.size.width - 48).clamp(280.0, 420.0).toDouble();

      return Positioned(
        top: media.padding.top + 18,
        right: 24,
        child: IgnorePointer(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxWidth),
            child: _ToastMessage(message: message),
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
  const _ToastMessage({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: DecoratedBox(
        decoration: _surfaceDecoration(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DecoratedBox(
                decoration: BoxDecoration(
                  color: _softMintColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Padding(
                  padding: EdgeInsets.all(6),
                  child: Icon(
                    SolarIconsOutline.infoSquare,
                    color: _primaryColor,
                    size: 18,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Flexible(
                child: Text(
                  message,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: const Color(0xFF0F172A),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
