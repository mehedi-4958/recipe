import 'package:chopper/chopper.dart';
import 'package:recipe/network/model_response.dart';
import 'package:recipe/network/recipe_model.dart';
import 'model_converter.dart';

part 'recipe_service.chopper.dart';

const String apiKey = '84d9850df6e45943ccb561e2e7e734aa';
const String apiId = '9dab0bf9';
const String apiUrl = 'https://api.edamam.com';

@ChopperApi()
abstract class RecipeService extends ChopperService {
  @Get(path: 'search')
  Future<Response<Result<APIRecipeQuery>>> queryRecipe(
    @Query('q') String query,
    @Query('from') int from,
    @Query('to') int to,
  );

  static RecipeService create() {
    final client = ChopperClient(
        baseUrl: apiUrl,
        interceptors: [_addQuery, HttpLoggingInterceptor()],
        converter: ModelConverter(),
        errorConverter: const JsonConverter(),
        services: [
          _$RecipeService(),
        ]);
    return _$RecipeService(client);
  }
}

Request _addQuery(Request req) {
  final params = Map<String, dynamic>.from(req.parameters);

  params['app_id'] = apiId;
  params['app_key'] = apiKey;

  return req.copyWith(parameters: params);
}
