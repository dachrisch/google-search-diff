import 'package:choice/choice.dart';
import 'package:flutter/material.dart';

class FilterChoice extends StatefulWidget {
  final List<String> initialFilterValues;
  final void Function(List<String> newFilterList) onFilterChanged;
  final Widget title;

  const FilterChoice(
      {super.key,
      required this.initialFilterValues,
      required this.onFilterChanged,
      required this.title});

  @override
  State<StatefulWidget> createState() => _FilterChoiceState();
}

class _FilterChoiceState extends State<FilterChoice> {
  List<String> sortedFilter = [];
  final List<String> selectedFilterValues = [];

  @override
  void initState() {
    sortedFilter.addAll(widget.initialFilterValues);
    sortedFilter.sort();
    selectedFilterValues.addAll(sortedFilter);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Choice<String>.prompt(
      value: selectedFilterValues,
      multiple: true,
      clearable: true,
      searchable: true,
      itemSkip: (state, index) =>
          !ChoiceSearch.match(sortedFilter[index], state.search?.value),
      anchorBuilder: (state, openModal) => IconButton(
          key: const Key('open-filter-button'),
          onPressed: openModal,
          icon: const Icon(Icons.filter_list)),
      onChanged: (newFilterList) {
        setState(() {
          selectedFilterValues.clear();
          selectedFilterValues.addAll(newFilterList);
          selectedFilterValues.sort();
        });
        widget.onFilterChanged(newFilterList);
      },
      itemCount: sortedFilter.length,
      itemBuilder: (state, i) {
        return CheckboxListTile(
          value: state.selected(sortedFilter[i]),
          onChanged: state.onSelected(sortedFilter[i]),
          title: ChoiceText(
            sortedFilter[i],
            highlight: state.search?.value,
          ),
        );
      },
      modalHeaderBuilder: ChoiceModal.createHeader(
        title: widget.title,
        actionsBuilder: [
          ChoiceModal.createConfirmButton(),
          ChoiceModal.createSpacer(width: 20),
        ],
      ),
      promptDelegate: ChoicePrompt.delegateNewPage(),
    );
  }
}
