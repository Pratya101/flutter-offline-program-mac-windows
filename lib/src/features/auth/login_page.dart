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
  final _fullNameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _phoneController = TextEditingController();

  var _createMode = false;
  var _submitting = false;
  var _passwordVisible = false;

  @override
  void dispose() {
    _fullNameController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    setState(() => _submitting = true);
    try {
      final user = _createMode
          ? await widget.authService.register(
              fullName: _fullNameController.text,
              username: _usernameController.text,
              password: _passwordController.text,
              phone: _phoneController.text,
            )
          : await widget.authService.login(
              username: _usernameController.text,
              password: _passwordController.text,
            );

      widget.onAuthenticated(user);
    } on AuthException catch (error) {
      _showMessage(error.message);
    } catch (_) {
      _showMessage('ไม่สามารถทำรายการได้');
    } finally {
      if (mounted) {
        setState(() => _submitting = false);
      }
    }
  }

  void _toggleMode() {
    setState(() {
      _createMode = !_createMode;
      _fullNameController.clear();
      _passwordController.clear();
      _phoneController.clear();
    });
  }

  void _showMessage(String message) {
    if (!mounted) {
      return;
    }
    _showToast(context, message);
  }

  String? _required(String? value) {
    if ((value ?? '').trim().isEmpty) {
      return 'จำเป็นต้องกรอก';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final title = _createMode ? 'สร้างผู้ใช้' : 'เข้าสู่ระบบ';
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 460),
              child: DecoratedBox(
                decoration: _surfaceDecoration(),
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          title,
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        const SizedBox(height: 22),
                        if (_createMode) ...[
                          TextFormField(
                            controller: _fullNameController,
                            textInputAction: TextInputAction.next,
                            validator: _required,
                            decoration: const InputDecoration(
                              labelText: 'ชื่อ-นามสกุล',
                              prefixIcon: Icon(SolarIconsOutline.userId),
                            ),
                          ),
                          const SizedBox(height: 12),
                        ],
                        TextFormField(
                          controller: _usernameController,
                          textInputAction: TextInputAction.next,
                          validator: _required,
                          decoration: const InputDecoration(
                            labelText: 'ชื่อผู้ใช้',
                            prefixIcon: Icon(SolarIconsOutline.userRounded),
                          ),
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _passwordController,
                          obscureText: !_passwordVisible,
                          textInputAction: _createMode
                              ? TextInputAction.next
                              : TextInputAction.done,
                          onFieldSubmitted: (_) =>
                              _createMode ? null : _submit(),
                          validator: _required,
                          decoration: InputDecoration(
                            labelText: 'รหัสผ่าน',
                            prefixIcon: const Icon(
                              SolarIconsOutline.lockKeyhole,
                            ),
                            suffixIcon: IconButton(
                              tooltip: _passwordVisible
                                  ? 'ซ่อนรหัสผ่าน'
                                  : 'แสดงรหัสผ่าน',
                              onPressed: () {
                                setState(
                                  () => _passwordVisible = !_passwordVisible,
                                );
                              },
                              icon: Icon(
                                _passwordVisible
                                    ? SolarIconsOutline.eyeClosed
                                    : SolarIconsOutline.eye,
                              ),
                            ),
                          ),
                        ),
                        if (_createMode) ...[
                          const SizedBox(height: 12),
                          TextFormField(
                            controller: _phoneController,
                            textInputAction: TextInputAction.done,
                            onFieldSubmitted: (_) => _submit(),
                            decoration: const InputDecoration(
                              labelText: 'เบอร์โทร',
                              prefixIcon: Icon(SolarIconsOutline.phone),
                            ),
                          ),
                        ],
                        const SizedBox(height: 20),
                        FilledButton.icon(
                          onPressed: _submitting ? null : _submit,
                          icon: _submitting
                              ? const SizedBox.square(
                                  dimension: 18,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                              : Icon(
                                  _createMode
                                      ? SolarIconsOutline.userPlusRounded
                                      : SolarIconsOutline.login,
                                ),
                          label: Text(
                            _createMode
                                ? 'สร้างบัญชีและเข้าสู่ระบบ'
                                : 'เข้าสู่ระบบ',
                          ),
                        ),
                        const SizedBox(height: 10),
                        TextButton(
                          onPressed: _submitting ? null : _toggleMode,
                          child: Text(
                            _createMode
                                ? 'กลับไปหน้าเข้าสู่ระบบ'
                                : 'สร้างผู้ใช้แรก',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
