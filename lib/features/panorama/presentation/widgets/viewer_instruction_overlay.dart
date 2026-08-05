import 'package:flutter/material.dart';

class ViewerInstructionOverlay extends StatelessWidget {
  const ViewerInstructionOverlay({required this.onDismiss, super.key});

  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: ColoredBox(
        color: Colors.black.withValues(alpha: 0.62),
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(28),
              child: Container(
                constraints: const BoxConstraints(maxWidth: 360),
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.95),
                  borderRadius: BorderRadius.circular(28),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Explore in 360°',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 22),
                    const _Instruction(
                      icon: Icons.swipe_rounded,
                      title: 'Drag to look around',
                      description:
                          'Swipe in any direction to explore the space.',
                    ),
                    const SizedBox(height: 18),
                    const _Instruction(
                      icon: Icons.pinch_rounded,
                      title: 'Pinch to zoom',
                      description:
                          'Use two fingers to move closer or further away.',
                    ),
                    const SizedBox(height: 18),
                    const _Instruction(
                      icon: Icons.touch_app_rounded,
                      title: 'Tap a marker',
                      description:
                          'Read a story or travel to the next panorama.',
                    ),
                    const SizedBox(height: 26),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: onDismiss,
                        child: const Text('Start exploring'),
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
  }
}

class _Instruction extends StatelessWidget {
  const _Instruction({
    required this.icon,
    required this.title,
    required this.description,
  });

  final IconData icon;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondaryContainer,
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: Theme.of(context).colorScheme.onSecondaryContainer,
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                ),
              ),
              const SizedBox(height: 3),
              Text(description, style: Theme.of(context).textTheme.bodyMedium),
            ],
          ),
        ),
      ],
    );
  }
}
