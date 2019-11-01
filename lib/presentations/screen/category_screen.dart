import 'package:flutter/material.dart';
import 'package:flutter_kickstart/environment/config.dart';
import 'package:flutter_kickstart/environment/dev.dart';
import 'package:flutter_kickstart/language_wrapper.dart';
import 'package:flutter_kickstart/model/category_model.dart';
import 'package:flutter_kickstart/presentations/screen/more_category_screen.dart';
import 'package:flutter_kickstart/presentations/widget/app_bar_widget.dart';
import 'package:flutter_kickstart/presentations/widget/empty_data.dart';
import 'package:flutter_kickstart/service/product/category_services.dart';

class CategoryScreen extends StatefulWidget {
  CategoryScreen({Key key, this.title}) : super(key: key);
  final String title;

  @override
  State<StatefulWidget> createState() {
    return _CategoryScreenState();
  }
}

class _CategoryScreenState extends State<CategoryScreen>
    with AutomaticKeepAliveClientMixin {
  int page = 1;
  int limit = 2;
  List<Category> categories;
  ScrollController _controller;

  var appConfig = Config.fromJson(config);

  @override
  void initState() {
    _controller = ScrollController();
    _controller.addListener(_scrollListener);
    categoriesClient(page, limit).then((value) {
      categories = value;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    ListTile makeListTile(Category category) => ListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: 00.0, vertical: 0.0),
          leading: Container(
            child: FadeInImage(
              width: 50,
              height: 60,
              image: category.icon != null
                  ? NetworkImage("${appConfig.baseUrl}/${category.icon}")
                  : AssetImage("assets/images/placeholder.png"),
              placeholder: AssetImage("assets/images/placeholder.png"),
            ),
          ),
          title: Text(
            category.name_en,
            style: TextStyle(color: Colors.black, fontSize: 15),
          ),
          trailing: Icon(Icons.keyboard_arrow_right,
              color: Colors.black12, size: 30.0),
        );

    Card makeCard(Category category) => Card(
          elevation: 0.0,
          margin: EdgeInsets.only(top: 10, right: 10, left: 10),
          child: Container(
            decoration: BoxDecoration(color: Color(0xfaf7f7)),
            child: InkWell(
              hoverColor: Colors.red,
              borderRadius: BorderRadius.all(Radius.circular(4)),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => MoreCategoryScreen(category)));
              },
              child: makeListTile(category),
            ),
          ),
        );

    final makeBody = Builder(
      builder: (BuildContext context) {
        if (categories != null) {
          if (categories.length > 0) {
            return Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.fromLTRB(20, 15, 0, 0),
                      child: Text(
                        LanguageWrapper.of(context).text("all_categories"),
                        textAlign: TextAlign.left,
                        style:
                            TextStyle(color: Color(0xffA8A8A8), fontSize: 15),
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: ListView.builder(
                      controller: _controller,
                      scrollDirection: Axis.vertical,
                      itemCount: categories.length,
                      itemBuilder: (BuildContext context, int index) {
                        return makeCard(categories[index]);
                      }),
                )
              ],
            );
          } else {
            return EmptyData();
          }
        } else {
          categoriesClient(page, limit).then((value) {
            setState(() {
              categories = value;
            });
          });
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );

    return Scaffold(
        appBar: AppBarWidget.buildAppBar(context),
        backgroundColor: Colors.white,
        body: Container(
          child: makeBody,
        ));
  }

  @override
  bool get wantKeepAlive => true;

  _scrollListener() {
    if (_controller.offset >= _controller.position.maxScrollExtent &&
        !_controller.position.outOfRange) {
      print("Dol Here");
      setState(() {
        page++;
      });
      categoriesClient(page, limit).then((value) {
        categories = value;
      }).catchError((onError) {
        print("error category ${onError.toString()}");
      });
    }
  }

}
