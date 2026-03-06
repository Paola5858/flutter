import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

/// Modelo de dados para a fazenda
/// Contém todas as informações sobre a fazenda e seus sensores
class FazendaModel {
  final String nome;
  final String localizacao;
  final String status; // "Online" ou "Offline"
  final double umidade; // porcentagem 0-100
  final double temperatura; // celsius
  final String nutrientes; // "OK", "Baixo", "Alto"
  final String clima; // "Ensolarado", "Nublado", "Chuva"
  final String iconeClima; // nome do MaterialIcon
  final DateTime ultimaLeitura;

  const FazendaModel({
    required this.nome,
    required this.localizacao,
    required this.status,
    required this.umidade,
    required this.temperatura,
    required this.nutrientes,
    required this.clima,
    required this.iconeClima,
    required this.ultimaLeitura,
  });

  /// Getter que classifica a umidade do solo
  /// Retorna uma string descritiva baseada no nível de umidade
  String get statusUmidade {
    if (umidade < 40) return 'seco — irrigar agora';
    if (umidade > 85) return 'solo saturado';
    return 'condição ideal';
  }

  /// Getter que retorna a cor do status de umidade
  /// Usa cores de alerta para indicar condição crítica
  Color get corUmidade {
    if (umidade < 40) return AppColors.alertaSeco;
    if (umidade > 85) return AppColors.azulUmidade;
    return AppColors.alertaIdeal;
  }

  /// Getter de tempo desde última leitura
  /// Retorna string formatada com minutos ou horas
  String get tempoLeitura {
    final diff = DateTime.now().difference(ultimaLeitura);
    if (diff.inMinutes < 60) return 'há ${diff.inMinutes}min';
    return 'há ${diff.inHours}h';
  }

  /// Retorna ícone do clima baseado na condição climática
  IconData get iconeClimaWidget {
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

  /// Retorna cor para status dos nutrientes
  Color get corNutrientes {
    switch (nutrientes) {
      case 'OK':
        return AppColors.alertaIdeal;
      case 'Baixo':
        return AppColors.alertaSeco;
      case 'Alto':
        return AppColors.azulUmidade;
      default:
        return AppColors.douradoTrigo;
    }
  }

  /// Retorna cor para status da fazenda (Online/Offline)
  Color get corStatus {
    return status == 'Online' ? AppColors.alertaIdeal : AppColors.alertaSeco;
  }
}

/// Dados mockados da fazenda para exemplo
final FazendaModel fazendaMockada = FazendaModel(
  nome: 'Fazenda São João',
  localizacao: 'Goiânia, GO',
  status: 'Online',
  umidade: 65.0,
  temperatura: 28.5,
  nutrientes: 'OK',
  clima: 'Ensolarado',
  iconeClima: 'wb_sunny',
  ultimaLeitura: DateTime.now().subtract(const Duration(minutes: 15)),
);
