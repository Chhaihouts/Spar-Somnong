import 'package:flutter/material.dart';
import 'package:flutter_kickstart/data/constant/constant_value.dart';
import 'package:flutter_kickstart/data_provider/user_provider.dart';
import 'package:flutter_kickstart/language_wrapper.dart';
import 'package:flutter_kickstart/languge_config.dart';
import 'package:flutter_kickstart/presentations/screen/search_screen.dart';
import 'package:provider/provider.dart';

import 'flag_language.dart';

class AppBarWidget {
  static buildAppBar(BuildContext context) {
    LanguageConfig languageConfig = LanguageWrapper.of(context);
    currencyContainer(String currency) {
      return Container(
        width: 20,
        height: 20,
        decoration: BoxDecoration(
            color: Colors.black,
            shape: BoxShape.circle
        ),
        child: Text(
          currency, style: TextStyle(color: Colors.white, fontSize: 18),
          textAlign: TextAlign.center,),
      );
    }
    return AppBar(
      titleSpacing: 0.0,
      elevation: 0,
      backgroundColor: Colors.white,
      centerTitle: false,
      title: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Container(
//          width: MediaQuery.of(context).size.width,
          child: Center(
            child: Padding(
              padding: EdgeInsets.only(left: 10, right: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                        child: Image.asset(
                          "assets/images/logo_toolbar.png",
                          width: 96.74,
                          height: 30,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                        child: FlagLanguage(),
                      ),
                      Selector<UserProvider, String>(
                          selector: (_, UserProvider userProvider) =>
                              userProvider.getCurrencyKey(),
                          builder: (_, data, __) {
                            return Padding(
                              padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                              child: PopupMenuButton(
                                child: data == RIEL_CURRENCY
                                    ? currencyContainer("៛")
                                    : data == YUAN_CURRENCY ? currencyContainer(
                                    "¥") : currencyContainer("\$"),
                                itemBuilder: (context) {
                                  return [
                                    PopupMenuItem(
                                      child: Text(languageConfig.text("riel")),
                                      value: RIEL_CURRENCY,
                                    ),
                                    PopupMenuItem(
                                      child: Text(
                                          languageConfig.text("dollar")),
                                      value: DOLLAR_CURRENCY,
                                    ),
                                    PopupMenuItem(
                                      child: Text(languageConfig.text("yuan")),
                                      value: YUAN_CURRENCY,
                                    )
                                  ];
                                },
                                onSelected: (val) {
                                  LanguageWrapper.updateCurrency(context, val);
                                  Provider
                                      .of<UserProvider>(context)
                                      .setCurrencyKey = val;
                                },
                              ),
                            );
                          }),

                    ],
                  )
                ],
              ),
            ),
          ),
          height: 54,
        ),
      ),
      actions: <Widget>[
        IconButton(
            icon: Image.asset(
              "assets/icons/search.png",
              width: 24,
            ),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => SearchScreen()));
            })
      ],
    );
  }
}
