import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';
import '../core/theme/app_tokens.dart';
import '../models/domain.dart';
import 'app/app_surface.dart';

class IndicadorCard extends StatelessWidget {
  final Indicador indicador;
  final Medicao medicao;
  const IndicadorCard({
    super.key,
    required this.indicador,
    required this.medicao,
  });

  @override
  Widget build(BuildContext context) {
    final status = medicao.calcularStatus(indicador);
    final color = _statusColor(status);
    return AppSurface(
      padding: const EdgeInsets.fromLTRB(17, 16, 17, 15),
      borderRadius: BorderRadius.circular(AppRadii.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: color,
                  boxShadow: [
                    BoxShadow(
                      color: color.withValues(alpha: .6),
                      blurRadius: 9,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  indicador.nome,
                  style: AppTypography.button.copyWith(color: AppColors.ink,
                  ),
                ),
              ),
              _StatusTag(status: status, color: color),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                medicao.valor.toStringAsFixed(1),
                style: AppTypography.metric.copyWith(letterSpacing: -1),
              ),
              const SizedBox(width: 7),
              Padding(
                padding: const EdgeInsets.only(bottom: 2),
                child: Text(
                  indicador.tipoInformacao.unidadeMedida.simbolo,
                  style: AppTypography.metricUnit.copyWith(
                    color: AppColors.inkMuted,
                  ),
                ),
              ),
              const Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'meta',
                    style: AppTypography.metadata.copyWith(
                      color: AppColors.inkMuted,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    '${indicador.metaValor.toStringAsFixed(0)} ${indicador.tipoInformacao.unidadeMedida.simbolo}',
                    style: AppTypography.button.copyWith(
                      color: AppColors.ink,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: _progress,
                    minHeight: 5,
                    backgroundColor: Colors.white.withValues(alpha: .08),
                    valueColor: AlwaysStoppedAnimation(color),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                _statusLabel(status),
                style: TextStyle(
                  color: color,
                  fontSize: AppTypography.status.fontSize,
                  fontWeight: AppTypography.status.fontWeight,
                ),
              ),
            ],
          ),
          const SizedBox(height: 13),
          Row(
            children: [
              const Icon(
                Icons.factory_outlined,
                size: 12,
                color: AppColors.inkMuted,
              ),
              const SizedBox(width: 5),
              Expanded(
                child: Text(
                  '${medicao.equipamento.unidade.usina.nome}  ›  ${medicao.equipamento.unidade.nome}  ›  ${medicao.equipamento.nome}',
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.metadata.copyWith(
                    color: AppColors.inkMuted,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              const Icon(
                Icons.schedule_outlined,
                size: 13,
                color: AppColors.inkMuted,
              ),
              const SizedBox(width: 5),
              Text(
                _formatDate(medicao.data),
                style: AppTypography.metadata.copyWith(
                  color: AppColors.inkMuted,
                ),
              ),
              const Spacer(),
              Flexible(
                child: Text(
                  indicador.descricao,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.metadata.copyWith(
                    color: AppColors.inkMuted,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  double get _progress => indicador.metaValor == 0
      ? 0
      : (medicao.valor / indicador.metaValor).clamp(0.0, 1.0);
  Color _statusColor(StatusIndicador status) => switch (status) {
    StatusIndicador.dentroMeta => const Color(0xff91dfb7),
    StatusIndicador.atencao => const Color(0xfff2c476),
    StatusIndicador.foraMeta => const Color(0xffec8fa9),
  };
  String _statusLabel(StatusIndicador status) => switch (status) {
    StatusIndicador.dentroMeta => 'estável',
    StatusIndicador.atencao => 'observar',
    StatusIndicador.foraMeta => 'intervir',
  };
  String _formatDate(DateTime date) =>
      '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}  ·  atualização';
}

class _StatusTag extends StatelessWidget {
  final StatusIndicador status;
  final Color color;
  const _StatusTag({required this.status, required this.color});
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
    decoration: BoxDecoration(
      color: color.withValues(alpha: .1),
      borderRadius: BorderRadius.circular(8),
      border: Border.all(color: color.withValues(alpha: .24)),
    ),
    child: Text(switch (status) {
      StatusIndicador.dentroMeta => 'dentro da meta',
      StatusIndicador.atencao => 'atenção',
      StatusIndicador.foraMeta => 'fora da meta',
    }, style: AppTypography.status.copyWith(color: color, fontSize: 9)),
  );
}
