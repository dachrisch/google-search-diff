import 'package:choice/choice.dart';
import 'package:flutter/material.dart';

class FilterChoiceInline extends StatefulWidget {
  final Map<String, int> filterOptions;
  final void Function(List<String> newFilterList) onFilterChanged;
  final Widget title;

  const FilterChoiceInline(
      {super.key,
      required this.filterOptions,
      required this.onFilterChanged,
      required this.title});

  @override
  State<StatefulWidget> createState() => _FilterChoiceInlineState();
}

class _FilterChoiceInlineState extends State<FilterChoiceInline> {
  List<String> sortedFilterOptions = [];
  final List<String> selectedFilterValues = [];

  @override
  void initState() {
    sortedFilterOptions.addAll(widget.filterOptions.keys);
    sortedFilterOptions.sort();
    selectedFilterValues.addAll(sortedFilterOptions);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Choice<String>.prompt(
      value: selectedFilterValues,
      multiple: true,
      clearable: true,
      itemSkip: (state, index) =>
          !ChoiceSearch.match(sortedFilterOptions[index], state.search?.value),
      onChanged: (newFilterList) {
        setState(() {
          selectedFilterValues.clear();
          selectedFilterValues.addAll(newFilterList);
          selectedFilterValues.sort();
        });
        widget.onFilterChanged(newFilterList);
      },
      itemCount: sortedFilterOptions.length,
      itemBuilder: (state, i) {
        var item = sortedFilterOptions[i];
        return CheckboxListTile(
          value: state.selected(item),
          onChanged: state.onSelected(item),
          title: ChoiceText(
            item,
            highlight: state.search?.value,
          ),
          secondary: Text('(${widget.filterOptions[item]})'),
        );
      },
      modalHeaderBuilder: ChoiceModal.createHeader(
        automaticallyImplyLeading: false,
        actionsBuilder: [
          ChoiceModal.createConfirmButton(),
          ChoiceModal.createSpacer(width: 10),
        ],
      ),
      modalFooterBuilder: (state) {
        return CheckboxListTile(
          value: state.selectedMany(sortedFilterOptions),
          onChanged: state.onSelectedMany(sortedFilterOptions),
          tristate: true,
          title: const Text('Select All'),
        );
      },
      promptDelegate: ChoicePrompt.delegateBottomSheet(),
    );
  }
}
