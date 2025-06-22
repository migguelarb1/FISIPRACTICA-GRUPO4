import 'package:flutter/material.dart';

class Footer extends StatefulWidget {
  const Footer({super.key});

  @override
  _FooterState createState() => _FooterState();
}

class _FooterState extends State<Footer> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Color(0xFF1E3984),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            blurRadius: 7,
            offset: Offset(0, -3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          IconButton(
            icon: Image.asset(
              'assets/home_icon.png',
              color: _selectedIndex == 0 ? Colors.white : Colors.grey,
            ),
            onPressed: () {
              _onItemTapped(0);              
            },
          ),
          IconButton(
            icon: Image.asset(
              'assets/portfolio_icon.png',
              color: _selectedIndex == 1 ? Colors.white : Colors.grey,
            ),
            onPressed: () {
              _onItemTapped(1);
            },
          ),
          IconButton(
            icon: Image.asset(
              'assets/user_icon.png',
              color: _selectedIndex == 2 ? Colors.white : Colors.grey,
            ),
            onPressed: () {
              _onItemTapped(2);
            },
          ),
        ],
      ),
    );
  }
}