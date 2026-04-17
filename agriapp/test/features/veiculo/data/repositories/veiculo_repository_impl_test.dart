import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:agriapp/features/veiculo/data/repositories/veiculo_repository_impl.dart';
import 'package:agriapp/features/veiculo/data/datasources/remote/veiculo_remote_datasource.dart';
import 'package:agriapp/features/veiculo/data/datasources/local/veiculo_local_datasource.dart';
import 'package:agriapp/features/veiculo/data/models/veiculo_model.dart';

// Generate mocks with: flutter pub run build_runner build
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
      mockRemoteDataSource,
      mockLocalDataSource,
    );
  });

  group('getVeiculos offline fallback', () {
    final tVeiculoModelList = [
      VeiculoModel(
        id: 1,
        descricao: 'Trator JD',
        marcaId: 1,
        modeloId: 1,
        ano: 2020,
        horimetro: 1000,
      ),
    ];

    test('should return cached local data when remote fails', () async {
      // Arrange
      when(
        mockRemoteDataSource.getVeiculos(),
      ).thenThrow(Exception('No internet connection'));
      when(
        mockLocalDataSource.getCachedVeiculos(),
      ).thenAnswer((_) async => tVeiculoModelList);

      // Act
      final result = await repository.getVeiculos();

      // Assert
      expect(result.first.descricao, equals('Trator JD'));
      verify(mockRemoteDataSource.getVeiculos()).called(1);
      verify(mockLocalDataSource.getCachedVeiculos()).called(1);
      verifyNever(mockLocalDataSource.cacheVeiculos(any));
    });

    test('should return remote data and cache it when successful', () async {
      // Arrange
      when(
        mockRemoteDataSource.getVeiculos(),
      ).thenAnswer((_) async => tVeiculoModelList);
      when(
        mockLocalDataSource.cacheVeiculos(tVeiculoModelList),
      ).thenAnswer((_) async => null);

      // Act
      final result = await repository.getVeiculos();

      // Assert
      expect(result.first.descricao, equals('Trator JD'));
      verify(mockRemoteDataSource.getVeiculos()).called(1);
      verify(mockLocalDataSource.cacheVeiculos(tVeiculoModelList)).called(1);
    });
  });
}
