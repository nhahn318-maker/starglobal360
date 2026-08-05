import 'package:flutter/material.dart';

class ViewerInstructionOverlay extends StatelessWidget {
  const ViewerInstructionOverlay({required this.onDismiss, super.key});

  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 18,
      right: 18,
      bottom: MediaQuery.paddingOf(context).bottom + 82,
      child: Material(
        color: Colors.black.withValues(alpha: 0.72),
        borderRadius: BorderRadius.circular(18),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 10, 8, 10),
          child: Row(
            children: [
              const Icon(Icons.swipe_rounded, color: Colors.white, size: 20),
              const SizedBox(width: 9),
              const Expanded(
                child: Text(
                  'Drag · Pinch · Tap markers',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              IconButton(
                tooltip: 'Dismiss',
                onPressed: onDismiss,
                icon: const Icon(Icons.close_rounded, size: 20),
                color: Colors.white70,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
