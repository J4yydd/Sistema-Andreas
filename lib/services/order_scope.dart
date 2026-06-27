import 'package:flutter/material.dart';
import 'package:sistema_andreas/services/order_state.dart';

class OrderScope extends InheritedNotifier<OrderState> {
  const OrderScope({
    super.key,
    required OrderState super.notifier,
    required super.child,
  });

  static OrderState of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<OrderScope>();
    assert(scope != null, 'OrderScope not found in widget tree');
    return scope!.notifier!;
  }
}
