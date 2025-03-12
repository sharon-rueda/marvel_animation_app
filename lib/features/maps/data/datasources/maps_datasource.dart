import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/entities/entity_either.dart';
import '../../../../core/env/config_env.dart';
import '../../../../core/network/dio_network.dart';
import '../../../../core/network/error/exceptions.dart';
import '../../../../core/network/error/failures.dart';
import '../../../../core/utils/constants/network_paths.dart';
import '../../../../shared/domain/models/api_response_model.dart';
import '../../domain/mappers/marker_mapper.dart';
import '../../domain/models/marker_model.dart';

final Provider<MapsDatasource> homeDatasourceProvider =
    Provider<MapsDatasource>((Ref<MapsDatasource> ref) {
  return MapsDatasource();
});

class MapsDatasource {
  Dio dio = DioNetwork.getDio(baseUrl: ConfigENV.intance.getAppEnv.mapsApiUrl);

  Future<Either<Failure, ApiResponseModel<MarkerModel?>>>
      getMapLocation() async {
    try {
      final Response<Map<String, dynamic>> result =
          await dio.get(getMapsPath());

      if (result.data == null) {
        return Left(ServerFailure("Invalid response", result.statusCode ?? -1));
      }

      final MarkerModel marker = MarkerMapper.fromJson(result.data ?? {});

      return Right(ApiResponseModel<MarkerModel>(
        status: result.statusCode.toString(),
        results: marker,
      ));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, e.statusCode));
    } catch (e) {
      return Left(const ServerFailure('Error parsing data', -1));
    }
  }
}
