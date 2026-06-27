import 'package:flutter/material.dart';
import 'package:sistema_andreas/utils/app_colors.dart';
import 'package:sistema_andreas/widgets/order_drawer.dart';

class AppScaffold extends StatelessWidget {
  const AppScaffold({
    super.key,
    required this.body,
    required this.appBar,
  });

  final Widget body;
  final PreferredSizeWidget appBar;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const OrderDrawer(),
      appBar: appBar,
      body: body,
    );
  }
}

PreferredSizeWidget buildAppBar({
  required BuildContext context,
  required String title,
  required String subtitle,
}) {
  final textTheme = Theme.of(context).textTheme;

  return AppBar(
    title: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w700,
            color: AppColors.textOnDark,
          ),
        ),
        Text(
          subtitle,
          style: textTheme.bodyMedium?.copyWith(
            color: AppColors.accent,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    ),
    toolbarHeight: 72,
  );
}
