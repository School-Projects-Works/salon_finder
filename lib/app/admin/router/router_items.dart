class RouterItem {
  final String path;
  final String name;
  RouterItem({
    required this.path,
    required this.name,
  });

  static final RouterItem loginRoute =
      RouterItem(path: '/login', name: 'login');
     
  static final RouterItem dashboardRoute =
      RouterItem(path: '/dashboard', name: 'dashboard');
  static final RouterItem salonsRoute =
      RouterItem(path: '/salons', name: 'salons');
  static final RouterItem usersRoute =
      RouterItem(path: '/users', name: 'users');
  static final RouterItem appointmentsRoute =
      RouterItem(path: '/appointments', name: 'appointments');
  static RouterItem transactionsRoute =
      RouterItem(path: '/transactions', name: 'transactions');
static List<RouterItem> allRoutes = [
    loginRoute,
    dashboardRoute,
    salonsRoute,
    usersRoute,
    appointmentsRoute,
    transactionsRoute,
  ];

  static RouterItem getRouteByPath(String fullPath) {
    return allRoutes.firstWhere((element) => element.path == fullPath);
  }
}
