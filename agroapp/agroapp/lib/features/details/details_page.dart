import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';
import '../../shared/models/fazenda_model.dart';

/// Tela de detalhes - Exibe dados completos do solo
/// Recebe FazendaModel via construtor da página
class DetailsPage extends StatelessWidget {
  final FazendaModel fazenda;

  const DetailsPage({super.key, required this.fazenda});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            // Navegação pop para voltar à página anterior
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Dados em Tempo Real',
          style: GoogleFonts.cormorantGaramond(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // Card 1 - Umidade (destaque principal)
          _buildCardUmidade(),
          const SizedBox(height: 20),

          // Card 2 - Dados do clima
          _buildCardClima(),
          const SizedBox(height: 20),

          // Cards extras - ListTile estilizado
          _buildCardsListTile(),
          const SizedBox(height: 24),

          // Botão VOLTAR MENU
          _buildBotaoVoltar(context),
        ],
      ),
    );
  }

  /// Card 1 — Umidade (destaque principal)
  Widget _buildCardUmidade() {
    return Container(
      height: 180,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.azulUmidade, Color(0xFF2D5E8E)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.azulUmidade.withOpacity(0.3),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Ícone no canto superior direito
          Positioned(
            right: 16,
            top: 16,
            child: Icon(
              Icons.water_drop,
              size: 36,
              color: Colors.white.withOpacity(0.6),
            ),
          ),
          // Conteúdo centralizado
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Label
                Text(
                  'UMIDADE DO SOLO',
                  style: GoogleFonts.montserrat(
                    fontSize: 11,
                    letterSpacing: 2,
                    color: Colors.white.withOpacity(0.7),
                  ),
                ),
                const SizedBox(height: 8),
                // Valor
                Text(
                  '${fazenda.umidade.toStringAsFixed(0)}%',
                  style: GoogleFonts.montserrat(
                    fontSize: 64,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                // Status
                Text(
                  fazenda.statusUmidade,
                  style: GoogleFonts.lora(
                    fontSize: 14,
                    fontStyle: FontStyle.italic,
                    color: Colors.white.withOpacity(0.8),
                  ),
                ),
                const SizedBox(height: 4),
                // Tempo de leitura
                Text(
                  fazenda.tempoLeitura,
                  style: GoogleFonts.montserrat(
                    fontSize: 11,
                    color: Colors.white.withOpacity(0.5),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Card 2 — Dados do clima
  Widget _buildCardClima() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Coluna 1 - Ícone do clima
          Expanded(
            child: Column(
              children: [
                Icon(
                  _getClimaIcon(fazenda.clima),
                  size: 48,
                  color: AppColors.douradoTrigo,
                ),
                const SizedBox(height: 8),
                Text(
                  fazenda.clima,
                  style: GoogleFonts.lora(
                    fontSize: 13,
                    color: AppColors.fundoEscuro,
                  ),
                ),
              ],
            ),
          ),
          // Coluna 2 - Temperatura
          Expanded(
            child: Column(
              children: [
                Text(
                  '${fazenda.temperatura}°C',
                  style: GoogleFonts.montserrat(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: AppColors.fundoEscuro,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'temperatura',
                  style: GoogleFonts.montserrat(
                    fontSize: 11,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          // Coluna 3 - Nutrientes
          Expanded(
            child: Column(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: fazenda.corNutrientes,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      fazenda.nutrientes,
                      style: GoogleFonts.montserrat(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'nutrientes',
                  style: GoogleFonts.montserrat(
                    fontSize: 11,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Cards extras — ListTile estilizado
  Widget _buildCardsListTile() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildDataTile(
            icone: Icons.water_drop,
            cor: AppColors.azulUmidade,
            titulo: 'Umidade',
            valor: '${fazenda.umidade.toStringAsFixed(0)}%',
          ),
          const Divider(height: 1),
          _buildDataTile(
            icone: Icons.eco,
            cor: AppColors.alertaIdeal,
            titulo: 'Nutrientes',
            valor: fazenda.nutrientes,
          ),
          const Divider(height: 1),
          _buildDataTile(
            icone: Icons.wb_sunny,
            cor: AppColors.douradoTrigo,
            titulo: 'Tempo',
            valor: fazenda.clima,
          ),
        ],
      ),
    );
  }

  /// Método auxiliar para construir ListTile estilizado
  Widget _buildDataTile({
    required IconData icone,
    required Color cor,
    required String titulo,
    required String valor,
  }) {
    return ListTile(
      leading: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: cor.withOpacity(0.12),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icone, color: cor, size: 22),
      ),
      title: Text(
        titulo,
        style: GoogleFonts.montserrat(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: AppColors.fundoEscuro,
        ),
      ),
      trailing: Text(
        valor,
        style: GoogleFonts.lora(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: AppColors.verdeOliva,
        ),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
    );
  }

  /// Botão VOLTAR MENU
  Widget _buildBotaoVoltar(BuildContext context) {
    return SizedBox(
      height: 56,
      child: ElevatedButton.icon(
        onPressed: () {
          // Navegação pop para voltar ao menu
          Navigator.pop(context);
        },
        icon: const Icon(Icons.arrow_back, size: 20, color: Colors.white),
        label: Text(
          'VOLTAR MENU',
          style: GoogleFonts.montserrat(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
            color: Colors.white,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.fundoEscuro,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          elevation: 4,
          shadowColor: AppColors.fundoEscuro.withOpacity(0.3),
        ),
      ),
    );
  }

  /// Retorna ícone do clima baseado na condição climática
  IconData _getClimaIcon(String clima) {
    switch (clima) {
      case 'Ensolarado':
        return Icons.wb_sunny;
      case 'Nublado':
        return Icons.cloud;
      case 'Chuva':
        return Icons.umbrella;
      default:
        return Icons.wb_cloudy;
    }
  }
}
