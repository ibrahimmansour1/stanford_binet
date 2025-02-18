import 'dart:async';
import 'package:flutter/material.dart';

class ToastService {
  static OverlayEntry? _overlayEntry;
  static Timer? _toastTimer;

  static void show(BuildContext context, String message) {
    _overlayEntry?.remove();
    _toastTimer?.cancel();

    final overlay = Overlay.of(context);

    _overlayEntry = OverlayEntry(
      builder: (context) => TweenAnimationBuilder<double>(
        tween: Tween(begin: 0.0, end: 1.0),
        duration: const Duration(milliseconds: 200),
        builder: (context, value, child) {
          return Opacity(
            opacity: value,
            child: Positioned(
              left: 16,
              right: 16,
              bottom: 50 + (20 * (1 - value)),
              child: SafeArea(
                child: Material(
                  color: Colors.transparent,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black87,
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          offset: const Offset(0, 2),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                    child: Text(
                      message,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );

    overlay.insert(_overlayEntry!);

    _toastTimer = Timer(const Duration(seconds: 2), () {
      if (_overlayEntry?.mounted ?? false) {
        _overlayEntry?.remove();
        _overlayEntry = null;
      }
    });
  }

  static void dismiss() {
    _toastTimer?.cancel();
    _overlayEntry?.remove();
    _overlayEntry = null;
  }
}
