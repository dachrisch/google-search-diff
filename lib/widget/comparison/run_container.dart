import 'package:flutter/material.dart';
import 'package:google_search_diff/logger.dart';
import 'package:google_search_diff/routes/relative_route_extension.dart';
import 'package:google_search_diff/widget/comparison/comparison_view_model.dart';
import 'package:google_search_diff/widget/comparison/run_target.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

class RunComparisonContainer extends StatefulWidget {
  final bool isActive;

  const RunComparisonContainer({super.key, required this.isActive});

  @override
  State<StatefulWidget> createState() => _RunComparisonContainerState();
}

class _RunComparisonContainerState extends State<RunComparisonContainer>
    with TickerProviderStateMixin {
  final Logger l = getLogger('run-comparison');
  late ComparisonViewModel compareModel;

  late final AnimationController _controller;
  late final Animation<double> fadeInAnimation;

  bool get containerOpen => widget.isActive || compareModel.isNotEmpty;

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

    compareModel = context.read<ComparisonViewModel>();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isActive || compareModel.isNotEmpty) {
      _controller.forward();
      l.d('Drop Container opened');
    } else if (compareModel.isEmpty) {
      l.d('Drop Container closed');
      _controller.stop();
      _controller.reset();
    }
    return FadeTransition(
      opacity: fadeInAnimation,
      child: SizedBox(
        height: containerOpen ? 150 : 0,
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
                  acceptedRun: compareModel.base,
                  willAcceptRun: (run) => compareModel.notContains(run),
                  onAcceptRun: (run) =>
                      setState(() => compareModel.dropBase(run)),
                  onRemoveRun: () => setState(() {
                    compareModel.removeBase();
                  }),
                ),
                IconButton(
                    onPressed: compareModel.isComplete
                        ? () => context.goToComparison(compareModel)
                        : null,
                    icon: const Icon(Icons.compare_arrows_outlined)),
                RunDragTarget(
                    acceptedRun: compareModel.current,
                    willAcceptRun: (run) => compareModel.notContains(run),
                    onAcceptRun: (run) =>
                        setState(() => compareModel.dropCurrent(run)),
                    onRemoveRun: () => setState(() {
                          compareModel.removeCurrent();
                        })),
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
