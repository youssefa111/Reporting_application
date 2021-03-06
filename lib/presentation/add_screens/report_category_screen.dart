import 'package:flutter/material.dart';

import '../../helper/componants/search_widget.dart';
import '../../helper/constants/constants.dart';
import 'report_screen.dart';

class ReportCategoryScreen extends StatefulWidget {
  const ReportCategoryScreen({Key? key}) : super(key: key);

  @override
  _ReportCategoryScreenState createState() => _ReportCategoryScreenState();
}

class _ReportCategoryScreenState extends State<ReportCategoryScreen> {
  List<ReportCategory> categoryList = [
    ReportCategory(icon: 'assets/images/2.png', iconName: 'Other'),
    ReportCategory(
        icon: 'assets/images/6.png', iconName: 'Traffic Signal Issues'),
    ReportCategory(
        icon: 'assets/images/10.png', iconName: 'COVID Questions / Concerns'),
    ReportCategory(
        icon: 'assets/images/5.png', iconName: 'Facility Maintenance'),
    ReportCategory(
        icon: 'assets/images/4.png', iconName: 'Street Light Repair'),
    ReportCategory(
        icon: 'assets/images/7.png', iconName: 'Graffitti At City Facility'),
    ReportCategory(
        icon: 'assets/images/3.png', iconName: 'Inefficient Water Use'),
    ReportCategory(icon: 'assets/images/1.png', iconName: 'App Feedback'),
    ReportCategory(
        icon: 'assets/images/8.png', iconName: 'Repost A Code Violation'),
    ReportCategory(
        icon: 'assets/images/9.png', iconName: 'Damaged Street Sign'),
    ReportCategory(icon: 'assets/images/9.png', iconName: 'Test Name'),
  ];
  late List searchList;

  @override
  void initState() {
    super.initState();
    searchList = categoryList;
  }

  String query = '';
  void searchCategory(String query) {
    final searchList = categoryList.where((category) {
      final titleLower = category.iconName.toLowerCase();

      final searchLower = query.toLowerCase();

      return titleLower.contains(searchLower);
    }).toList();

    setState(() {
      this.query = query;
      this.searchList = searchList;
    });
  }

  Widget buildSearch() => SearchWidget(
        text: query,
        hintText: 'Search title',
        onChanged: searchCategory,
      );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: linearGradient,
          ),
        ),
        elevation: 0.0,
        centerTitle: true,
        title: Text(
          'Issue type',
          style: TextStyle(color: Colors.white, fontSize: 15),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: <Widget>[
            buildSearch(),
            Expanded(
              child: ListView.separated(
                  itemBuilder: (context, index) {
                    final ReportCategory category = searchList[index];
                    return ReportCategory(
                      icon: category.icon,
                      iconName: category.iconName,
                    );
                  },
                  separatorBuilder: (context, index) => SizedBox(
                        height: 20,
                      ),
                  itemCount: searchList.length),
            ),
          ],
        ),
      ),
    );
  }
}

class ReportCategory extends StatelessWidget {
  final String icon;
  final String iconName;

  ReportCategory({
    Key? key,
    required this.icon,
    required this.iconName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) =>
              ReportScreen(iconData: icon, reportCategoryName: iconName),
        ),
      ),
      child: Container(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Image.asset(
              icon,
              height: 50,
              width: 50,
            ),
            SizedBox(
              width: 20,
            ),
            Text(
              iconName,
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            )
          ],
        ),
      ),
    );
  }
}
