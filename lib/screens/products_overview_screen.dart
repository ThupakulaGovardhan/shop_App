import 'package:flutter/material.dart';
import 'package:flutter_application_20/providers/cart.dart';
import 'package:flutter_application_20/providers/products.dart';
import 'package:flutter_application_20/screens/cart_screen.dart';
import 'package:flutter_application_20/widgets/app_drawer.dart';
import 'package:provider/provider.dart';


import '../widgets/product_grid.dart';
import '../widgets/badge.dart';

enum FilterOptions {
  Favorite,
  All,
}


class ProductsOverViewScreen extends StatefulWidget {
  static const routeName ='/Products_overviewscreen';
  @override
  _ProductsOverViewScreenState createState() => _ProductsOverViewScreenState();
}

class _ProductsOverViewScreenState extends State<ProductsOverViewScreen> {
  var _showOnlyFavorites = false;
  var _isInit = true;
  var _isLoading = false;

 @override
  void initState() {
   //Provider.of<Products>(context).fetchAndSetProducts(); //WON'T WORK! 
    //Future.delayed(Duration.zero).then((_) {
      //Provider.of<Products>(context).fetchAndSetProducts();
    //});
    super.initState();
  } 

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      
      Provider.of<Products>(context).fetchAndSetProducts().then((_) {
       setState(() {
         _isLoading = false;
       });
        
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('MyShop'),
        actions: <Widget> [
         PopupMenuButton(
           onSelected: (FilterOptions selectedValue) {
             setState(() {
               if (selectedValue == FilterOptions.Favorite) {
              _showOnlyFavorites = true;
             } else {
               _showOnlyFavorites = false;
             }
             });
             
           },
           icon: Icon(
             Icons.more_vert,
           ),
           itemBuilder: (_) =>[
             PopupMenuItem(
               child: Text('Only Favorites'),
                value: FilterOptions.Favorite,
                ),
             PopupMenuItem(
               child: Text('Shows All'),
                value: FilterOptions.All,
                ),
           ],
         ),
         Consumer <Cart>(
           builder: (_, cart, ch) => Badge(
         child: IconButton(
           icon: Icon(
             Icons.shopping_cart,
           ),
           onPressed: () {
            Navigator.of(context).pushNamed(CartScreen.routeName); 
           },
         ),
         value: cart.itemCount.toString(),
         color: Colors.red),
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: _isLoading
      ? Center(
        child: CircularProgressIndicator(),
      )
      :ProductGrid(_showOnlyFavorites),
    );
  }
} 

