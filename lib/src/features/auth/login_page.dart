part of '../../../main.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({
    super.key,
    required this.authService,
    required this.onAuthenticated,
  });

  final AuthService authService;
  final ValueChanged<User> onAuthenticated;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController(
    text: AuthService.defaultAdminUsername,
  );
  final _passwordController = TextEditingController();

  var _submitting = false;
  var _passwordVisible = false;

  @override
  void initState() {
    super.initState();
    unawaited(_prepareDefaultAdminUser());
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _prepareDefaultAdminUser() async {
    try {
      await widget.authService.ensureDefaultAdminUser();
    } catch (_) {
      _showMessage('ไม่สามารถเตรียมผู้ใช้เริ่มต้นได้', type: _ToastType.error);
    }
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    setState(() => _submitting = true);
    try {
      final user = await widget.authService.login(
        username: _usernameController.text,
        password: _passwordController.text,
      );

      widget.onAuthenticated(user);
    } on AuthException catch (error) {
      _showMessage(error.message, type: _ToastType.warning);
    } catch (_) {
      _showMessage('ไม่สามารถทำรายการได้', type: _ToastType.error);
    } finally {
      if (mounted) {
        setState(() => _submitting = false);
      }
    }
  }

  void _showMessage(String message, {_ToastType type = _ToastType.success}) {
    if (!mounted) {
      return;
    }
    _showToast(context, message, type: type);
  }

  String? _required(String? value) {
    if ((value ?? '').trim().isEmpty) {
      return 'จำเป็นต้องกรอก';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final compact = constraints.maxWidth < 860;
            return Center(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: compact ? 20 : 36,
                  vertical: 28,
                ),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: compact ? 480 : 1040,
                    minHeight: compact ? 0 : 560,
                  ),
                  child: DecoratedBox(
                    decoration: _surfaceDecoration(),
                    child: ClipRRect(
                      borderRadius: _cardBorderRadius(),
                      child: compact
                          ? Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const _LoginBrandPanel(compact: true),
                                _LoginFormPanel(
                                  compact: true,
                                  formKey: _formKey,
                                  usernameController: _usernameController,
                                  passwordController: _passwordController,
                                  passwordVisible: _passwordVisible,
                                  submitting: _submitting,
                                  onTogglePassword: () {
                                    setState(
                                      () =>
                                          _passwordVisible = !_passwordVisible,
                                    );
                                  },
                                  onSubmit: _submit,
                                  requiredValidator: _required,
                                ),
                              ],
                            )
                          : IntrinsicHeight(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  const Expanded(
                                    child: _LoginBrandPanel(compact: false),
                                  ),
                                  SizedBox(
                                    width: 440,
                                    child: _LoginFormPanel(
                                      compact: false,
                                      formKey: _formKey,
                                      usernameController: _usernameController,
                                      passwordController: _passwordController,
                                      passwordVisible: _passwordVisible,
                                      submitting: _submitting,
                                      onTogglePassword: () {
                                        setState(
                                          () => _passwordVisible =
                                              !_passwordVisible,
                                        );
                                      },
                                      onSubmit: _submit,
                                      requiredValidator: _required,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _LoginBrandPanel extends StatelessWidget {
  const _LoginBrandPanel({required this.compact});

  final bool compact;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF0F766E), Color(0xFF1D4ED8)],
        ),
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          compact ? 22 : 34,
          compact ? 22 : 34,
          compact ? 22 : 34,
          compact ? 22 : 32,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: compact ? MainAxisSize.min : MainAxisSize.max,
          children: [
            Row(
              children: [
                const _LoginLogoMark(),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'SoftSale Offline',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: textTheme.titleLarge?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      Text(
                        'Desktop POS',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: textTheme.labelLarge?.copyWith(
                          color: Colors.white.withValues(alpha: 0.72),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: compact ? 26 : 56),
            Text(
              'ระบบขายออฟไลน์',
              style: textTheme.displaySmall?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w900,
                height: 1.08,
              ),
            ),
            const SizedBox(height: 12),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Text(
                'เข้าสู่ระบบเพื่อเริ่มงานขายและข้อมูลร้านบนเครื่องนี้',
                style: textTheme.titleMedium?.copyWith(
                  color: Colors.white.withValues(alpha: 0.82),
                  height: 1.45,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            if (!compact) const Spacer(),
            SizedBox(height: compact ? 24 : 42),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: const [
                _LoginStatusTile(
                  icon: SolarIconsOutline.userRounded,
                  label: 'บัญชีเริ่มต้น',
                  value: AuthService.defaultAdminUsername,
                  accentColor: Color(0xFFF59E0B),
                ),
                _LoginStatusTile(
                  icon: SolarIconsOutline.database,
                  label: 'ฐานข้อมูล',
                  value: 'Local',
                  accentColor: Color(0xFF38BDF8),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _LoginLogoMark extends StatelessWidget {
  const _LoginLogoMark();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withValues(alpha: 0.22)),
      ),
      child: const SizedBox.square(
        dimension: 58,
        child: Icon(SolarIconsOutline.shop, color: Colors.white, size: 30),
      ),
    );
  }
}

class _LoginStatusTile extends StatelessWidget {
  const _LoginStatusTile({
    required this.icon,
    required this.label,
    required this.value,
    required this.accentColor,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.13),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white.withValues(alpha: 0.18)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            DecoratedBox(
              decoration: BoxDecoration(
                color: accentColor.withValues(alpha: 0.22),
                borderRadius: BorderRadius.circular(7),
              ),
              child: Padding(
                padding: const EdgeInsets.all(7),
                child: Icon(icon, color: Colors.white, size: 18),
              ),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  label,
                  style: textTheme.labelSmall?.copyWith(
                    color: Colors.white.withValues(alpha: 0.68),
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  value,
                  style: textTheme.titleSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _LoginFormPanel extends StatelessWidget {
  const _LoginFormPanel({
    required this.compact,
    required this.formKey,
    required this.usernameController,
    required this.passwordController,
    required this.passwordVisible,
    required this.submitting,
    required this.onTogglePassword,
    required this.onSubmit,
    required this.requiredValidator,
  });

  final bool compact;
  final GlobalKey<FormState> formKey;
  final TextEditingController usernameController;
  final TextEditingController passwordController;
  final bool passwordVisible;
  final bool submitting;
  final VoidCallback onTogglePassword;
  final VoidCallback onSubmit;
  final FormFieldValidator<String> requiredValidator;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return ColoredBox(
      color: _surfaceColor,
      child: Padding(
        padding: EdgeInsets.all(compact ? 24 : 34),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: compact ? MainAxisSize.min : MainAxisSize.max,
            children: [
              Row(
                children: [
                  DecoratedBox(
                    decoration: BoxDecoration(
                      color: _softMintColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(9),
                      child: Icon(
                        SolarIconsOutline.lockKeyhole,
                        color: _primaryColor,
                        size: 22,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'เข้าสู่ระบบ',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: textTheme.headlineSmall?.copyWith(
                        color: const Color(0xFF0F172A),
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'ใช้บัญชีผู้ดูแลเริ่มต้นหรือบัญชีที่เพิ่มไว้ในระบบ',
                style: textTheme.bodyMedium?.copyWith(
                  color: const Color(0xFF64748B),
                  height: 1.42,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 26),
              TextFormField(
                controller: usernameController,
                textInputAction: TextInputAction.next,
                validator: requiredValidator,
                autofillHints: const [AutofillHints.username],
                decoration: const InputDecoration(
                  labelText: 'ชื่อผู้ใช้',
                  prefixIcon: Icon(SolarIconsOutline.userRounded),
                ),
              ),
              const SizedBox(height: 14),
              TextFormField(
                controller: passwordController,
                autofocus: true,
                obscureText: !passwordVisible,
                textInputAction: TextInputAction.done,
                onFieldSubmitted: (_) => onSubmit(),
                validator: requiredValidator,
                autofillHints: const [AutofillHints.password],
                decoration: InputDecoration(
                  labelText: 'รหัสผ่าน',
                  prefixIcon: const Icon(SolarIconsOutline.lockKeyhole),
                  suffixIcon: IconButton(
                    tooltip: passwordVisible ? 'ซ่อนรหัสผ่าน' : 'แสดงรหัสผ่าน',
                    onPressed: submitting ? null : onTogglePassword,
                    icon: Icon(
                      passwordVisible
                          ? SolarIconsOutline.eyeClosed
                          : SolarIconsOutline.eye,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              const _DefaultAdminHint(),
              const SizedBox(height: 22),
              FilledButton.icon(
                onPressed: submitting ? null : onSubmit,
                icon: submitting
                    ? const SizedBox.square(
                        dimension: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(SolarIconsOutline.login),
                label: const Text('เข้าสู่ระบบ'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DefaultAdminHint extends StatelessWidget {
  const _DefaultAdminHint();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: const Color(0xFFFFFBEB),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFFDE68A)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
        child: Row(
          children: [
            const Icon(
              SolarIconsOutline.shieldCheck,
              color: Color(0xFFD97706),
              size: 20,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                'บัญชีเริ่มต้น: ${AuthService.defaultAdminUsername}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: textTheme.bodyMedium?.copyWith(
                  color: const Color(0xFF92400E),
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
