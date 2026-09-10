import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../features/accounts/accounts_page.dart';
import '../features/auth/login_page.dart';
import '../features/auth/register_page.dart';
import '../features/home/home_page.dart';
import '../features/transactions/add_entry_page.dart';
import '../features/transactions/transactions_page.dart';
import '../features/static_expenses/static_expenses_page.dart';
import '../features/transfers/transfer_page.dart';
import '../features/transfers/transfer_history_page.dart';
import '../features/settings/settings_page.dart';
import 'providers.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final auth = ref.watch(authProvider);
  return GoRouter(
    initialLocation: '/',
    redirect: (context, state) {
      final loggedIn = auth.valueOrNull != null;
      final isAuth =
          state.matchedLocation == '/login' ||
          state.matchedLocation == '/register';
      if (auth.isLoading) return null;
      if (!loggedIn && !isAuth) return '/login';
      if (loggedIn && isAuth) return '/';
      return null;
    },
    routes: [
      GoRoute(path: '/login', builder: (_, __) => const LoginPage()),
      GoRoute(path: '/register', builder: (_, __) => const RegisterPage()),
      ShellRoute(
        builder: (_, __, child) => AppShell(child: child),
        routes: [
          GoRoute(path: '/', builder: (_, __) => const HomePage()),
          GoRoute(
            path: '/transactions',
            builder: (_, __) => const TransactionsPage(),
          ),
          GoRoute(path: '/accounts', builder: (_, __) => const AccountsPage()),
          GoRoute(path: '/settings', builder: (_, __) => const SettingsPage()),
          GoRoute(
            path: '/add',
            builder: (_, state) => AddEntryPage(
              type: state.uri.queryParameters['type'] ?? 'DYNAMIC_SPENDING',
              transactionId: state.uri.queryParameters['transactionId'],
            ),
          ),
          GoRoute(
            path: '/static-expenses',
            builder: (_, __) => const StaticExpensesPage(),
          ),
          GoRoute(path: '/transfer', builder: (_, __) => const TransferPage()),
          GoRoute(
            path: '/transfers',
            builder: (_, __) => const TransferHistoryPage(),
          ),
        ],
      ),
    ],
  );
});

class AppShell extends StatelessWidget {
  const AppShell({required this.child, super.key});
  final Widget child;
  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;
    final index = location.startsWith('/transactions')
        ? 1
        : location.startsWith('/accounts')
        ? 2
        : location.startsWith('/settings')
        ? 3
        : 0;
    return Scaffold(
      extendBody: true,
      body: child,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddMenu(context),
        icon: const Icon(Icons.add_rounded),
        label: const Text('Add'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.fromLTRB(12, 0, 12, 10),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: NavigationBar(
            selectedIndex: index,
            onDestinationSelected: (value) => context.go(
              ['/', '/transactions', '/accounts', '/settings'][value],
            ),
            destinations: const [
              NavigationDestination(
                icon: Icon(Icons.grid_view_outlined),
                selectedIcon: Icon(Icons.grid_view_rounded),
                label: 'Overview',
              ),
              NavigationDestination(
                icon: Icon(Icons.receipt_long_outlined),
                selectedIcon: Icon(Icons.receipt_long_rounded),
                label: 'Activity',
              ),
              NavigationDestination(
                icon: Icon(Icons.account_balance_wallet_outlined),
                selectedIcon: Icon(Icons.account_balance_wallet_rounded),
                label: 'Accounts',
              ),
              NavigationDestination(
                icon: Icon(Icons.tune_outlined),
                selectedIcon: Icon(Icons.tune_rounded),
                label: 'Settings',
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showAddMenu(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const ListTile(
              title: Text('Add'),
              subtitle: Text('Record a financial event'),
            ),
            _addTile(
              context,
              'Dynamic spending',
              Icons.shopping_cart_outlined,
              () => context.push('/add?type=DYNAMIC_SPENDING'),
            ),
            _addTile(
              context,
              'Main income',
              Icons.payments_outlined,
              () => context.push('/add?type=MAIN_INCOME'),
            ),
            _addTile(
              context,
              'Additional income',
              Icons.add_card_outlined,
              () => context.push('/add?type=ADDITIONAL_INCOME'),
            ),
            _addTile(
              context,
              'Static spending',
              Icons.event_repeat_outlined,
              () => context.push('/static-expenses'),
            ),
            _addTile(
              context,
              'Transfer',
              Icons.swap_horiz,
              () => context.push('/transfer'),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _addTile(
    BuildContext context,
    String title,
    IconData icon,
    VoidCallback onTap,
  ) => ListTile(
    leading: Icon(icon),
    title: Text(title),
    onTap: () {
      Navigator.pop(context);
      onTap();
    },
  );
}
