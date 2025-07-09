import 'package:flutter/material.dart';
import 'package:flutter_app/features/shared/widgets/header.dart';
import 'package:flutter_app/features/recruiter/widgets/estudiantes_tab.dart';
import 'package:flutter_app/features/recruiter/widgets/mi_empresa_tab.dart';

class HomeReclutadorScreen extends StatefulWidget {
  const HomeReclutadorScreen({super.key});

  @override
  State<HomeReclutadorScreen> createState() => _HomeReclutadorScreenState();
}

class _HomeReclutadorScreenState extends State<HomeReclutadorScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(120.0),
        child: Column(
          children: [
            const Header(isHome: true),
            TabBar(
              controller: _tabController,
              tabs: const [
                Tab(text: "Mi Empresa"),
                Tab(text: "Estudiantes"),
              ],
              labelColor: Colors.blue,
              unselectedLabelColor: Colors.black54,
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          MiEmpresaTab(),
          EstudiantesTab(),
        ],
      ),
      //bottomNavigationBar: const Footer(),
    );
  }
}
