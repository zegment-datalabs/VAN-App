import 'package:flutter/material.dart';
import 'package:van_app_demo/myorders_page.dart';
import 'package:van_app_demo/login_page.dart';

/// Custom App Bar
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback onHomePressed;
  final VoidCallback onCartPressed;

  const CustomAppBar({
    Key? key,
    required this.title,
    required this.onHomePressed,
    required this.onCartPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.teal,
      iconTheme: const IconThemeData(color: Colors.white),
      title: Text(title, style: const TextStyle(color: Colors.white)),
      actions: [
        IconButton(
            icon: const Icon(Icons.home, color: Colors.white),
            onPressed: onHomePressed),
        IconButton(
            icon: const Icon(Icons.shopping_cart, color: Colors.white),
            onPressed: onCartPressed),
        Builder(
          builder: (context) {
            return IconButton(
              icon: const Icon(Icons.menu, color: Colors.white),
              onPressed: () {
                Scaffold.of(context).openEndDrawer();
              },
            );
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

/// Custom Search Bar
class CustomSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final Function(String) onSearch;
   final FocusNode? focusNode;

  const CustomSearchBar({
    Key? key,
    required this.controller,
    required this.onSearch,
    this.focusNode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: TextField(
        controller: controller,
        onChanged: onSearch,
        decoration: InputDecoration(
          hintText: 'Search...',
          prefixIcon: const Icon(Icons.search, color: Colors.grey),
          suffixIcon: controller.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.close, color: Colors.grey),
                  onPressed: () {
                    controller.clear();
                    onSearch(''); // Clear search results
                  },
                )
              : null,
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(vertical: 12),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0),
            borderSide: const BorderSide(color: Colors.teal),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0),
            borderSide: const BorderSide(color: Colors.teal),
          ),
        ),
      ),
    );
  }
}

/// Custom Bottom Navigation Bar
class CustomBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onItemTapped;

  const CustomBottomNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onItemTapped,
      selectedItemColor: Colors.teal,
      unselectedItemColor: Colors.black,
      type: BottomNavigationBarType.fixed,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.category), label: 'Category'),
        BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: 'Cart'),
        BottomNavigationBarItem(
            icon: Icon(Icons.view_list), label: 'All Products'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Account'),
      ],
    );
  }
}

/// class button
class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final Color backgroundColor;
  final Color textColor;
  final double width;
  final double height;
  final double borderRadius;
  final TextStyle textStyle;
  final bool showConfirmationDialog;
  final String? confirmationTitle;
  final String? confirmationMessage;
  final VoidCallback? onConfirm;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.backgroundColor = Colors.blue,
    this.textColor = Colors.white,
    this.width = 180,
    this.height = 40,
    this.borderRadius = 30,
    this.textStyle = const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.bold,
      color: Colors.white,
    ),
    this.showConfirmationDialog = false,
    this.confirmationTitle,
    this.confirmationMessage,
    this.onConfirm,
  });

  void _showDialog(BuildContext context) {
    if (showConfirmationDialog && onConfirm != null) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(confirmationTitle ?? "Confirm Action"),
          content: Text(confirmationMessage ?? "Are you sure you want to proceed?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                onConfirm!();
              },
              child: const Text("Confirm", style: TextStyle(color: Colors.red)),
            ),
          ],
        ),
      );
    } else {
      onPressed?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        onPressed: () => _showDialog(context),
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
        ),
        child: Text(text, style: textStyle),
      ),
    );
  }
}



/// Custom Drawer
class CustomDrawer extends StatelessWidget {
  final String profilePicUrl;
  final String username;
  final Function(int)? onItemTapped;

  const CustomDrawer({
    Key? key,
    required this.profilePicUrl,
    required this.username,
    this.onItemTapped,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(color: Colors.teal),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundImage: profilePicUrl.isNotEmpty
                      ? NetworkImage(profilePicUrl)
                      : null,
                  backgroundColor: Colors.grey.shade400,
                  child: profilePicUrl.isEmpty
                      ? const Icon(Icons.person, size: 40, color: Colors.white)
                      : null,
                ),
                const SizedBox(height: 10),
                Text(username,
                    style: const TextStyle(color: Colors.white, fontSize: 16)),
              ],
            ),
          ),
          _buildDrawerItem(Icons.home, 'Home', 0),
          _buildDrawerItem(Icons.category, 'Categories', 1),
          _buildDrawerItem(Icons.shopping_cart, 'Cart', 2),
          _buildDrawerItem(Icons.view_list, 'All Products', 3),
          _buildDrawerItem(Icons.assignment, 'My Orders', -1, () {
            Navigator.push(
                context, MaterialPageRoute(builder: (_) => MyOrdersPage()));
          }),
          _buildDrawerItem(Icons.exit_to_app, 'Logout', -1, () {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (_) => const LoginPage()));
          }),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(IconData icon, String title, int index,
      [VoidCallback? customAction]) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: () {
        if (customAction != null) {
          customAction();
        } else if (onItemTapped != null) {
          onItemTapped!(index);
        }
      },
    );
  }
}
