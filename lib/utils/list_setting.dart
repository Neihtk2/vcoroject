import 'package:flutter/material.dart';

class OverlayList extends StatefulWidget {
  const OverlayList({Key? key}) : super(key: key);

  @override
  _OverlayListState createState() => _OverlayListState();
}

class _OverlayListState extends State<OverlayList> {
  bool _showList = false;

  void toggleList() {
    setState(() {
      _showList = !_showList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      child: Stack(
        children: [
          // Your main content here

          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              height: _showList ? 100 : 0,
              child: ListView(
                children: [
                  ListTile(
                    title: Text('Item 1}'),
                    onTap: () {
                      // Handle item tap
                    },
                  )
                ],
              ),
            ),
          ),

          // Floating action button to toggle the list
          Positioned(
            right: 20,
            child: IconButton(
              onPressed: toggleList,
              icon: Icon(_showList ? Icons.menu_open : Icons.menu),
            ),
          ),
        ],
      ),
    );
  }
}
