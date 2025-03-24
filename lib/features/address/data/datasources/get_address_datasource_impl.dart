import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uex_app/core/infra/http_client.dart';
import 'package:uex_app/features/address/data/datasources/get_address_datasource.dart';
import 'package:uex_app/features/address/data/exceptions/exceptions.dart';
import 'package:uex_app/features/address/data/model/address_model.dart';

final class GetAddressDatasourceImpl implements GetAddressDatasource {
  const GetAddressDatasourceImpl(
      {required this.client, required this.localStorage});
  final HttpClient client;
  final SharedPreferences localStorage;

  @override
  Future<AddressModel> getAddress({required String cep}) async {
    try {
      final Response result =
          await client.get('https://viacep.com.br/ws/$cep/json/');

      return AddressModel.fromMap(result.data);
    } on DioException catch (e, s) {
      if (kDebugMode) {
        debugPrintStack(label: e.toString(), stackTrace: s);
      }
      throw const GetAddressException(
          message: 'Falha ao buscar dados do endereço');
    } catch (e, s) {
      if (kDebugMode) {
        debugPrintStack(label: e.toString(), stackTrace: s);
      }
      throw const GetAddressException(message: 'Erro inesperado');
    }
  }

  @override
  Future<List<AddressModel>> getAddressByUF(
      {required String uf,
      required String city,
      required String address}) async {
    try {
      final Response result =
          await client.get('https://viacep.com.br/ws/$uf/$city/$address/json/');

      final List<dynamic> data = result.data;

      return data.map((item) => AddressModel.fromMap(item)).toList();
    } on DioException catch (e, s) {
      if (kDebugMode) {
        debugPrintStack(label: e.toString(), stackTrace: s);
      }
      throw const GetAddressException(
          message: 'Falha ao buscar dados do endereço');
    } catch (e, s) {
      if (kDebugMode) {
        debugPrintStack(label: e.toString(), stackTrace: s);
      }
      throw const GetAddressException(message: 'Erro inesperado');
    }
  }
}
