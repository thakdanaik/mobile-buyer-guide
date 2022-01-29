import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_buyer_guide/bloc/catalog/catalog_bloc.dart';
import 'package:mobile_buyer_guide/constants/constant.dart';
import 'package:mobile_buyer_guide/models/mobile.dart';
import 'package:mobile_buyer_guide/router.dart';
import 'package:mobile_buyer_guide/services/mobile_service.dart';
import 'package:mobile_buyer_guide/theme/theme.dart';

class Catalog extends StatefulWidget {
  const Catalog({Key? key}) : super(key: key);

  @override
  State<Catalog> createState() => _CatalogState();
}

class _CatalogState extends State<Catalog> {
  late final CatalogBloc _catalogBloc;

  @override
  void initState() {
    _catalogBloc = CatalogBloc(mobileService: MobileService(Dio()));
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _catalogBloc.close();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _catalogBloc,
      child: CatalogView(catalogBloc: _catalogBloc),
    );
  }
}

class CatalogView extends StatefulWidget {
  final CatalogBloc catalogBloc;

  const CatalogView({Key? key, required this.catalogBloc}) : super(key: key);

  @override
  _CatalogViewState createState() => _CatalogViewState();
}

class _CatalogViewState extends State<CatalogView> {
  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    widget.catalogBloc.add(GetMobileDataEvent());
  }

  Future<void> _onSortTapped(BuildContext context) async {
    SortBy? sortBy = await showDialog<dynamic>(
        context: context,
        barrierDismissible: true,
        barrierColor: Colors.black.withOpacity(0.6),
        builder: (BuildContext ctx) {
          return AlertDialog(
            backgroundColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(vertical: 5.0),
            content: PopupSort(sortValue: widget.catalogBloc.state.sortBy),
          );
        });
    if (sortBy != null) {
      widget.catalogBloc.add(SortDataEvent(sortBy: sortBy));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CatalogBloc, CatalogState>(
      listener: (context, state) {
        if (state.currentPage.compareTo(_pageController.page ?? 0) != 0) {
          _pageController.animateToPage(state.currentPage, duration: const Duration(milliseconds: 200), curve: Curves.easeOut);
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Mobile List'),
                GestureDetector(
                  onTap: () async => await _onSortTapped(context),
                  child: const Icon(Icons.sort),
                )
              ],
            ),
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
            onTap: (index) => widget.catalogBloc.add(ChangePageViewEvent(pageIndex: index)),
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
    );
  }

  Widget _buildMobileListView(BuildContext context, {required List<Mobile> mobileList, required bool isFavoriteView}) {
    if (widget.catalogBloc.state is LoadingState) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      itemCount: mobileList.length,
      itemBuilder: (context, index) {
        Mobile mobile = mobileList[index];

        Widget item = Container();
        if (isFavoriteView) {
          item = Dismissible(
            key: Key(mobile.id!.toString()),
            direction: DismissDirection.endToStart,
            onDismissed: (direction) => widget.catalogBloc.add(RemoveFavoriteEvent(mobile: mobile)),
            background: Container(
              color: Colors.red,
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(right: 20),
              child: const Icon(
                Icons.delete_forever,
                size: 50,
              ),
            ),
            child: _buildItemBox(context, mobile: mobile, isShowFavIcon: false),
          );
        } else {
          item = _buildItemBox(context, mobile: mobile, isShowFavIcon: true);
        }

        return Column(
          children: [
            item,
            const Divider(height: 1, thickness: 1.5),
          ],
        );
      },
    );
  }

  Widget _buildItemBox(BuildContext context, {required Mobile mobile, required bool isShowFavIcon}) {
    return InkWell(
      onTap: () => Navigator.pushNamed(context, AppRoutePaths.detail, arguments: mobile),
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
                    children: [
                      Expanded(
                        child: Text(
                          mobile.name!,
                          style: Theme.of(context).textTheme.large,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                      if (isShowFavIcon)
                        InkWell(
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          onTap: () {
                            widget.catalogBloc.add(AddFavoriteEvent(mobile: mobile));
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
                    children: [
                      Expanded(
                        child: RichText(
                          text: TextSpan(
                            style: DefaultTextStyle.of(context).style,
                            children: <TextSpan>[
                              TextSpan(text: 'Price : ', style: Theme.of(context).textTheme.normal.copyWith(fontWeight: FontWeight.bold)),
                              TextSpan(text: '\$${mobile.price!.toStringAsFixed(2)}', style: Theme.of(context).textTheme.normal),
                            ],
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                      Expanded(
                        child: RichText(
                          text: TextSpan(
                            style: DefaultTextStyle.of(context).style,
                            children: <TextSpan>[
                              TextSpan(text: 'Rating : ', style: Theme.of(context).textTheme.normal.copyWith(fontWeight: FontWeight.bold)),
                              TextSpan(text: mobile.rating!.toStringAsFixed(1), style: Theme.of(context).textTheme.normal),
                            ],
                          ),
                          textAlign: TextAlign.right,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
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

class PopupSort extends StatelessWidget {
  final SortBy sortValue;

  const PopupSort({Key? key, required this.sortValue}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        _buildRadioTile(context, 'Price (Low to High)', SortBy.priceLowToHigh),
        _buildRadioTile(context, 'Price (High to Low)', SortBy.priceHighToLow),
        _buildRadioTile(context, 'Rating (5 to 1)', SortBy.rating),
      ],
    );
  }

  Widget _buildRadioTile(BuildContext context, String text, SortBy value) {
    return RadioListTile<SortBy>(
      title: Text(text),
      value: value,
      groupValue: sortValue,
      onChanged: (value) {
        Navigator.of(context).pop(value);
      },
    );
  }
}
