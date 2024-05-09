import 'package:flutter/material.dart';
import 'package:google_search_diff/_new/widget/comparison/run_target.dart';
import 'package:google_search_diff/_new/widget/model/comparison.dart';

class RunComparisonContainer extends StatefulWidget {
  final bool isActive;

  RunComparisonContainer({super.key, required this.isActive});

  @override
  State<StatefulWidget> createState() => _RunComparisonContainerState();
}

class _RunComparisonContainerState extends State<RunComparisonContainer>
    with TickerProviderStateMixin {
  final ComparisonViewModel comparisonViewModel = ComparisonViewModel();

  late final AnimationController _controller;
  late final Animation<double> fadeInAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    fadeInAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isActive) {
      _controller.forward();
    } else if (comparisonViewModel.isEmpty) {
      _controller.stop();
      _controller.reset();
    }
    return FadeTransition(
      opacity: fadeInAnimation,
      child: SizedBox(
        height: 150,
        child: Column(
          children: [
            Text(
              'Compare runs',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const SizedBox(
                  width: 20,
                ),
                RunDragTarget(
                    willAcceptRun: (run) =>
                        comparisonViewModel.notContains(run),
                    onAcceptRun: (run) =>
                        setState(() => comparisonViewModel.dropBase(run))),
                const Icon(Icons.compare_arrows_outlined),
                RunDragTarget(
                    willAcceptRun: (run) =>
                        comparisonViewModel.notContains(run),
                    onAcceptRun: (run) =>
                        setState(() => comparisonViewModel.dropCurrent(run))),
                const SizedBox(
                  width: 20,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
