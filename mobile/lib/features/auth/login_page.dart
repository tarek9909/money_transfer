import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/providers.dart';
import '../../core/theme.dart';
import '../../core/widgets/luxury_card.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});
  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final email = TextEditingController();
  final password = TextEditingController();
  bool obscurePassword = true;

  @override
  void dispose() {
    email.dispose();
    password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Ambient luxury background glow
          Positioned(
            top: -100,
            right: -80,
            child: Container(
              width: 320,
              height: 320,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppColors.mint.withValues(alpha: 0.18),
                    AppColors.mint.withValues(alpha: 0.0),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: -60,
            left: -60,
            child: Container(
              width: 260,
              height: 260,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppColors.indigo.withValues(alpha: 0.12),
                    AppColors.indigo.withValues(alpha: 0.0),
                  ],
                ),
              ),
            ),
          ),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 420),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _brandMark(),
                      const SizedBox(height: 32),
                      Text(
                        'Welcome Back',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 28,
                          fontWeight: FontWeight.w800,
                          color: AppColors.midnight,
                          letterSpacing: -0.8,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'A calmer, clearer way to command your money.',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 14,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Form card
                      LuxuryCard(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            TextField(
                              controller: email,
                              keyboardType: TextInputType.emailAddress,
                              textInputAction: TextInputAction.next,
                              decoration: const InputDecoration(
                                labelText: 'Email address',
                                prefixIcon: Icon(Icons.mail_outline_rounded),
                              ),
                            ),
                            const SizedBox(height: 14),
                            TextField(
                              controller: password,
                              obscureText: obscurePassword,
                              onSubmitted: (_) => _login(),
                              decoration: InputDecoration(
                                labelText: 'Password',
                                prefixIcon: const Icon(Icons.lock_outline_rounded),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    obscurePassword
                                        ? Icons.visibility_off_outlined
                                        : Icons.visibility_outlined,
                                    size: 20,
                                  ),
                                  onPressed: () => setState(
                                    () => obscurePassword = !obscurePassword,
                                  ),
                                ),
                              ),
                            ),
                            if (auth.hasError)
                              Padding(
                                padding: const EdgeInsets.only(top: 12),
                                child: Text(
                                  auth.error.toString(),
                                  style: GoogleFonts.plusJakartaSans(
                                    color: AppColors.crimson,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            const SizedBox(height: 24),
                            FilledButton(
                              style: FilledButton.styleFrom(
                                backgroundColor: AppColors.midnight,
                                minimumSize: const Size.fromHeight(54),
                                elevation: 4,
                                shadowColor: AppColors.midnight.withValues(alpha: 0.3),
                              ),
                              onPressed: auth.isLoading ? null : _login,
                              child: auth.isLoading
                                  ? const SizedBox.square(
                                      dimension: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Colors.white,
                                      ),
                                    )
                                  : Text(
                                      'Continue Securely',
                                      style: GoogleFonts.plusJakartaSans(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextButton(
                        onPressed: () => context.go('/register'),
                        child: Text(
                          "Don't have an account? Sign up",
                          style: GoogleFonts.plusJakartaSans(
                            color: AppColors.midnight,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Wrap(
                        alignment: WrapAlignment.center,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        spacing: 6,
                        runSpacing: 4,
                        children: [
                          const Icon(
                            Icons.shield_outlined,
                            size: 16,
                            color: AppColors.emerald,
                          ),
                          Text(
                            'AES-256 Encrypted Local Tokens',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      _serverConnectionBar(context),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _brandMark() => Row(
    children: [
      Container(
        width: 52,
        height: 52,
        decoration: BoxDecoration(
          gradient: AppGradients.luxuryDark,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: AppColors.midnight.withValues(alpha: 0.25),
              blurRadius: 14,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: const Icon(
          Icons.auto_graph_rounded,
          color: AppColors.mint,
          size: 26,
        ),
      ),
      const SizedBox(width: 14),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Money Tracker',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: AppColors.midnight,
                letterSpacing: -0.4,
              ),
            ),
            Text(
              'Personal Finance Intelligence',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 11,
                color: AppColors.emerald,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.4,
              ),
            ),
          ],
        ),
      ),
    ],
  );

  Widget _serverConnectionBar(BuildContext context) {
    final client = ref.watch(apiClientProvider);
    final displayUrl = client.currentBaseUrl
        .replaceAll('/api/v1', '')
        .replaceAll('http://', '')
        .replaceAll('https://', '');

    return InkWell(
      onTap: () => _showServerDialog(context),
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                color: AppColors.emerald,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 7),
            Flexible(
              child: Text(
                'Server: $displayUrl',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(width: 4),
            const Icon(
              Icons.tune_rounded,
              size: 14,
              color: AppColors.textTertiary,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showServerDialog(BuildContext context) async {
    await showDialog<void>(
      context: context,
      builder: (_) => const _ServerSettingsDialog(),
    );
  }

  Future<void> _login() async {
    await ref
        .read(authProvider.notifier)
        .login(email.text.trim(), password.text);
  }
}

class _ServerSettingsDialog extends ConsumerStatefulWidget {
  const _ServerSettingsDialog();

  @override
  ConsumerState<_ServerSettingsDialog> createState() =>
      _ServerSettingsDialogState();
}

class _ServerSettingsDialogState extends ConsumerState<_ServerSettingsDialog> {
  late final TextEditingController _controller;
  String? _testResult;
  bool _isTesting = false;

  @override
  void initState() {
    super.initState();
    final client = ref.read(apiClientProvider);
    _controller = TextEditingController(text: client.currentBaseUrl);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final client = ref.read(apiClientProvider);

    return AlertDialog(
      title: Text(
        'Backend Server',
        style: GoogleFonts.plusJakartaSans(
          fontSize: 18,
          fontWeight: FontWeight.w800,
        ),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Specify the API endpoint address for the Personal Money Tracker backend.',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 14),
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                labelText: 'API Base URL',
                hintText: 'https://moneytrackerrrrrrrrrrrr.duckdns.org/api/v1',
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Quick Presets:',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 6),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: [
                ActionChip(
                  avatar: const Icon(Icons.cloud_done_rounded, size: 16),
                  label: const Text('Cloud (Online)'),
                  onPressed: () => setState(
                    () => _controller.text =
                        'https://moneytrackerrrrrrrrrrrr.duckdns.org/api/v1',
                  ),
                ),
                ActionChip(
                  label: const Text('Wi-Fi (192.168.10.127)'),
                  onPressed: () => setState(
                    () => _controller.text =
                        'http://192.168.10.127:4050/api/v1',
                  ),
                ),
                ActionChip(
                  label: const Text('ADB Reverse (127.0.0.1)'),
                  onPressed: () => setState(
                    () => _controller.text =
                        'http://127.0.0.1:4050/api/v1',
                  ),
                ),
                ActionChip(
                  label: const Text('Emulator (10.0.2.2)'),
                  onPressed: () => setState(
                    () => _controller.text =
                        'http://10.0.2.2:4050/api/v1',
                  ),
                ),
              ],
            ),
            if (_testResult != null) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: _testResult!.contains('Success')
                      ? AppColors.mintSoft
                      : AppColors.crimsonSoft,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  _testResult!,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: _testResult!.contains('Success')
                        ? AppColors.emerald
                        : AppColors.crimson,
                  ),
                ),
              ),
            ],
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: _isTesting
                  ? null
                  : () async {
                      setState(() {
                        _isTesting = true;
                        _testResult = null;
                      });
                      final ok = await client.testConnection(_controller.text.trim());
                      if (mounted) {
                        setState(() {
                          _isTesting = false;
                          _testResult = ok
                              ? '✓ Successfully connected to backend!'
                              : '✗ Cannot reach server at this address';
                        });
                      }
                    },
              icon: _isTesting
                  ? const SizedBox.square(
                      dimension: 14,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.network_check_rounded, size: 16),
              label: const Text('Test Connection'),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () async {
            final newUrl = _controller.text.trim();
            if (newUrl.isNotEmpty) {
              await client.saveBaseUrl(newUrl);
            }
            if (context.mounted) Navigator.pop(context);
          },
          child: const Text('Save & Connect'),
        ),
      ],
    );
  }
}
