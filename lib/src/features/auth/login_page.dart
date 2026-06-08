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
  final _shopNameController = TextEditingController();
  final _shopDescriptionController = TextEditingController();
  final _shopPhoneController = TextEditingController();
  final _shopTaxIdController = TextEditingController();
  final _shopAddressController = TextEditingController();

  var _createMode = false;
  var _submitting = false;
  var _passwordVisible = false;

  @override
  void dispose() {
    _fullNameController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    _shopNameController.dispose();
    _shopDescriptionController.dispose();
    _shopPhoneController.dispose();
    _shopTaxIdController.dispose();
    _shopAddressController.dispose();
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
              shopName: _shopNameController.text,
              shopDescription: _shopDescriptionController.text,
              shopPhone: _shopPhoneController.text,
              shopTaxId: _shopTaxIdController.text,
              shopAddress: _shopAddressController.text,
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
      _shopNameController.clear();
      _shopDescriptionController.clear();
      _shopPhoneController.clear();
      _shopTaxIdController.clear();
      _shopAddressController.clear();
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
                            textInputAction: TextInputAction.next,
                            decoration: const InputDecoration(
                              labelText: 'เบอร์โทร',
                              prefixIcon: Icon(SolarIconsOutline.phone),
                            ),
                          ),
                          const SizedBox(height: 18),
                          Text(
                            'ข้อมูลร้าน',
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(height: 12),
                          TextFormField(
                            controller: _shopNameController,
                            textInputAction: TextInputAction.next,
                            validator: _required,
                            decoration: const InputDecoration(
                              labelText: 'ชื่อร้าน',
                              prefixIcon: Icon(SolarIconsOutline.shop),
                            ),
                          ),
                          const SizedBox(height: 12),
                          TextFormField(
                            controller: _shopDescriptionController,
                            textInputAction: TextInputAction.next,
                            maxLines: 2,
                            decoration: const InputDecoration(
                              labelText: 'คำอธิบายร้านบนเอกสาร',
                              prefixIcon: Icon(SolarIconsOutline.documentText),
                            ),
                          ),
                          const SizedBox(height: 12),
                          TextFormField(
                            controller: _shopPhoneController,
                            textInputAction: TextInputAction.next,
                            decoration: const InputDecoration(
                              labelText: 'เบอร์โทรร้าน',
                              prefixIcon: Icon(SolarIconsOutline.phoneCalling),
                            ),
                          ),
                          const SizedBox(height: 12),
                          TextFormField(
                            controller: _shopTaxIdController,
                            textInputAction: TextInputAction.next,
                            decoration: const InputDecoration(
                              labelText: 'เลขประจำตัวผู้เสียภาษี',
                              prefixIcon: Icon(SolarIconsOutline.documentText),
                            ),
                          ),
                          const SizedBox(height: 12),
                          TextFormField(
                            controller: _shopAddressController,
                            textInputAction: TextInputAction.done,
                            onFieldSubmitted: (_) => _submit(),
                            maxLines: 2,
                            decoration: const InputDecoration(
                              labelText: 'ที่อยู่ร้าน',
                              prefixIcon: Icon(SolarIconsOutline.mapPoint),
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
