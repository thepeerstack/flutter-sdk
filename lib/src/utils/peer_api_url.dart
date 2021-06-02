
class PeerApiURL {
  //Base URL
  static const String base = 'https://send.api.thepeer.co';

  // Send
  static const String send = '$base/send';
  static const String businesses = '$send/businesses';
  static const String business = '$send/business';

  // Receipt
  static const String receipt = '$send/receipt';

  // Resolve
  static const String resolve = '$send/resolve';

  static String resolveUser({
    required String businessId,
    required String identifier,
  }) =>
      '$resolve?business_id=$businessId&identifier=$identifier';

  static String resolveUserRef({
    required String ref,
  }) =>
      '$resolve?reference=$ref';
}
