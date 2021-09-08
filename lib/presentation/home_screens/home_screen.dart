import 'package:first_task/business_logic/cubit/homescreen_cubit/home_screen_cubit.dart';
import 'package:first_task/helper/componants/homescreen_componants/drawer.dart';
import 'package:first_task/helper/componants/homescreen_componants/filter_dialog.dart';
import 'package:first_task/helper/componants/homescreen_componants/top_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        centerTitle: true,
        title: const Text('Irvine'),
      ),
      drawer: HomeDrawer(),
      body: HomeBody(),
      bottomSheet: Row(
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 10),
              child: TextField(
                decoration: InputDecoration(
                  labelText: 'Search for Information',
                  isDense: true,
                ),
              ),
            ),
          ),
          TextButton(
            style: TextButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor,
            ),
            onPressed: () {},
            child: FittedBox(
              child: Text(
                'Find',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ),
          SizedBox(
            width: 15,
          ),
        ],
      ),
    );
  }
}

class HomeBody extends StatelessWidget {
  const HomeBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(padding: const EdgeInsets.all(0), child: ViewSection());
  }
}

// class TopSection extends StatelessWidget {
//   const TopSection({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     var screenWidth = MediaQuery.of(context).size.width;
//     var screenHeight = MediaQuery.of(context).size.height;
//     return Container(
//       height: screenHeight * .15,
//       width: screenWidth,
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: <Widget>[
//           TopContainer(
//               height: screenHeight * .2,
//               width: screenWidth / 4,
//               imagePath: 'assets/forbidden.jpg',
//               title: 'Report Hate Crime'),
//           TopContainer(
//               height: screenHeight * .2,
//               width: screenWidth / 4,
//               imagePath: 'assets/map1.jpg',
//               title: 'Report an issue'),
//           TopContainer(
//               height: screenHeight * .2,
//               width: screenWidth / 4,
//               imagePath: 'assets/map2.jpg',
//               title: 'Neighborhood Activity'),
//         ],
//       ),
//     );
//   }
// }

class ViewSection extends StatelessWidget {
  const ViewSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            TopContainer(
                height: 100,
                width: screenWidth / 4,
                imagePath: 'assets/forbidden.jpg',
                title: 'Report Hate Crime'),
            TopContainer(
                height: 100,
                width: screenWidth / 4,
                imagePath: 'assets/map1.jpg',
                title: 'Report an issue'),
            TopContainer(
                height: 100,
                width: screenWidth / 4,
                imagePath: 'assets/map2.jpg',
                title: 'Neighborhood Activity'),
          ],
        ),
        SizedBox(
          height: 10,
        ),
        Row(
          children: <Widget>[
            SizedBox(
              width: 5,
            ),
            Text(
              'Alerts & New',
              style: Theme.of(context)
                  .textTheme
                  .headline5!
                  .copyWith(fontWeight: FontWeight.bold),
            ),
            Spacer(),
            IconButton(
              onPressed: () {
                showDialog(
                    context: context, builder: (context) => FilterDialog());
              },
              icon: FaIcon(
                FontAwesomeIcons.slidersH,
              ),
            ),
          ],
        ),
        SizedBox(
          height: 10,
        ),
        Expanded(child: BlocBuilder<HomeScreenCubit, HomeScreenState>(
          builder: (context, state) {
            return ListView.separated(
                itemBuilder: (context, index) => state is FilteredSucessfully
                    ? HomeScreenCubit.get(context).filterList[index]
                    : HomeScreenCubit.get(context).dataList[index],
                separatorBuilder: (context, index) => SizedBox(),
                itemCount: state is FilteredSucessfully
                    ? HomeScreenCubit.get(context).filterList.length
                    : HomeScreenCubit.get(context).dataList.length);
          },
        )),
      ],
    );
  }
}