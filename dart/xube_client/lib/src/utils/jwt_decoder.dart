/* 
Example result from parseJwtHeader

{
  kid: AZbTwwQ67hhxaLnOPTeidkxglE9kP/+LooGRz8x6tFA=, 
  alg: RS256
}

Example result from parseJwtPayLoad
{
  sub: 9a452078-d166-42bc-80eb-2d536cb04d15, 
  email_verified: false, 
  iss: https://cognito-idp.eu-west-1.amazonaws.com/eu-west-1_biyNqoM8w, 
  cognito:username: 9a452078-d166-42bc-80eb-2d536cb04d15, 
  origin_jti: c444eef3-fc4d-4df2-a9fe-3599ce7e3c27, 
  aud: 706nhv3h0bb1nr0bns1o25ph2r, 
  event_id: a5550c90-adfe-48e5-8b31-d1272cd504fb, 
  token_use: id, 
  auth_time: 1655821249, 
  exp: 1655824849, 
  iat: 1655821249, 
  jti: da5f39a7-00f7-4b9b-9e3c-36ddfdd8b522, 
  email: test5@test.com
}
*/

import 'dart:convert';

Map<String, dynamic> parseJwtPayLoad(String token) {
  final parts = token.split('.');
  if (parts.length != 3) {
    throw Exception('Invalid token');
  }

  final payload = _decodeBase64(parts[1]);
  final payloadMap = json.decode(payload);
  if (payloadMap is! Map<String, dynamic>) {
    throw Exception('Invalid payload');
  }

  return payloadMap;
}

Map<String, dynamic> parseJwtHeader(String token) {
  final parts = token.split('.');
  if (parts.length != 3) {
    throw Exception('Invalid token');
  }

  final payload = _decodeBase64(parts[0]);
  final payloadMap = json.decode(payload);
  if (payloadMap is! Map<String, dynamic>) {
    throw Exception('Invalid payload');
  }

  return payloadMap;
}

String _decodeBase64(String str) {
  String output = str.replaceAll('-', '+').replaceAll('_', '/');

  switch (output.length % 4) {
    case 0:
      break;
    case 2:
      output += '==';
      break;
    case 3:
      output += '=';
      break;
    default:
      throw Exception('Illegal base64url string!');
  }

  return utf8.decode(base64Url.decode(output));
}
