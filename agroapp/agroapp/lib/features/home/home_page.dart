import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';
import '../../shared/models/fazenda_model.dart';
import '../details/details_page.dart';

/// Tela principal do app - Home Page
/// Exibe informações resumidas da fazenda e navegação para detalhes
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Usa dados mockados para exemplo
    final fazenda = fazendaMockada;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'AgroControl',
          style: GoogleFonts.cormorantGaramond(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          // Badge de notificação com Stack + Positioned
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.notifications_outlined),
                onPressed: () {
                  // Ação de notificação (placeholder)
                },
              ),
              Positioned(
                right: 8,
                top: 8,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: Colors.orange,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Bloco 1 - Identidade da fazenda
            _buildIdentidadeFazenda(fazenda),
            const SizedBox(height: 24),

            // Bloco 2 - Status da máquina
            _buildStatusMaquina(fazenda),
            const SizedBox(height: 24),

            // Bloco 3 - Preview rápido de dados (3 chips)
            _buildPreviewDados(fazenda),
            const SizedBox(height: 24),

            // Bloco 4 - Badge de status da umidade
            _buildBadgeUmidade(fazenda),
            const SizedBox(height: 24),

            // Bloco 5 - Botão principal
            _buildBotaoPrincipal(context, fazenda),
          ],
        ),
      ),
    );
  }

  /// Bloco 1 — Identidade da fazenda
  Widget _buildIdentidadeFazenda(FazendaModel fazenda) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.verdeOliva.withOpacity(0.08),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.douradoTrigo.withOpacity(0.3),
        ),
      ),
      child: Row(
        children: [
          // Ícone agriculture
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: AppColors.verdeOliva.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.agriculture,
              color: AppColors.verdeOliva,
              size: 32,
            ),
          ),
          const SizedBox(width: 16),
          // Textos
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                fazenda.nome,
                style: GoogleFonts.lora(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: AppColors.fundoEscuro,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                fazenda.localizacao,
                style: GoogleFonts.montserrat(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Bloco 2 — Status da máquina com círculo pulsante
  Widget _buildStatusMaquina(FazendaModel fazenda) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Círculo pulsante
        PulsingDot(color: fazenda.corStatus),
        const SizedBox(width: 8),
        Text(
          'Status: ${fazenda.status}',
          style: GoogleFonts.montserrat(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.fundoEscuro,
          ),
        ),
      ],
    );
  }

  /// Bloco 3 — Preview rápido de dados (3 chips)
  Widget _buildPreviewDados(FazendaModel fazenda) {
    return Row(
      children: [
        // Chip de umidade
        DataChip(
          icone: Icons.water_drop,
          valor: '${fazenda.umidade.toStringAsFixed(0)}%',
          label: 'umidade',
          cor: AppColors.azulUmidade,
        ),
        // Chip de temperatura
        DataChip(
          icone: Icons.thermostat,
          valor: '${fazenda.temperatura.toStringAsFixed(1)}°C',
          label: 'temperatura',
          cor: AppColors.douradoTrigo,
        ),
        // Chip de nutrientes
        DataChip(
          icone: Icons.eco,
          valor: fazenda.nutrientes,
          label: 'nutrientes',
          cor: AppColors.alertaIdeal,
        ),
      ],
    );
  }

  /// Bloco 4 — Badge de status da umidade
  Widget _buildBadgeUmidade(FazendaModel fazenda) {
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: fazenda.corUmidade.withOpacity(0.15),
          borderRadius: BorderRadius.circular(100),
          border: Border.all(
            color: fazenda.corUmidade,
            width: 1,
          ),
        ),
        child: Text(
          fazenda.statusUmidade,
          style: GoogleFonts.montserrat(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: fazenda.corUmidade,
          ),
        ),
      ),
    );
  }

  /// Bloco 5 — Botão principal
  Widget _buildBotaoPrincipal(BuildContext context, FazendaModel fazenda) {
    return SizedBox(
      height: 56,
      child: ElevatedButton(
        onPressed: () {
          // Navegação push para DetailsPage passando o objeto FazendaModel
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DetailsPage(fazenda: fazenda),
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.verdeOliva,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          elevation: 4,
          shadowColor: AppColors.verdeOliva.withOpacity(0.3),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'VER DADOS DO SOLO',
              style: GoogleFonts.montserrat(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.arrow_forward, size: 20, color: Colors.white),
          ],
        ),
      ),
    );
  }
}

/// Widget do círculo pulsante com animação
/// Usa AnimationController com SingleTickerProviderStateMixin
/// O controlador repete reversamente para criar efeito de pulsação
class PulsatingDot extends StatefulWidget {
  final Color color;
  
  const PulsatingDot({required this.color, super.key});

  @override
  State<PulsatingDot> createState() => _PulsatingDotState();
}

class _PulsatingDotState extends State<PulsatingDot>
    with SingleTickerProviderStateMixin {
  // Controlador de animação para o efeito pulsante
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    // Inicializa o controlador de animação com duração de 800ms
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true); // Repete reversamente para efeito contínuo
    
    // Animação de opacidade entre 0.3 e 1.0
    _animation = Tween<double>(begin: 0.3, end: 1.0).animate(_controller);
  }

  @override
  void dispose() {
    // Importante: dispose() em todo AnimationController para evitar memory leaks
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _animation,
      child: Container(
        width: 10,
        height: 10,
        decoration: BoxDecoration(
          color: widget.color,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}

/// Alias para manter compatibilidade com o nome usado no código
class PulsingDot extends PulsatingDot {
  PulsingDot({required Color color, super.key}) : super(color: color);
}

/// Widget reutilizável para chips de dados
/// Exibe ícone, valor e label em um container estilizado
class DataChip extends StatelessWidget {
  final IconData icone;
  final String valor;
  final String label;
  final Color cor;

  const DataChip({
    super.key,
    required this.icone,
    required this.valor,
    required this.label,
    required this.cor,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        decoration: BoxDecoration(
          color: cor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: cor.withOpacity(0.25),
          ),
        ),
        child: Column(
          children: [
            Icon(icone, color: cor, size: 22),
            const SizedBox(height: 6),
            Text(
              valor,
              style: GoogleFonts.montserrat(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.fundoEscuro,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: GoogleFonts.montserrat(
                fontSize: 10,
                letterSpacing: 0.8,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
