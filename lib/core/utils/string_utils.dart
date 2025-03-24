String formatarCPF(String cpf) {
  if (cpf.length != 11) {
    throw Exception('CPF inválido. O CPF deve conter 11 dígitos.');
  }

  final cpfFormatado =
      '${cpf.substring(0, 3)}.${cpf.substring(3, 6)}.${cpf.substring(6, 9)}-${cpf.substring(9)}';

  return cpfFormatado;
}

String cpfWithoutMask(String cpf) =>
    cpf.replaceAll('.', '').replaceAll('-', '')..replaceAll('/', '');

String cepWithoutMask(String cep) => cep.replaceAll('-', '');
