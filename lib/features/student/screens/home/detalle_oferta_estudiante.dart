import 'package:flutter/material.dart';
import 'package:flutter_app/features/shared/widgets/header.dart';
import 'package:flutter_app/features/student/widgets/detalle_puesto_tab.dart';
import 'package:flutter_app/features/student/widgets/sobre_empresa_tab.dart';

class DetalleOfertaEstudianteScreen extends StatefulWidget {
  // final Map<String, dynamic>? oferta;
  const DetalleOfertaEstudianteScreen({super.key /* , this.oferta */});

  @override
  State<DetalleOfertaEstudianteScreen> createState() =>
      _DetalleOfertaEstudianteScreenState();
}

class _DetalleOfertaEstudianteScreenState
    extends State<DetalleOfertaEstudianteScreen>
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
    final oferta =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(110.0),
        child: Column(
          children: [
            const Header(isHome: false),
            TabBar(
              controller: _tabController,
              tabs: const [
                Tab(text: 'Detalles del Puesto'),
                Tab(text: 'Sobre la Empresa'),
              ],
              labelColor: const Color(0xFF1E3984),
              unselectedLabelColor: Colors.grey,
              indicatorColor: const Color(0xFF1E3984),
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          DetallePuestoTab(oferta: oferta),
          SobreEmpresaTab(oferta: oferta),
        ],
      ),
    );
  }
}
