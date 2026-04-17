import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:agriapp/features/veiculo/data/repositories/veiculo_repository_impl.dart';
import 'package:agriapp/features/veiculo/data/datasources/remote/veiculo_remote_datasource.dart';
import 'package:agriapp/features/veiculo/data/datasources/local/veiculo_local_datasource.dart';
import 'package:agriapp/features/veiculo/data/models/veiculo_model.dart';

@GenerateMocks([VeiculoRemoteDataSource, VeiculoLocalDataSource])
import 'veiculo_repository_impl_test.mocks.dart';

void main() {
  late VeiculoRepositoryImpl repository;
  late MockVeiculoRemoteDataSource mockRemoteDataSource;
  late MockVeiculoLocalDataSource mockLocalDataSource;

  setUp(() {
    mockRemoteDataSource = MockVeiculoRemoteDataSource();
    mockLocalDataSource = MockVeiculoLocalDataSource();
    repository = VeiculoRepositoryImpl(
      remote: mockRemoteDataSource,
      local: mockLocalDataSource,
    );
  });

  group('getVeiculos offline fallback', () {
    final tVeiculoModelList = [
      const VeiculoModel(id: '1', nome: 'Trator JD', marca: 'John Deere')
    ];

    test('deve retornar dados do cache local quando a API falhar', () async {
      // Arrange
      // Simula falha catastrófica de rede no campo
      when(mockRemoteDataSource.fetchVeiculos())
          .thenThrow(Exception('No internet connection'));
      // Mock do Hive retornando dados previamente sincronizados
      when(mockLocalDataSource.getCachedVeiculos())
          .thenAnswer((_) async => tVeiculoModelList);

      // Act
      final result = await repository.getVeiculos();

      // Assert
      expect(result.first.nome, equals('Trator JD'));
      verify(mockRemoteDataSource.fetchVeiculos()).called(1);
      verify(mockLocalDataSource.getCachedVeiculos()).called(1);
    });
  });
}