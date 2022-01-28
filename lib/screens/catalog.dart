import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_buyer_guide/bloc/catalog/catalog_bloc.dart';
import 'package:mobile_buyer_guide/models/mobile.dart';
import 'package:mobile_buyer_guide/services/mobile_service.dart';
import 'package:mobile_buyer_guide/theme/theme.dart';

class Catalog extends StatefulWidget {
  const Catalog({Key? key}) : super(key: key);

  @override
  _CatalogState createState() => _CatalogState();
}

class _CatalogState extends State<Catalog> {
  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CatalogBloc(mobileService: MobileService(Dio()))..add(GetMobileDataEvent()),
      child: BlocConsumer<CatalogBloc, CatalogState>(
        listener: (context, state) {
          if (state.currentPage.compareTo(_pageController.page ?? 0) != 0) {
            _pageController.animateToPage(state.currentPage, duration: const Duration(milliseconds: 200), curve: Curves.easeOut);
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Mobile List'),
            ),
            body: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                _buildMobileListView(context, mobileList: state.mobileList, isFavoriteView: false),
                _buildMobileListView(context, mobileList: state.favoriteList, isFavoriteView: true),
              ],
            ),
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: state.currentPage,
              selectedItemColor: Colors.redAccent,
              onTap: (index) => BlocProvider.of<CatalogBloc>(context).add(ChangePageViewEvent(pageIndex: index)),
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(Icons.list),
                  label: 'List',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.favorite),
                  label: 'Favorite',
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildMobileListView(BuildContext context, {required List<Mobile> mobileList, required bool isFavoriteView}) {
    if (BlocProvider.of<CatalogBloc>(context).state is LoadingState) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      itemCount: mobileList.length,
      itemBuilder: (context, index) {
        Mobile mobile = mobileList[index];

        return Column(
          children: [
            _buildItemBox(context, mobile: mobile, isShowFavIcon: !isFavoriteView),
            const Divider(height: 1, thickness: 1.5),
          ],
        );
      },
    );
  }

  Widget _buildItemBox(BuildContext context, {required Mobile mobile, required bool isShowFavIcon}) {
    return InkWell(
      onTap: () {},
      child: Container(
        height: 100,
        padding: const EdgeInsets.all(10.0),
        child: Row(
          children: [
            Image.network(
              mobile.thumbImageURL!,
              width: 80,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        mobile.name!,
                        style: Theme.of(context).textTheme.large,
                      ),
                      if (isShowFavIcon)
                        InkWell(
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          onTap: () {
                            BlocProvider.of<CatalogBloc>(context).add(AddFavoriteEvent(mobile: mobile));
                          },
                          child: (mobile.isFavorite ?? false)
                              ? const Icon(
                                  Icons.favorite,
                                  color: Colors.redAccent,
                                )
                              : const Icon(
                                  Icons.favorite_outline,
                                  color: Colors.grey,
                                ),
                        )
                    ],
                  ),
                  Text(
                    mobile.description!,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.normal,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      RichText(
                        text: TextSpan(
                          style: DefaultTextStyle.of(context).style,
                          children: <TextSpan>[
                            TextSpan(text: 'Price : ', style: Theme.of(context).textTheme.normal.copyWith(fontWeight: FontWeight.bold)),
                            TextSpan(text: '\$${mobile.price!.toStringAsFixed(2)}', style: Theme.of(context).textTheme.normal),
                          ],
                        ),
                      ),
                      RichText(
                        text: TextSpan(
                          style: DefaultTextStyle.of(context).style,
                          children: <TextSpan>[
                            TextSpan(text: 'Rating : ', style: Theme.of(context).textTheme.normal.copyWith(fontWeight: FontWeight.bold)),
                            TextSpan(text: mobile.rating!.toStringAsFixed(1), style: Theme.of(context).textTheme.normal),
                          ],
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
