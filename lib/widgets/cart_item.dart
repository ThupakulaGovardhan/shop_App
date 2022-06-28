import 'package:flutter/material.dart';
import 'package:flutter_application_20/providers/cart.dart';
import 'package:provider/provider.dart';

class CartItem extends StatelessWidget {
  final String id;
  final String productId;
  final double price;
  final int quantity;
  final String title;

CartItem(
  @required this.id,
  @required this.productId,
  @required this.price,
  @required this.quantity,
  @required this.title,
     );

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(id),
      background: Container(
        color: Theme.of(context).errorColor,
        child: Icon(
          Icons.delete,
          color: Colors.white,
          size: 40,
        ),
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20),
        margin: EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 4,
        ),
      ),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) {
        return showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('Are you sure'),
            content: Text(
              'Do you want to remove the item from the cart?',
            ),
            actions: <Widget> [
             FlatButton(
               child: Text('No'),
               onPressed: () {
               Navigator.of(ctx).pop(false);  
               },
             ),
             FlatButton(
               child: Text('Yes'),
               onPressed: () {
               Navigator.of(ctx).pop(true);  
               },
             ),
            ],
          ),
          );
      },
      onDismissed: (direction) {
        Provider.of<Cart>(context, listen: false).removeItem(productId);
      },
     child: Card(
      margin: EdgeInsets.symmetric(
       horizontal: 15,
       vertical: 4, 
      ),
      child: Padding(
        padding: EdgeInsets.all(8),
        child: ListTile(
          leading: CircleAvatar(
            child: Padding(
              padding: EdgeInsets.all(5),
              child: FittedBox(
              child: Text('\$$price'),),
            ),
          ),
          title: Text(title),
          subtitle: Text('Total: \$${(price * quantity)}'),
          trailing: Text('$quantity x'),
        ),
      ), 
     ),
    );
  }
}