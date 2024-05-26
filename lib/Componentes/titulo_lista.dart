import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class TituloLista extends StatelessWidget {
  final String title;
  final String trailing;
  final void Function(BuildContext)? onEditPressed;
  final void Function(BuildContext)? onDeletePressed;

  const TituloLista({
    super.key,
    required this.title,
    required this.trailing,
    required this.onEditPressed,
    required this.onDeletePressed,
  });

  @override
  Widget build(BuildContext context) {
    return Slidable(
      endActionPane: ActionPane(
        motion: const StretchMotion(),
        children: [
          SlidableAction(
            onPressed: onEditPressed,
            icon: Icons.settings,
          ),
          SlidableAction(
            onPressed: onDeletePressed,
            icon: Icons.delete,
          ),
        ],
      ),
      child: ListTile(
        title: Text(title),
        trailing: Text(trailing),
      ),
    );
  }
}
