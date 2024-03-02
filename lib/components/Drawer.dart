import 'package:flutter/material.dart';
import 'package:hola_app/components/list_tile.dart';
import 'list_tile.dart';

class MyDrawer extends StatelessWidget {
  final void Function()? onProfileTap;
  final void Function()? onSignOut;

  const MyDrawer({super.key,required this.onProfileTap,required this.onSignOut});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.grey[900],
      child:Column(
        children: [
          SizedBox(height: 30,),

            const DrawerHeader(
              child:Icon(
                Icons.person,
                color: Colors.white,
                size:83,
              )
            ),
          MyListTile(icon: Icons.home, text: 'H O M E',
          onTap: () =>Navigator.pop(context),
          ),
          
          MyListTile(icon: Icons.person_2,
            text: 'P R O F I L E',
            onTap: onProfileTap,
          ),
          MyListTile(icon: Icons.logout_outlined,
            text: 'L O G O U T',
            onTap:onSignOut,
          )


        ],
      )
    );
  }
}
