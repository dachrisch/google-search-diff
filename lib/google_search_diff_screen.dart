import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_search_diff/main.dart';
import 'package:google_search_diff/search_bar_widget.dart';

class GoogleSearchDiffScreen extends StatefulWidget {
  const GoogleSearchDiffScreen({super.key});

  @override
  State<GoogleSearchDiffScreen> createState() => _GoogleSearchDiffScreenState();
}

class _GoogleSearchDiffScreenState extends State<GoogleSearchDiffScreen> {
   SearchResults searchResult=SearchResults();
  void _processData(SearchResults searchResult) {
    if (kDebugMode) {
      print('processing search results: $searchResult');
    }
    setState(() {
      this.searchResult = searchResult;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: GoogleSearchDiffScreenTheme.buildLightTheme(),
      child: Scaffold(
        body: Stack(
          children: <Widget>[
            InkWell(
              splashColor: Colors.transparent,
              focusColor: Colors.transparent,
              highlightColor: Colors.transparent,
              hoverColor: Colors.transparent,
              onTap: () {
                FocusScope.of(context).requestFocus(FocusNode());
              },
              child: Column(
                children: <Widget>[
                  getAppBarUI(),
                  Expanded(
                    child: NestedScrollView(
                      headerSliverBuilder:
                          (BuildContext context, bool innerBoxIsScrolled) {
                        return <Widget>[
                          SliverList(
                            delegate: SliverChildBuilderDelegate(
                                (BuildContext context, int index) {
                              return Column(
                                children: <Widget>[
                                  SearchBarWidget(
                                    searchCallback: _processData,
                                  ),
                                ],
                              );
                            }, childCount: 1),
                          ),
                        ];
                      },
                      body: Container(
                        color: GoogleSearchDiffScreenTheme.buildLightTheme()
                            .colorScheme
                            .background,
                        child: ListView.builder(
                          itemCount: searchResult.count(),
                          padding: const EdgeInsets.only(top: 8),
                          scrollDirection: Axis.vertical,
                          itemBuilder: (BuildContext context, int index) {
                            if (kDebugMode) {
                              print('index: $index');
                            }
                            return ListTile(
                              title: Text(searchResult.result[index].title),
                              subtitle: Text(searchResult.result[index].snippet),
                            );
                          },
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget getAppBarUI() {
    return Container(
      decoration: BoxDecoration(
        color: GoogleSearchDiffScreenTheme.buildLightTheme()
            .colorScheme
            .background,
        boxShadow: <BoxShadow>[
          BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              offset: const Offset(0, 2),
              blurRadius: 8.0),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.only(
            top: MediaQuery.of(context).padding.top, left: 8, right: 8),
        child: Row(
          children: <Widget>[
            Container(
              alignment: Alignment.centerLeft,
              width: AppBar().preferredSize.height + 40,
              height: AppBar().preferredSize.height,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(32.0),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Icon(Icons.arrow_back),
                  ),
                ),
              ),
            ),
            const Expanded(
              child: Center(
                child: Text(
                  'Google Search Diff',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 22,
                  ),
                ),
              ),
            ),
            SizedBox(
              width: AppBar().preferredSize.height + 40,
              height: AppBar().preferredSize.height,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(32.0),
                      ),
                      onTap: () {},
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Icon(Icons.favorite_border),
                      ),
                    ),
                  ),
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(32.0),
                      ),
                      onTap: () {},
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Icon(FontAwesomeIcons.locationDot),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
