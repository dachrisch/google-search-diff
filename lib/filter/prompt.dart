import 'package:choice/choice.dart';
import 'package:flutter/material.dart';

class PromptFilterChoice extends StatefulWidget {
  final Map<String, int> filterOptions;
  final void Function(List<String> newFilterList) onFilterChanged;
  final Widget title;

  const PromptFilterChoice({
    super.key,
    required this.title,
    required this.filterOptions,
    required this.onFilterChanged,
  });

  @override
  State<StatefulWidget> createState() => _PromptFilterChoiceState();
}

class _PromptFilterChoiceState extends State<PromptFilterChoice> {
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
      searchable: true,
      itemSkip: (state, index) =>
          !ChoiceSearch.match(sortedFilterOptions[index], state.search?.value),
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
        title: widget.title,
        actionsBuilder: [
          ChoiceModal.createConfirmButton(),
          ChoiceModal.createSpacer(width: 20),
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
      promptDelegate: ChoicePrompt.delegateNewPage(),
    );
  }
}
